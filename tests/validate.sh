#!/usr/bin/env bash
# validate.sh — puerta de calidad del toolkit SDD.
# Sin dependencias: bash + (python3 o node) para parsear JSON.
# Falla (exit 1) y lista cada problema si algo no cumple.
set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PLUGIN="$ROOT/plugins/sdd"
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
for f in "$ROOT/.claude-plugin/marketplace.json" "$PLUGIN/.claude-plugin/plugin.json"; do
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
    "$SMOKE/.config/opencode/skills/sdd-flow/SKILL.md" \
    "$SMOKE/.config/opencode/commands/sdd-spec.md"; do
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
