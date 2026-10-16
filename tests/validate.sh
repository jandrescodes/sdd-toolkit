#!/usr/bin/env bash
# validate.sh — puerta de calidad del toolkit SDD.
# Sin dependencias: bash + (python3 o node) para parsear JSON.
# Falla (exit 1) y lista cada problema si algo no cumple.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN="$ROOT/plugins/sdd"
COPILOT_MARKETPLACE="$ROOT/.github/plugin/marketplace.json"
COPILOT_PLUGIN="$PLUGIN/plugin.json"
errors=0

fail() { printf '  ✗ %s\n' "$1"; errors=$((errors + 1)); }
ok()   { printf '  ✓ %s\n' "$1"; }

json_check() {
  local f="$1"
  if command -v python3 >/dev/null 2>&1; then
    python3 -m json.tool "$f" >/dev/null 2>&1
  elif command -v node >/dev/null 2>&1; then
    node -e "JSON.parse(require('fs').readFileSync(process.argv[1],'utf8'))" "$f" >/dev/null 2>&1
  else
    fail "ni python3 ni node disponibles para validar JSON"
    return 1
  fi
}

# Extrae el valor de una clave del frontmatter YAML (--- ... ---) de un .md.
frontmatter_value() {
  awk -v key="$2" '
    NR==1 && $0!="---" { exit 1 }
    NR>1 && $0=="---" { exit }
    NR>1 {
      line=$0
      if (line ~ "^"key":[ \t]*") {
        sub("^"key":[ \t]*", "", line)
        gsub(/^["\x27]|["\x27]$/, "", line)
        print line
      }
    }
  ' "$1"
}

echo "→ JSON"
for f in \
  "$ROOT/.claude-plugin/marketplace.json" \
  "$PLUGIN/.claude-plugin/plugin.json" \
  "$COPILOT_MARKETPLACE" \
  "$COPILOT_PLUGIN"; do
  if [ ! -f "$f" ]; then fail "falta $f"; continue; fi
  if json_check "$f"; then ok "${f#$ROOT/}"; else fail "JSON inválido: ${f#$ROOT/}"; fi
done

echo "→ Skills (frontmatter name + description)"
if [ -d "$PLUGIN/skills" ]; then
  while IFS= read -r sk; do
    rel="${sk#$ROOT/}"
    name="$(frontmatter_value "$sk" name)"
    desc="$(frontmatter_value "$sk" description)"
    [ -n "$name" ] || fail "$rel: sin 'name' en frontmatter"
    [ -n "$desc" ] || fail "$rel: sin 'description' en frontmatter"
    dir="$(basename "$(dirname "$sk")")"
    [ "$name" = "$dir" ] || fail "$rel: name '$name' ≠ carpeta '$dir'"
    [ -n "$name" ] && [ "$name" = "$dir" ] && [ -n "$desc" ] && ok "$rel"
  done < <(find "$PLUGIN/skills" -name SKILL.md)
fi

echo "→ Commands (frontmatter description)"
if [ -d "$PLUGIN/commands" ]; then
  while IFS= read -r cmd; do
    rel="${cmd#$ROOT/}"
    desc="$(frontmatter_value "$cmd" description)"
    if [ -n "$desc" ]; then ok "$rel"; else fail "$rel: sin 'description' en frontmatter"; fi
  done < <(find "$PLUGIN/commands" -name '*.md')
fi

echo "→ Capa de documentos (sdd-documents)"
DOCS_SKILL="$PLUGIN/skills/sdd-documents"
[ -f "$DOCS_SKILL/SKILL.md" ] && ok "skills/sdd-documents/SKILL.md" || fail "falta skills/sdd-documents/SKILL.md"
for t in prd trd acceptance changes schema delivery app-flow ux-brief; do
  [ -f "$DOCS_SKILL/templates/$t.md" ] && ok "template $t.md" || fail "falta skills/sdd-documents/templates/$t.md"
done
if [ -f "$PLUGIN/commands/docs.md" ]; then
  [ -n "$(frontmatter_value "$PLUGIN/commands/docs.md" description)" ] \
    && ok "commands/docs.md con description" || fail "commands/docs.md: sin 'description' en frontmatter"
