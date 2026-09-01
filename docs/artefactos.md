# Mapa de artefactos SDD — dónde vive cada archivo

Referencia canónica: qué archivo produce o consume cada fase, dónde va, quién lo
toca y de qué plantilla sale. Rutas relativas a la raíz del **repo del proyecto**
que usa el toolkit.

Todo se versiona en git. **Nada de esto se despliega**: excluye `docs/` y
`specs/` del artefacto de deploy y del docroot.

## Nivel proyecto

| Artefacto                          | Ruta                                                         | Quién lo crea / edita                                                                                                   | Fase · command          | Plantilla origen                                  |
| ---------------------------------- | ------------------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------------------------------------------------- |
| Constitución                       | `docs/constitution.md`                                       | El agente propone, el usuario aprueba; luego solo con aprobación explícita                                              | 1 · `/sdd:constitution` | `sdd-flow/templates/constitution.md` (Apache-2.0) |
| Roadmap                            | `docs/roadmap.md`                                            | A mano al arrancar/adoptar. Lo **lee** `/sdd:spec` (numeración); lo **actualiza** `/sdd:validate` al cerrar una feature | transversal             | `sdd-flow/templates/roadmap.md` (MIT)             |
| Contexto del agente                | `AGENTS.md` (raíz)                                           | A mano. Índice **terso** de reglas                                                                                      | plantilla               | `sdd-flow/templates/AGENTS.md` (Apache-2.0)       |
| ↳ bloque SDD dentro de `AGENTS.md` | sección `## Planificación de features (SDD)`                 | A mano, pegado de la plantilla                                                                                          | —                       | `sdd-flow/templates/AGENTS-sdd-section.md` (MIT)  |
| Entrada de Claude Code             | `CLAUDE.md` (raíz)                                           | A mano. `@AGENTS.md` + solo lo exclusivo de Claude Code                                                                 | plantilla               | `sdd-flow/templates/CLAUDE.md` (MIT)              |
| Detalle de consulta                | `docs/<tema>.md`                                             | A mano. Todo lo que no cabe como regla en `AGENTS.md`                                                                   | —                       | sin plantilla                                     |
| Historial de versiones             | `CHANGELOG.md` (raíz)                                        | A mano / bloque de cierre de feature                                                                                    | —                       | sin plantilla                                     |
| Verificación del proyecto          | p. ej. `.claude/skills/<verificador>/` o un comando de tests | Propio del repo. **Se declara una vez en `AGENTS.md` § Comandos**                                                       | usado por fases 6 y 7   | sin plantilla                                     |

## Nivel feature — todo bajo `specs/NNN-<slug>/`

| Artefacto             | Ruta                                         | Quién lo crea / edita                                                                                         | Fase · command       | Plantilla origen                                                             |
| --------------------- | -------------------------------------------- | ------------------------------------------------------------------------------------------------------------- | -------------------- | ---------------------------------------------------------------------------- |
| Especificación        | `specs/NNN-<slug>/spec.md`                   | Crea `/sdd:spec` (skill `spec-generator`). Actualiza `/sdd:change` con diff aprobado. `/sdd:clarify` solo lee | 2 · `/sdd:spec`      | `spec-generator/spec-template.md` (Apache-2.0 — **no** está en `templates/`) |
| ↳ Clarificaciones     | `specs/NNN-<slug>/spec.md` § Clarificaciones | Se escribe al resolver los hallazgos de la fase 3                                                             | 3 · `/sdd:clarify`   | (misma plantilla)                                                            |
| Plan técnico          | `specs/NNN-<slug>/plan.md`                   | Crea `/sdd:plan` (mismo `NNN`). Actualiza `/sdd:change`                                                       | 4 · `/sdd:plan`      | `sdd-flow/templates/plan.md` (MIT)                                           |
| Tareas                | `specs/NNN-<slug>/tasks.md`                  | Crea `/sdd:tasks`. `/sdd:implement <n>` marca `[x]`. Actualiza `/sdd:change`                                  | 5 · `/sdd:tasks`     | `sdd-flow/templates/tasks.md` (MIT)                                          |
| Código + verificación | ruta del proyecto                            | `/sdd:implement <n>`, una tarea a la vez                                                                      | 6 · `/sdd:implement` | —                                                                            |
| Validación            | `specs/NNN-<slug>/validation.md`             | Lo escribe `/sdd:validate`                                                                                    | 7 · `/sdd:validate`  | `sdd-flow/templates/validation.md` (MIT)                                     |

## Reglas que resuelven las ambigüedades

- **`NNN`**: tres dígitos, contador propio de `specs/`, monótono, sin reutilizar
  números borrados. Empieza en `001` en repo nuevo; al adoptar SDD sobre una
  serie ya numerada, se continúa y se anota en `AGENTS.md`. **No** es el ordinal
  del roadmap ni un RF histórico.
- **`<slug>`**: kebab-case, corto, en el idioma de la constitución.
- **Una carpeta por feature**, y al cerrar existen los cuatro archivos
  (`spec`, `plan`, `tasks`, `validation`). Si falta `validation.md`, la feature
  no está cerrada.
- **El roadmap enlaza rutas de carpeta**, nunca números sueltos.
- **Precedencia**: `docs/constitution.md` manda sobre specs y planes. Ante
  conflicto entre `docs/`/`specs/` y `AGENTS.md`, `AGENTS.md` es la fuente
  operativa del **código** y `docs/`/`specs/` la capa de **planificación**.
- **`specs/` no se modifica** fuera de su fase salvo petición explícita.
- Las clarificaciones van en `spec.md § Clarificaciones`, no en `plan.md`.

## Del lado del toolkit (fuente única de verdad)

| Qué                | Ruta en `sdd-toolkit`                                                                                                       |
| ------------------ | --------------------------------------------------------------------------------------------------------------------------- |
| Los 8 commands     | `plugins/sdd/commands/{constitution,spec,clarify,plan,tasks,implement,validate,change}.md`                                  |
| Skill de flujo     | `plugins/sdd/skills/sdd-flow/SKILL.md`                                                                                      |
| Plantillas de fase | `plugins/sdd/skills/sdd-flow/templates/`                                                                                    |
| Plantilla de spec  | `plugins/sdd/skills/spec-generator/spec-template.md` (aparte, Apache-2.0)                                                   |
| Instalado como     | plugin: `/sdd:<fase>` · script: `~/.claude/{skills,commands}/` y `~/.config/opencode/{skills,commands}/` con prefijo `sdd-` |

Las plantillas nuevas (`roadmap.md`, `validation.md`, `CLAUDE.md`,
`AGENTS-sdd-section.md`) son trabajo propio → MIT, fuera de `NOTICE`. Tocar
`spec-template.md` o `templates/{AGENTS,constitution}.md` (Apache-2.0) obliga a
actualizar `NOTICE`.
