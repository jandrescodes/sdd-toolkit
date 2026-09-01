# Adoptar SDD en un repo con historia

El flujo de la skill `sdd-flow` cubre "arrancar de cero". Este documento cubre el
caso opuesto: un repo que **ya** tiene MVP, convenciones dispersas y features
hechas. La versión corta de este checklist vive en `sdd-flow/SKILL.md` §
"Adoptar en un repo con historia"; aquí está el detalle con un caso real.

> Regla general: **nada de código**. La adopción es una tarea de documentación.
> Todo va a un commit `docs:` aparte, aprobado antes de escribir.

## Checklist

### 1. Inventariar dónde viven hoy las convenciones

`CLAUDE.md`, `AGENT.md`/`AGENTS.md`, `CONTRIBUTING.md`, `docs/`, wikis, cabeceras
de skills propias, plantillas de PR. Haz la lista antes de mover nada.

### 2. Consolidar en `AGENTS.md` terso + `docs/`

`AGENTS.md` es el índice de **reglas** ("haz X" / "nunca Y"). Todo lo que sea
material de consulta — volcados de API, catálogos de endpoints, tablas de
esquema, flujos paso a paso — va a `docs/<tema>.md`, enlazado con una línea.
`CLAUDE.md` queda con la línea `@AGENTS.md` + lo exclusivo de Claude Code.
Pega el bloque `templates/AGENTS-sdd-section.md` en `AGENTS.md`.

### 3. Derivar `docs/constitution.md` de lo que el repo ya hace

Stack real, reglas implícitas en el código, límites que ya se respetan. No la
inventes: si el código nunca usa `DELETE` físico, eso es un principio; si toda
autorización pasa por un punto único, eso es un principio.

### 4. Sembrar `docs/roadmap.md`

Sección `Hecho ✅` con las features existentes, **una línea cada una**. No
retroactives `spec/plan/tasks` de lo ya hecho — apunta al `CHANGELOG`.
`Siguiente` / `Backlog` con lo que venga.

### 5. Decidir dónde va el alcance de producto

El "qué es y qué NO es" (`mission` en estructuras antiguas): si el repo tiene
README público, la versión larga va ahí y la constitución la resume en un
principio; si no, va entera en la constitución.

### 6. Numeración de `specs/`

Si el repo ya tenía specs numeradas (p. ej. una carpeta `spec/features/007-…`
previa), **continúa la serie** — la siguiente feature es `008`, no `001` — y
anota esa decisión en `AGENTS.md`. El número no tiene que coincidir con el
ordinal del roadmap ni con RF históricos.

### 7. Excluir `docs/` y `specs/` del despliegue

Son artefactos de desarrollo y suelen contener esquema, queries y umbrales. Si el
deploy hace `rsync`/copia del checkout, añade `--exclude='docs/' --exclude='specs/'`
(y `.github/`). Si el servidor sirve el repo directamente, sácalos del docroot.

### 8. Barrer las referencias

`README.md`, archivos de prompts, docs internos, cabeceras de skills propias,
plantillas de PR: cualquier "lee `CLAUDE.md` primero" o flujo ad-hoc anterior
pasa a apuntar al flujo SDD. Deja intactas las menciones históricas del
`CHANGELOG`.

## Caso real — `un-repo-con-historia`

Commit de adopción: **21 archivos, +1089 / −714**, un solo commit `docs:`.

| Qué se hizo        | Detalle                                                                                                  |
| ------------------ | -------------------------------------------------------------------------------------------------------- |
| Fusionar contexto  | `AGENT.md` (borrado) + grueso de `CLAUDE.md` (−348 líneas) → `AGENTS.md`; `CLAUDE.md` quedó en 16 líneas |
| Constitución       | 9 principios derivados del código (borrado lógico, `Gate` único, validación doble, etc.)                 |
| Roadmap            | `spec/constitution/roadmap.md` → `docs/roadmap.md`, reescribiendo rutas internas                         |
| Misión             | `spec/constitution/mission.md` borrado; el "Qué NO es" → `README.md § Alcance`                           |
| Tech-stack         | `spec/constitution/tech-stack.md` (72 líneas) fundido en `AGENTS.md`                                     |
| Feature de ejemplo | `spec/features/007-…` conservada solo como referencia externa                                            |
| Numeración         | la serie siguió en `008-…` (heredó el `007` previo), anotado en `AGENTS.md`                              |
| Deploy             | `deploy.yml`: `--exclude='docs/' --exclude='specs/'` en el `rsync`                                       |
| Barrido            | README, `PROMPTS.md`, docs internos, cabecera de la skill propia `una-skill-propia`                       |

Después de eso, las fases 1-8 del flujo normal aplican sin cambios.
