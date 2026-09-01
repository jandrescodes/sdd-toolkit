# Plan técnico — Spec 001

## Estructura de módulos

- `.claude-plugin/marketplace.json` → marketplace con un plugin `sdd` (RF-1).
- `plugins/sdd/.claude-plugin/plugin.json` → manifiesto del plugin (RF-1).
- `plugins/sdd/skills/spec-generator/` → skill de entrevista (RF-10).
- `plugins/sdd/skills/sdd-flow/` → skill de flujo + `templates/` (RF-9, RF-20).
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
  - claude → `~/.claude/skills/` + `~/.claude/commands/`
  - opencode → `~/.config/opencode/skills/` + `~/.config/opencode/commands/`
- Los commands (archivos en la raíz del árbol de origen) se copian con el
  nombre prefijado `sdd-` para no colisionar en un directorio plano; los
  archivos anidados dentro de una skill se copian tal cual (RF-2, RF-3).
- Copia archivo a archivo. Si el destino existe y es idéntico → nada (RF-5).
  Si existe y difiere → omite + avisa, salvo `--force` (RF-6).
- `--dry-run` → imprime acciones, no escribe (RF-7).
- target inválido, ausente, o presente sin valor → uso + exit 1 (RF-8).
- `mkdir -p` de cada ruta de destino (caso límite).

## Decisiones técnicas

- **Plugin + script, no solo skills-dir.** El plugin da `/plugin update` y
  namespacing (`sdd:...`); el script cubre opencode y a quien no quiera plugin.
  Descartado: publicar solo como carpeta en `~/.claude/skills/` — sin commands
  namespaced ni actualización.
- **Commands sin prefijo en el plugin, con prefijo en el script.** Dentro del
  plugin, `constitution.md` → `/sdd:constitution` (el plugin ya namespacea);
  meterle `sdd-` daría `/sdd:sdd-constitution`. El script instala en un
  directorio plano compartido, donde `/constitution` sería demasiado genérico,
  así que ahí sí antepone `sdd-`. Descartado: un solo nombre para ambos
  destinos — obliga a elegir entre feo en el plugin o colisión en el script.
- **Ruta de commands de opencode: `commands/` (plural).** Es la que documenta
  opencode. Probado en 1.17.13: también resuelve `command/` (singular), pero no
  hay motivo para depender de un alias no documentado.
- **Autodiscovery de skills/ y commands/** en `plugin.json` (no se listan
  explícitamente) → menos superficie que mantener.
- **`spec-generator` separada de la skill `sdd-flow`.** Es la única fase con
  interacción real (entrevista); mezclarla haría la skill `sdd-flow` enorme y la
  dispararía en el momento equivocado.
- **Validación de JSON con `python3` o `node`**, lo que haya. Descartado añadir
  `jq` — es una dependencia que muchos no tienen.
- **Comparación de archivos en `install.sh` con `cmp -s`** (POSIX), no hash.
- **Los commands referencian rutas del proyecto destino** (`docs/constitution.md`,
  `specs/`), no rutas del toolkit — se ejecutan en el repo del usuario.

## Modelo de "datos" (no hay estado)

El toolkit no persiste estado. Los únicos "datos" son archivos de texto:
plantillas (origen) y sus copias (destino). El contrato es: origen manda.

## Riesgos

- **Deriva entre el plugin y las copias de `install.sh`** → `plugins/sdd/` es la
  única fuente editable (RF-18) y `tests/validate.sh` corre una prueba de humo
  real de la instalación.
- **`AGENTS.md` y `constitution.md` son Apache-2.0** → cualquier cambio de
  contenido obliga a actualizar `NOTICE`; verificado en cada tanda de mejoras.
- **Frontera de licencia difusa si se mueve `spec-template.md`** → se deja donde
  está (en `spec-generator/`), documentado en README y `SKILL.md`.

## Estrategia de verificación

- `tests/validate.sh` (RF-19): parsea los 2 JSON; comprueba frontmatter
  `name`+`description` en cada `SKILL.md` y `description` en cada command;
  `name` == carpeta; `bash -n install.sh`; `install.sh` ejecutable.
- Prueba de humo de `install.sh` **dentro de `tests/validate.sh`**
  (RF-2..RF-8): instala con `HOME=$(mktemp -d)`, verifica los 4 destinos, el
  prefijo `sdd-` en los commands, idempotencia en la segunda pasada,
  `--dry-run` sin escrituras, `--force` que restaura un destino modificado, y
  salida 1 con target ausente / inválido / sin valor.
- `claude plugin validate ./plugins/sdd --strict` (RF-1).
- Demo manual end-to-end en proyecto scratch (criterios de finalización).

## Qué RF cubre cada parte

| Parte                                     | RF                 |
| ----------------------------------------- | ------------------ |
| `marketplace.json` + `plugin.json`        | RF-1, RF-19        |
| `install.sh`                              | RF-2..RF-8, RF-18  |
| skill `spec-generator` + command `spec`   | RF-10              |
| skill `sdd-flow` + `templates/`           | RF-9, RF-20        |
| commands restantes (`clarify`, `plan`, …) | RF-9, RF-11..RF-17 |
| `tests/validate.sh`                       | RF-19              |
| `docs/` + `specs/001-sdd-toolkit/`        | RF-20              |
