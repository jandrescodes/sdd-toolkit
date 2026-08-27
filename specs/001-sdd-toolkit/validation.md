# Validación — Spec 001

Recorrido RF por RF. Ejecutado el 2026-08-27.

| RF | Resumen | Evidencia | Veredicto |
| -- | ------- | --------- | --------- |
| RF-1 | Plugin expone 8 commands + 2 skills | `claude plugin install sdd@sdd-toolkit` OK en dir scratch; `plugins/sdd/commands/` tiene 8 `.md`, `plugins/sdd/skills/` tiene `sdd` y `spec-generator` | PASA |
| RF-2 | `install.sh --target opencode` → rutas opencode | Prueba de humo: archivos en `~/.config/opencode/skills/` y `~/.config/opencode/command/` | PASA |
| RF-3 | `install.sh --target claude` → rutas claude | Prueba de humo: archivos en `~/.claude/skills/` y `~/.claude/commands/` | PASA |
| RF-4 | `--target both` aplica ambos | Prueba de humo: 30 archivos en las 4 rutas | PASA |
| RF-5 | Idempotente | Segunda ejecución seguida: "Sin cambios (ya estaba al día)" | PASA |
| RF-6 | Destino que difiere se omite sin `--force` | `copy_tree`: `cmp -s` + rama "omito (difiere, usa --force)" | PASA (lógica; sin `--force` no sobrescribe) |
| RF-7 | `--dry-run` no escribe | "dry-run: N archivo(s) se copiarían", 0 archivos creados | PASA |
| RF-8 | target inválido/ausente → uso + exit 1 | `install.sh` sin args: mensaje de uso, `exit=1` | PASA |
| RF-9 | `/sdd-constitution` propone y espera aprobación | `commands/sdd-constitution.md` paso 4: "espera mi aprobación explícita" | PASA (contrato del command) |
| RF-10 | `/sdd-spec` entrevista ≤6, sin código, genera spec EARS | `commands/sdd-spec.md` + skill `spec-generator` (máx 6, una a una, EARS, "Fuera de alcance") | PASA (contrato) |
| RF-11 | `/sdd-clarify` lista sin resolver | `commands/sdd-clarify.md`: 4 bloques, "solo detecta, no resuelvas" | PASA (contrato) |
| RF-12 | `/sdd-plan` genera plan sin código | `commands/sdd-plan.md` paso 3: "NO escribas código" + secciones | PASA (contrato) |
| RF-13 | `/sdd-plan` se detiene sin constitución/spec | `commands/sdd-plan.md` paso 1: "avisa y detente" | PASA (contrato) |
| RF-14 | `/sdd-tasks` tareas <30min + "Hecho cuando:" | `commands/sdd-tasks.md` | PASA (contrato) |
| RF-15 | `/sdd-implement <n>` solo Tn, tests primero, para | `commands/sdd-implement.md` pasos 4-7 | PASA (contrato) |
| RF-16 | `/sdd-validate` recorre RF y da veredicto | `commands/sdd-validate.md` | PASA (contrato) |
| RF-17 | `/sdd-change` spec + diff antes que código | `commands/sdd-change.md` pasos 1,4,5 | PASA (contrato) |
| RF-18 | `plugins/sdd/` única copia editable | `install.sh` copia DESDE `plugins/sdd/`; README y constitución lo fijan | PASA |
| RF-19 | `validate.sh` falla con JSON/frontmatter inválido | `tests/validate.sh`: `json_check` + `frontmatter_value`, exit 1 con lista | PASA |
| RF-20 | Artefactos SDD propios en el repo | `docs/constitution.md`, `specs/001-sdd-toolkit/{spec,plan,tasks,validation}.md` | PASA |

## Criterios de finalización

- [x] Todos los RF con evidencia (tabla arriba).
- [x] `bash tests/validate.sh` en verde.
- [x] `claude plugin validate ./plugins/sdd --strict` sin errores.
- [x] Demo manual: `/plugin install sdd@sdd-toolkit` OK en proyecto scratch.

## Veredicto

**Spec cumplida.** RF-9..RF-17 se validan a nivel de contrato del slash command
(el comportamiento del agente al ejecutarlos); la prueba en vivo de esas fases se
hace usando el toolkit en un proyecto real.

## Notas / deuda menor

- `install.sh` usa `find -type f` sin orden estable entre sistemas de archivos;
  no afecta al resultado (copia por archivo) pero el listado puede variar.
- La prueba de RF-6 con `--force` real (que sí sobrescriba) no está automatizada;
  cubierta por inspección de código.
