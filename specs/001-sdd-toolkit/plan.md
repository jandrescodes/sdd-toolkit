# Plan técnico — Spec 001

## Estructura de módulos

- `.claude-plugin/marketplace.json` → marketplace con un plugin `sdd` (RF-1).
- `plugins/sdd/.claude-plugin/plugin.json` → manifiesto del plugin (RF-1).
- `plugins/sdd/skills/spec-generator/` → skill de entrevista (RF-10).
- `plugins/sdd/skills/sdd/` → skill de flujo + `templates/` (RF-9, RF-20).
- `plugins/sdd/commands/*.md` → 8 slash commands (RF-9..RF-17).
- `install.sh` → distribución para opencode y Claude Code sin plugin (RF-2..RF-8).
- `tests/validate.sh` → puerta de calidad (RF-19).
- `docs/`, `specs/001-sdd-toolkit/` → dogfood, ejemplo vivo (RF-20).

## Contrato de `install.sh`

```
install.sh --target claude|opencode|both [--dry-run] [--force]
```

- Origen: `plugins/sdd/skills/` y `plugins/sdd/commands/` (RF-18).
- Destinos:
  - claude   → `~/.claude/skills/`   + `~/.claude/commands/`
  - opencode → `~/.config/opencode/skills/` + `~/.config/opencode/command/`
- Copia archivo a archivo. Si el destino existe y es idéntico → nada (RF-5).
  Si existe y difiere → omite + avisa, salvo `--force` (RF-6).
- `--dry-run` → imprime acciones, no escribe (RF-7).
- target inválido o ausente → uso + exit 1 (RF-8).
- `mkdir -p` de cada ruta de destino (caso límite).

## Decisiones técnicas

- **Plugin + script, no solo skills-dir.** El plugin da `/plugin update` y
  namespacing (`sdd:...`); el script cubre opencode y a quien no quiera plugin.
  Descartado: publicar solo como carpeta en `~/.claude/skills/` — sin commands
  namespaced ni actualización.
- **Autodiscovery de skills/ y commands/** en `plugin.json` (no se listan
  explícitamente) → menos superficie que mantener.
- **`spec-generator` separada de la skill `sdd`.** Es la única fase con
  interacción real (entrevista); mezclarla haría la skill `sdd` enorme y la
  dispararía en el momento equivocado.
- **Validación de JSON con `python3` o `node`**, lo que haya. Descartado añadir
  `jq` — es una dependencia que muchos no tienen.
- **Comparación de archivos en `install.sh` con `cmp -s`** (POSIX), no hash.
- **Los commands referencian rutas del proyecto destino** (`docs/constitution.md`,
  `specs/`), no rutas del toolkit — se ejecutan en el repo del usuario.

## Modelo de "datos" (no hay estado)

El toolkit no persiste estado. Los únicos "datos" son archivos de texto:
plantillas (origen) y sus copias (destino). El contrato es: origen manda.

## Estrategia de tests

- `tests/validate.sh` (RF-19): parsea los 2 JSON; comprueba frontmatter
  `name`+`description` en cada `SKILL.md` y `description` en cada command;
  `name` == carpeta; `bash -n install.sh`; `install.sh` ejecutable.
- Prueba de humo de `install.sh` (RF-2..RF-7): `HOME=$(mktemp -d)` +
  `install.sh --target both`, assert de rutas; segunda pasada sin diffs.
- `claude plugin validate ./plugins/sdd --strict` (RF-1).
- Demo manual end-to-end en proyecto scratch (criterios de finalización).

## Qué RF cubre cada parte

| Parte | RF |
| --- | --- |
| `marketplace.json` + `plugin.json` | RF-1, RF-19 |
| `install.sh` | RF-2..RF-8, RF-18 |
| skill `spec-generator` + command `sdd-spec` | RF-10 |
| skill `sdd` + `templates/` | RF-9, RF-20 |
| commands `sdd-*` restantes | RF-9, RF-11..RF-17 |
| `tests/validate.sh` | RF-19 |
| `docs/` + `specs/001-sdd-toolkit/` | RF-20 |
