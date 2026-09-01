---
name: sdd-flow
description: Usa esta skill cuando el usuario quiera arrancar o llevar un proyecto con Spec-Driven Development (SDD) — "empezar proyecto con SDD", "flujo spec-driven", "hazlo por fases con spec". Explica las 8 fases, qué artefacto deja cada una y qué slash command la ejecuta, y trae las plantillas base para copiar al proyecto.
---

# Spec-Driven Development (SDD)

Desarrollar software con agentes partiendo de una especificación acordada, no
improvisando prompts. **La spec es el contrato: si algo no está en ella, no se
implementa.** Cada fase deja un artefacto versionado en el repo.

## Las 8 fases

Commands mostrados como `/sdd:<fase>` (plugin); con el script de instalación son
`/sdd-<fase>`.

| #   | Fase                | Artefacto                                    | Command              |
| --- | ------------------- | -------------------------------------------- | -------------------- |
| 1   | Constitución        | `docs/constitution.md`                       | `/sdd:constitution`  |
| —   | Contexto del agente | `AGENTS.md` (+ `CLAUDE.md` → `@AGENTS.md`)   | (plantilla)          |
| —   | Roadmap             | `docs/roadmap.md` (nivel proyecto, a mano)   | (plantilla)          |
| 2   | Especificación      | `specs/NNN-<slug>/spec.md`                   | `/sdd:spec`          |
| 3   | Clarificación       | `specs/NNN-<slug>/spec.md` § Clarificaciones | `/sdd:clarify`       |
| 4   | Planificación       | `specs/NNN-<slug>/plan.md`                   | `/sdd:plan`          |
| 5   | Tareas              | `specs/NNN-<slug>/tasks.md`                  | `/sdd:tasks`         |
| 6   | Implementación      | código + tests, una tarea a la vez           | `/sdd:implement <n>` |
| 7   | Validación          | `specs/NNN-<slug>/validation.md`             | `/sdd:validate`      |
| 8   | Cambio              | spec actualizada (diff) antes que código     | `/sdd:change <req>`  |

`/sdd:spec` **lee** `docs/roadmap.md` al elegir número; `/sdd:validate` **mueve**
la feature a `Hecho ✅` al cerrarla. Mapa completo de rutas, plantillas y quién
toca qué: `docs/artefactos.md` del toolkit.

## Arrancar un proyecto de cero

1. Copia las plantillas de la carpeta `templates/` de esta skill al proyecto.
   Según cómo esté instalado el toolkit, `templates/` está en:
   - Plugin: dentro del plugin `sdd` (Claude Code lo resuelve solo).
   - Script (`install.sh`): `~/.claude/skills/sdd-flow/templates/` y/o
     `~/.config/opencode/skills/sdd-flow/templates/`.

   Copias:
   - `constitution.md` → `docs/constitution.md`
   - `roadmap.md` → `docs/roadmap.md`
   - `AGENTS.md` → `AGENTS.md`; pega en él el bloque `AGENTS-sdd-section.md`
   - `CLAUDE.md` → `CLAUDE.md` (ya trae la línea `@AGENTS.md`)
   - `plan.md`, `tasks.md` y `validation.md` quedan como referencia; se rellenan
     en las fases 4, 5 y 7.
   - La plantilla de `spec.md` **no** está en `templates/`: la trae la skill
     `spec-generator` (`spec-template.md`), y la aplica `/sdd:spec`.

2. Ejecuta `/sdd:constitution` y acuerda los principios.
3. Ejecuta `/sdd:spec` para la primera funcionalidad.
4. Sigue el orden de la tabla. No te saltes fases.

## Adoptar en un repo con historia

Si el repo ya tiene MVP, convenciones dispersas y features hechas, **no** empieces
de cero. Checklist (versión larga con un caso real en `docs/ADOPTING.md` del
toolkit):

1. Inventaria dónde viven hoy las convenciones (`CLAUDE.md`, `AGENT(S).md`,
   `CONTRIBUTING`, `docs/`, wiki) y consolídalas en `AGENTS.md` **terso** +
   `docs/<tema>.md`. Pega el bloque `AGENTS-sdd-section.md`.
2. Deriva `docs/constitution.md` de lo que el repo **ya hace** (stack real,
   reglas implícitas en el código), no de cero.
3. Siembra `docs/roadmap.md`: `Hecho ✅` con las features existentes, una línea
   cada una, sin retroactivar `spec/plan/tasks` (apunta al `CHANGELOG`).
4. Decide dónde va el alcance de producto: si hay README público, ahí; si no, en
   la constitución.
5. Numeración de `specs/`: si el repo ya tenía specs numeradas, continúa la
   serie y anótalo en `AGENTS.md`; si no, empieza en `001`.
6. Excluye `docs/` y `specs/` del artefacto de despliegue.
7. Barre las referencias (README, prompts, docs internos, skills propias).
8. Nada de código. Todo a un commit `docs:` aparte, aprobado antes de escribir.

Después, las fases 1-8 siguen igual.

## Reglas de oro

- **QUÉ y POR QUÉ en la spec; CÓMO en el plan.** Nada de stack, archivos ni
  algoritmos en la spec.
- **Una tarea a la vez, verificación primero.** Prohibido avanzar sin la suite
  automatizada en verde o —si no hay— el checklist manual con su evidencia.
- **Cambio = spec antes que código.** Nuevo requisito → primero el diff de la
  spec, luego implementar.
- **Si falta una decisión, para y pregunta.** Un hueco visible es información;
  una suposición silenciosa es deuda.
- **Precedencia**: `docs/constitution.md` manda sobre specs y planes. Ante
  conflicto entre `docs/`/`specs/` y `AGENTS.md`, `AGENTS.md` es la fuente
  operativa del código y `docs/`/`specs/` la capa de planificación.
- **`docs/` y `specs/` se versionan pero no se despliegan.**
- **Idioma**: el de la constitución del proyecto; si no la hay, el del usuario.

## Sobre `AGENTS.md`

`AGENTS.md` contiene **reglas que el agente debe obedecer**, no material de
consulta. Todo lo que sea referencia — volcados de API, catálogos de endpoints,
checklists largos, flujos paso a paso, tablas de esquema — va a `docs/<tema>.md`,
y `AGENTS.md` lo enlaza con **una línea de regla + "ver `docs/X`"**. Prueba
rápida: si un párrafo no se puede reescribir como "haz X" / "nunca hagas Y", no
pertenece a `AGENTS.md`.

## Notación EARS (para specs)

| Patrón              | Forma                                          |
| ------------------- | ---------------------------------------------- |
| Ubicuo              | EL SISTEMA \<hará\>                            |
| Dirigido por evento | CUANDO \<disparador\>, EL SISTEMA \<hará\>     |
| Estado              | MIENTRAS \<estado\>, EL SISTEMA \<hará\>       |
| Opcional            | DONDE \<característica\>, EL SISTEMA \<hará\>  |
| No deseado          | SI \<condición\>, ENTONCES EL SISTEMA \<hará\> |

La entrevista de requisitos y la redacción de la spec las hace la skill
`spec-generator` (la dispara `/sdd:spec`).
