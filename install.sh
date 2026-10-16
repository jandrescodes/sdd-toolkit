#!/usr/bin/env bash
# install.sh — instala las skills y slash commands del toolkit SDD.
# Fuente única de verdad: plugins/sdd/. Este script copia DESDE ahí.
#
#   ./install.sh --target claude|opencode|both [--dry-run] [--force] [--prune]
#
# claude   → ~/.claude/skills/            + ~/.claude/commands/
# opencode → ~/.config/opencode/skills/   + ~/.config/opencode/commands/
#
# Los commands del plugin no llevan prefijo (el plugin los expone como
# `/sdd:<fase>`). Al instalarlos sueltos en un directorio plano, este script
# les antepone `sdd-` para que no colisionen: `/sdd-<fase>`.
set -eu

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC_SKILLS="$ROOT/plugins/sdd/skills"
SRC_COMMANDS="$ROOT/plugins/sdd/commands"

TARGET=""
DRY_RUN=0
FORCE=0
PRUNE=0

usage() {
  cat >&2 <<'EOF'
Uso: ./install.sh --target claude|opencode|both [--dry-run] [--force] [--prune]

  claude    ~/.claude/skills/            + ~/.claude/commands/
  opencode  ~/.config/opencode/skills/   + ~/.config/opencode/commands/
  both      ambos

  --dry-run  muestra qué copiaría sin escribir
  --force    sobrescribe archivos de destino que difieren del origen
  --prune    borra del destino los archivos del toolkit que ya no existen en el origen
EOF
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --target)
      if [ $# -lt 2 ]; then echo "--target necesita un valor." >&2; usage; fi
      TARGET="$2"; shift 2 ;;
    --target=*) TARGET="${1#*=}"; shift ;;
    --dry-run) DRY_RUN=1; shift ;;
    --force) FORCE=1; shift ;;
    --prune) PRUNE=1; shift ;;
    -h|--help) usage ;;
    *) echo "Argumento no reconocido: $1" >&2; usage ;;
  esac
done

case "$TARGET" in
  claude|opencode|both) ;;
  *) echo "Falta --target válido (claude|opencode|both)." >&2; usage ;;
esac

changed=0

# copy_tree <dir-origen> <dir-destino> [prefijo-para-archivos-en-la-raíz]
copy_tree() {
  local src="$1" dst="$2" prefix="${3:-}" rel f target
  [ -d "$src" ] || return 0
  while IFS= read -r f; do
    rel="${f#"$src"/}"
    # El prefijo solo aplica a archivos en la raíz del árbol (los commands),
    # no a archivos anidados dentro de una skill.
    case "$rel" in
      */*) target="$dst/$rel" ;;
      *)   target="$dst/$prefix$rel" ;;
    esac
    if [ -f "$target" ] && cmp -s "$f" "$target"; then
      continue
    fi
    if [ -f "$target" ] && [ "$FORCE" -eq 0 ]; then
      echo "  omito (difiere, usa --force): ${target/#$HOME/\~}"
      continue
    fi
    if [ "$DRY_RUN" -eq 1 ]; then
      echo "  copiaría: ${target/#$HOME/\~}"
    else
      mkdir -p "$(dirname "$target")"
      cp "$f" "$target"
      echo "  ${target/#$HOME/\~}"
    fi
    changed=$((changed + 1))
  done < <(find "$src" -type f)
}

# prune_tree <dir-origen> <dir-destino> [prefijo]
# Solo mira lo que el toolkit instala: las carpetas de sus skills y los
# commands con su prefijo. Nunca toca skills o commands ajenos del destino.
prune_tree() {
  local src="$1" dst="$2" prefix="${3:-}" f rel d name
  [ -d "$dst" ] || return 0
  if [ -n "$prefix" ]; then
    while IFS= read -r f; do
      name="$(basename "$f")"
      [ -f "$src/${name#"$prefix"}" ] && continue
      prune_file "$f"
    done < <(find "$dst" -maxdepth 1 -type f -name "$prefix*.md")
  else
    for d in "$src"/*/; do
      name="$(basename "$d")"
      [ -d "$dst/$name" ] || continue
      while IFS= read -r f; do
        rel="${f#"$dst"/}"
        [ -f "$src/$rel" ] && continue
        prune_file "$f"
      done < <(find "$dst/$name" -type f)
    done
  fi
}

prune_file() {
  if [ "$PRUNE" -eq 0 ]; then
    echo "  huérfano (usa --prune): ${1/#$HOME/\~}"
  elif [ "$DRY_RUN" -eq 1 ]; then
    echo "  borraría: ${1/#$HOME/\~}"
  else
    rm -- "$1"
    echo "  borrado: ${1/#$HOME/\~}"
  fi
}

install_claude() {
  echo "Claude Code:"
  copy_tree "$SRC_SKILLS" "$HOME/.claude/skills"
  copy_tree "$SRC_COMMANDS" "$HOME/.claude/commands" "sdd-"
  prune_tree "$SRC_SKILLS" "$HOME/.claude/skills"
  prune_tree "$SRC_COMMANDS" "$HOME/.claude/commands" "sdd-"
}

install_opencode() {
  echo "opencode:"
  copy_tree "$SRC_SKILLS" "$HOME/.config/opencode/skills"
  copy_tree "$SRC_COMMANDS" "$HOME/.config/opencode/commands" "sdd-"
  prune_tree "$SRC_SKILLS" "$HOME/.config/opencode/skills"
  prune_tree "$SRC_COMMANDS" "$HOME/.config/opencode/commands" "sdd-"
}

if [ "$TARGET" = "claude" ] || [ "$TARGET" = "both" ]; then install_claude; fi
if [ "$TARGET" = "opencode" ] || [ "$TARGET" = "both" ]; then install_opencode; fi

echo
if [ "$DRY_RUN" -eq 1 ]; then
  echo "dry-run: $changed archivo(s) se copiarían."
elif [ "$changed" -eq 0 ]; then
  echo "Sin cambios (ya estaba al día)."
else
  echo "Listo: $changed archivo(s)."
fi
