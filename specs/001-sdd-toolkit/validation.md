# Validación — Spec 001

Recorrido RF por RF. Primera pasada 2026-08-27; revisada tras las correcciones
del mismo día (ver "Correcciones posteriores" en `spec.md`).

| RF | Resumen | Evidencia | Veredicto |
| -- | ------- | --------- | --------- |
| RF-1 | Plugin expone 8 commands + 2 skills | Instalado en local desde un marketplace de tipo Directory: `claude plugin details sdd` → commands `constitution, spec, clarify, plan, tasks, implement, validate, change`; skills `sdd-flow`, `spec-generator`. `--strict` en verde. Vía plugin se invocan `/sdd:<fase>`. | PASA |
| RF-2 | `install.sh --target opencode` → rutas opencode, commands prefijados | Prueba de humo en `tests/validate.sh`: `~/.config/opencode/skills/…` y `~/.config/opencode/commands/sdd-*.md` | PASA |
| RF-3 | `install.sh --target claude` → rutas claude, commands prefijados | Prueba de humo: `~/.claude/skills/…` y `~/.claude/commands/sdd-*.md`; ningún `spec.md` suelto | PASA |
| RF-4 | `--target both` aplica ambos | Prueba de humo: 30 archivos en las 4 rutas | PASA |
| RF-5 | Idempotente | Prueba de humo: segunda pasada → "Sin cambios (ya estaba al día)" | PASA |
| RF-6 | Destino que difiere se omite sin `--force`; `--force` sobrescribe | Prueba de humo: se modifica `sdd-spec.md` en destino → sin `--force` no cambia; con `--force` vuelve a ser idéntico al origen | PASA |
| RF-7 | `--dry-run` no escribe | Prueba de humo: tras `--target both --dry-run`, 0 archivos en el `HOME` temporal | PASA |
| RF-8 | target inválido / ausente / sin valor → uso + exit 1 | Prueba de humo: `install.sh` (sin args), `--target zzz`, `--target` (sin valor) → los tres salen 1 | PASA |
| RF-9 | `/sdd:constitution` propone y espera aprobación | `commands/constitution.md` paso 4: "espera mi aprobación explícita" | PASA (contrato del command) |
| RF-10 | `/sdd:spec` entrevista ≤6, sin código, genera spec EARS | `commands/spec.md` + skill `spec-generator` (máx 6, una a una, EARS, "Fuera de alcance") | PASA (contrato) |
| RF-11 | `/sdd:clarify` lista sin resolver | `commands/clarify.md`: 4 bloques, "solo detecta, no resuelvas"; `allowed-tools: Read, Grep, Glob` (no puede escribir) | PASA (contrato) |
| RF-12 | `/sdd:plan` genera plan sin código | `commands/plan.md` paso 3: "NO escribas código" + secciones | PASA (contrato) |
| RF-13 | `/sdd:plan` se detiene sin constitución/spec | `commands/plan.md` paso 1: "avisa y detente" | PASA (contrato) |
| RF-14 | `/sdd:tasks` tareas <30min + "Hecho cuando:" | `commands/tasks.md` | PASA (contrato) |
| RF-15 | `/sdd:implement <n>` solo Tn, tests primero, para | `commands/implement.md` pasos 4-7 | PASA (contrato) |
| RF-16 | `/sdd:validate` recorre RF y da veredicto | `commands/validate.md`; `allowed-tools: Read, Grep, Glob, Bash` | PASA (contrato) |
| RF-17 | `/sdd:change` spec + diff antes que código | `commands/change.md` pasos 1,4,5 | PASA (contrato) |
| RF-18 | `plugins/sdd/` única copia editable | `install.sh` copia DESDE `plugins/sdd/`; README y constitución lo fijan | PASA |
| RF-19 | `validate.sh` falla con JSON/frontmatter inválido | `tests/validate.sh`: `json_check` + `frontmatter_value`, exit 1 con lista | PASA |
| RF-20 | Artefactos SDD propios en el repo | `docs/constitution.md`, `specs/001-sdd-toolkit/{spec,plan,tasks,validation}.md` | PASA |

## Criterios de finalización

- [x] Todos los RF con evidencia (tabla arriba).
- [x] `bash tests/validate.sh` en verde (incluye la prueba de humo de `install.sh`).
- [x] `claude plugin validate ./plugins/sdd --strict` sin errores.
- [x] Instalación del plugin verificada localmente: `claude plugin marketplace
      add <ruta>` + `claude plugin install sdd@sdd-toolkit` OK;
      `claude plugin details sdd` lista los 8 commands (`constitution`, `spec`,
      …) y las 2 skills (`sdd-flow`, `spec-generator`); `--strict` en verde.
- [x] Instalación desde el marketplace **publicado en GitHub**:
      `claude plugin marketplace add jandrescodes/sdd-toolkit` +
      `claude plugin install sdd@sdd-toolkit` OK; `claude plugin details sdd`
      lista los 8 commands y las 2 skills.
- [ ] Recorrido end-to-end de las 8 fases sobre un proyecto real usando el
      plugin instalado (queda como uso normal del toolkit).

## Veredicto

**Spec cumplida a nivel de artefactos y de la puerta de calidad automatizada.**
RF-9..RF-17 se validan a nivel de contrato del slash command (el comportamiento
del agente al ejecutarlos). Queda pendiente la única comprobación que no se
puede automatizar aquí: instalar el plugin desde el marketplace ya publicado y
recorrer un proyecto real con él.

## Notas

- `install.sh` usa `find -type f` sin orden estable entre sistemas de archivos;
  no afecta al resultado (copia por archivo) pero el listado puede variar.
- Licencia dual desde la revisión: MIT para el trabajo propio, Apache-2.0 para
  los 4 archivos derivados de hello-sdd (`LICENSE-APACHE`, `NOTICE`).
