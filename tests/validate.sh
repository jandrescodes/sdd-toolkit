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

echo
if [ "$errors" -eq 0 ]; then
  echo "OK — sin problemas."
  exit 0
else
  echo "FALLO — $errors problema(s)."
  exit 1
fi