else
  fail "falta commands/docs.md"
fi
frontmatter_value "$PLUGIN/commands/validate.md" allowed-tools | grep -qw Edit \
  && ok "validate.md lista Edit en allowed-tools" || fail "validate.md: falta Edit en allowed-tools"
grep -qF '## Changes' "$PLUGIN/commands/change.md" \
  && ok "change.md menciona ## Changes" || fail "change.md: no menciona '## Changes'"
# Cuenta las líneas "Docs profile:" fuera de comentarios HTML (también multilínea).
profile_lines="$(awk '
  { line=$0; out=""
    while (length(line)) {
      if (c) { i=index(line,"-->"); if (!i) line=""; else { line=substr(line,i+3); c=0 } }
      else   { i=index(line,"<!--"); if (!i) { out=out line; line="" } else { out=out substr(line,1,i-1); line=substr(line,i+4); c=1 } }
    }
    if (out ~ /Docs profile:/) n++ }
  END { print n+0 }' "$PLUGIN/skills/sdd-flow/templates/AGENTS-sdd-section.md")"
[ "$profile_lines" = "1" ] \
  && ok "AGENTS-sdd-section.md: una línea activa 'Docs profile:'" \
  || fail "AGENTS-sdd-section.md: $profile_lines líneas activas 'Docs profile:' (debe haber 1)"

for t in app-flow ux-brief; do
  grep -qF '## Notes (hand-written)' "$DOCS_SKILL/templates/$t.md" \
    && ok "$t.md: encabezado de notas" || fail "$t.md: falta '## Notes (hand-written)'"
done

