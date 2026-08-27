---
name: sdd-flow
description: Usa esta skill cuando el usuario quiera arrancar o llevar un proyecto con Spec-Driven Development (SDD) — "empezar proyecto con SDD", "flujo spec-driven", "hazlo por fases con spec". Explica las 8 fases, qué artefacto deja cada una y qué slash command la ejecuta, e instala las plantillas base en el proyecto.
---

# Spec-Driven Development (SDD)

Desarrollar software con agentes partiendo de una especificación acordada, no
improvisando prompts. **La spec es el contrato: si algo no está en ella, no se
implementa.** Cada fase deja un artefacto versionado en el repo.

## Las 8 fases

Commands mostrados como `/sdd:<fase>` (plugin); con el script de instalación son
`/sdd-<fase>`.

| # | Fase | Artefacto | Command |
| - | ---- | --------- | ------- |
| 1 | Constitución | `docs/constitution.md` | `/sdd:constitution` |
| — | Contexto del agente | `AGENTS.md` (+ `CLAUDE.md` → `@AGENTS.md`) | (plantilla) |
| 2 | Especificación | `specs/NNN-<slug>/spec.md` | `/sdd:spec` |
| 3 | Clarificación | (revisión QA de la spec) | `/sdd:clarify` |
| 4 | Planificación | `specs/NNN-<slug>/plan.md` | `/sdd:plan` |
| 5 | Tareas | `specs/NNN-<slug>/tasks.md` | `/sdd:tasks` |
| 6 | Implementación | código + tests, una tarea a la vez | `/sdd:implement <n>` |
| 7 | Validación | recorrido RF por RF | `/sdd:validate` |
| 8 | Cambio | spec actualizada (diff) antes que código | `/sdd:change <req>` |

## Arrancar un proyecto de cero

1. Copia las plantillas de `templates/` de esta skill a la raíz del proyecto:
   - `constitution.md` → `docs/constitution.md`
   - `AGENTS.md` → `AGENTS.md`; crea `CLAUDE.md` con una sola línea: `@AGENTS.md`
   - `plan.md` y `tasks.md` quedan como referencia; se rellenan en las fases 4 y 5.
2. Ejecuta `/sdd:constitution` y acuerda los principios.
3. Ejecuta `/sdd:spec` para la primera funcionalidad.
4. Sigue el orden de la tabla. No te saltes fases.

## Reglas de oro

- **QUÉ y POR QUÉ en la spec; CÓMO en el plan.** Nada de stack, archivos ni
  algoritmos en la spec.
- **Una tarea a la vez, tests primero.** Prohibido avanzar con tests en rojo.
- **Cambio = spec antes que código.** Nuevo requisito → primero el diff de la
  spec, luego implementar.
- **Si falta una decisión, para y pregunta.** Un hueco visible es información;
  una suposición silenciosa es deuda.
- **Idioma**: el de la constitución del proyecto; si no la hay, el del usuario.

## Notación EARS (para specs)

| Patrón | Forma |
| ------ | ----- |
| Ubicuo | EL SISTEMA \<hará\> |
| Dirigido por evento | CUANDO \<disparador\>, EL SISTEMA \<hará\> |
| Estado | MIENTRAS \<estado\>, EL SISTEMA \<hará\> |
| Opcional | DONDE \<característica\>, EL SISTEMA \<hará\> |
| No deseado | SI \<condición\>, ENTONCES EL SISTEMA \<hará\> |

La entrevista de requisitos y la redacción de la spec las hace la skill
`spec-generator` (la dispara `/sdd:spec`).