# Cada `templates/<archivo>.md` citado por un SKILL.md o comando debe existir (sin comentarios HTML).
# En un SKILL.md se resuelve contra su propia carpeta; en un comando exige el prefijo `<skill>/`.
strip_html_comments() {
  awk '{ line=$0; out=""
    while (length(line)) {
      if (c) { i=index(line,"-->"); if (!i) line=""; else { line=substr(line,i+3); c=0 } }
      else   { i=index(line,"<!--"); if (!i) { out=out line; line="" } else { out=out substr(line,1,i-1); line=substr(line,i+4); c=1 } }
    }
    print out }' "$1"
}
while IFS= read -r f; do
  rel="${f#$ROOT/}"
  refs="$(strip_html_comments "$f" | grep -oE '([a-z0-9-]+/)?templates/[A-Za-z0-9._-]+\.md' | sort -u)"
  [ -n "$refs" ] || continue
  bad=0
  while IFS= read -r r; do
    case "$f" in
      */SKILL.md) skill_dir="$(dirname "$f")"; [[ "$r" == */templates/* ]] && target="$PLUGIN/skills/$r" || target="$skill_dir/$r" ;;
      *) [[ "$r" == */templates/* ]] && target="$PLUGIN/skills/$r" || target="" ;;
    esac
    if [ -z "$target" ]; then fail "$rel: referencia '$r' sin prefijo de skill"; bad=1
    elif [ ! -f "$target" ]; then fail "$rel: references $r, which does not exist"; bad=1; fi
  done <<< "$refs"
  [ "$bad" = 0 ] && ok "$rel: referencias a plantillas válidas"
done < <(find "$PLUGIN/skills" "$PLUGIN/commands" \( -name SKILL.md -o -path '*/commands/*.md' \))

# El formateador de Markdown rompe las líneas de firma con `___`; ninguna plantilla debe traer escapes.
broken="$(grep -rlE '\\\*\\\*|\\_\\_' "$PLUGIN/skills" --include='*.md' 2>/dev/null)"
[ -z "$broken" ] && ok "plantillas sin escapes \\*\\* / \\_\\_" \
  || fail "escapes rotos por el formateador en: $(printf '%s' "$broken" | tr '\n' ' ')"

echo "→ Linter de documentos generados (fixtures)"
LINT="$ROOT/tests/lint-docs.sh"
for g in "$ROOT"/tests/fixtures/docs/good-*.md; do
  bash "$LINT" "$g" >/dev/null && ok "pasa ${g#$ROOT/}" || fail "el linter rechaza ${g#$ROOT/}"
done
for b in "$ROOT"/tests/fixtures/docs/bad-*.md; do
  bash "$LINT" "$b" >/dev/null && fail "el linter acepta ${b#$ROOT/}" || ok "rechaza ${b#$ROOT/}"
done

echo "→ Versión"
# Las cuatro cadenas: plugin.json (Claude), plugin.json (Copilot) y las dos del marketplace de Copilot.
versions="$(
  { grep -o '"version": *"[^"]*"' "$PLUGIN/.claude-plugin/plugin.json"
    grep -o '"version": *"[^"]*"' "$COPILOT_PLUGIN"
    grep -o '"version": *"[^"]*"' "$COPILOT_MARKETPLACE"; } 2>/dev/null \
  | sed 's/.*: *"\(.*\)"/\1/'
)"
count="$(printf '%s\n' "$versions" | grep -c .)"
distinct="$(printf '%s\n' "$versions" | sort -u | grep -c .)"
canonical="$(printf '%s\n' "$versions" | head -n 1)"
if [ "$count" = "4" ] && [ "$distinct" = "1" ]; then
  ok "las 4 cadenas de versión coinciden ($canonical)"
else
  fail "versiones de manifiestos inconsistentes ($count cadenas, $distinct distintas): $(printf '%s' "$versions" | tr '\n' ' ')"
fi
if [ -n "$canonical" ] && grep -qF "## [$canonical]" "$ROOT/CHANGELOG.md"; then
  ok "CHANGELOG.md tiene el encabezado [$canonical]"
else
  fail "CHANGELOG.md no tiene el encabezado '## [$canonical]'"
fi

echo "→ install.sh"
if [ -f "$ROOT/install.sh" ]; then
  [ -x "$ROOT/install.sh" ] && ok "ejecutable" || fail "install.sh no es ejecutable (chmod +x)"
  bash -n "$ROOT/install.sh" && ok "sintaxis" || fail "install.sh: error de sintaxis bash"
else
  fail "falta install.sh"
fi

echo "→ install.sh — prueba de humo (HOME temporal)"
if [ -x "$ROOT/install.sh" ]; then
  SMOKE="$(mktemp -d)"
  trap 'rm -rf "$SMOKE"' EXIT

  # target ausente / inválido → salida 1
  HOME="$SMOKE" "$ROOT/install.sh" >/dev/null 2>&1 \
    && fail "sin --target debería salir 1" || ok "sin --target sale 1"
  HOME="$SMOKE" "$ROOT/install.sh" --target zzz >/dev/null 2>&1 \
    && fail "--target inválido debería salir 1" || ok "--target inválido sale 1"
  HOME="$SMOKE" "$ROOT/install.sh" --target >/dev/null 2>&1 \
    && fail "--target sin valor debería salir 1" || ok "--target sin valor sale 1"

  # --dry-run no escribe nada
  HOME="$SMOKE" "$ROOT/install.sh" --target both --dry-run >/dev/null 2>&1
  if [ -z "$(find "$SMOKE" -type f 2>/dev/null)" ]; then ok "--dry-run no escribe"; else fail "--dry-run escribió archivos"; fi

  # instalación real → los 4 destinos con archivos, commands con prefijo sdd-
  HOME="$SMOKE" "$ROOT/install.sh" --target both >/dev/null 2>&1
  for d in \
    "$SMOKE/.claude/skills/sdd-flow/SKILL.md" \
    "$SMOKE/.claude/commands/sdd-spec.md" \
    "$SMOKE/.claude/commands/sdd-docs.md" \
    "$SMOKE/.claude/skills/sdd-documents/templates/delivery.md" \
    "$SMOKE/.claude/skills/sdd-documents/templates/app-flow.md" \
    "$SMOKE/.claude/skills/sdd-documents/templates/ux-brief.md" \
    "$SMOKE/.claude/skills/sdd-documents/templates/prd.md" \
    "$SMOKE/.config/opencode/skills/sdd-flow/SKILL.md" \
    "$SMOKE/.config/opencode/commands/sdd-spec.md" \
    "$SMOKE/.config/opencode/commands/sdd-docs.md" \
    "$SMOKE/.config/opencode/skills/sdd-documents/templates/delivery.md" \
    "$SMOKE/.config/opencode/skills/sdd-documents/templates/app-flow.md" \
    "$SMOKE/.config/opencode/skills/sdd-documents/templates/ux-brief.md" \
    "$SMOKE/.config/opencode/skills/sdd-documents/templates/prd.md"; do
    [ -f "$d" ] && ok "existe ${d#$SMOKE/}" || fail "falta ${d#$SMOKE/}"
  done
  [ -f "$SMOKE/.claude/commands/spec.md" ] && fail "command sin prefijo en destino plano" || ok "commands prefijados (sin spec.md suelto)"

  # idempotencia: segunda pasada sin cambios
  out2="$(HOME="$SMOKE" "$ROOT/install.sh" --target both 2>&1)"
  printf '%s\n' "$out2" | grep -q "Sin cambios" && ok "idempotente" || fail "segunda pasada no fue idempotente: $out2"

  # --force restaura un destino modificado
  echo "modificado" >> "$SMOKE/.claude/commands/sdd-spec.md"
  HOME="$SMOKE" "$ROOT/install.sh" --target claude >/dev/null 2>&1
  cmp -s "$PLUGIN/commands/spec.md" "$SMOKE/.claude/commands/sdd-spec.md" \
    && fail "sin --force no debería sobrescribir" || ok "sin --force respeta el destino modificado"
  HOME="$SMOKE" "$ROOT/install.sh" --target claude --force >/dev/null 2>&1
  cmp -s "$PLUGIN/commands/spec.md" "$SMOKE/.claude/commands/sdd-spec.md" \
    && ok "--force restaura el destino" || fail "--force no restauró el destino"

  # huérfanos: se avisan sin --prune y se borran con --prune, sin tocar lo ajeno
  mkdir -p "$SMOKE/.claude/skills/otra-skill"
  echo x > "$SMOKE/.claude/skills/otra-skill/SKILL.md"
  echo x > "$SMOKE/.claude/skills/sdd-documents/templates/viejo.md"
  echo x > "$SMOKE/.claude/commands/sdd-viejo.md"
  echo x > "$SMOKE/.claude/commands/propio.md"
  out3="$(HOME="$SMOKE" "$ROOT/install.sh" --target claude 2>&1)"
  printf '%s\n' "$out3" | grep -q "huérfano" && [ -f "$SMOKE/.claude/commands/sdd-viejo.md" ] \
    && ok "huérfanos: avisa sin borrar" || fail "huérfanos: debería avisar sin borrar: $out3"
  HOME="$SMOKE" "$ROOT/install.sh" --target claude --prune --dry-run >/dev/null 2>&1
  [ -f "$SMOKE/.claude/commands/sdd-viejo.md" ] && ok "--prune --dry-run no borra" || fail "--prune --dry-run borró"
  HOME="$SMOKE" "$ROOT/install.sh" --target claude --prune >/dev/null 2>&1
  if [ ! -f "$SMOKE/.claude/commands/sdd-viejo.md" ] && [ ! -f "$SMOKE/.claude/skills/sdd-documents/templates/viejo.md" ]; then
    ok "--prune borra huérfanos del toolkit"; else fail "--prune no borró los huérfanos"; fi
  [ -f "$SMOKE/.claude/commands/propio.md" ] && [ -f "$SMOKE/.claude/skills/otra-skill/SKILL.md" ] \
    && ok "--prune respeta lo ajeno" || fail "--prune borró archivos ajenos al toolkit"

  rm -rf "$SMOKE"; trap - EXIT
fi

echo
if [ "$errors" -eq 0 ]; then
  echo "OK — sin problemas."
  exit 0
else
  echo "FALLO — $errors problema(s)."
  exit 1
fi
