# sdd-toolkit

El flujo completo de **Spec-Driven Development (SDD)** empaquetado como skills y
slash commands para **Claude Code** y **opencode**. Basado en el
[curso de SDD de MoureDev](https://youtube.com/live/5HaOxAAA5qI).

> La spec es el contrato: si algo no está en ella, no se implementa. Cada fase
> deja un artefacto versionado en el repo.

## El flujo

| # | Fase | Artefacto | Command |
| - | ---- | --------- | ------- |
| 1 | Constitución | `docs/constitution.md` | `/sdd-constitution` |
| 2 | Especificación | `specs/NNN-<slug>/spec.md` (RF en EARS) | `/sdd-spec` |
| 3 | Clarificación | revisión QA de la spec | `/sdd-clarify` |
| 4 | Planificación | `specs/NNN-<slug>/plan.md` | `/sdd-plan` |
| 5 | Tareas | `specs/NNN-<slug>/tasks.md` | `/sdd-tasks` |
| 6 | Implementación | código + tests, una tarea a la vez | `/sdd-implement <n>` |
| 7 | Validación | recorrido RF por RF | `/sdd-validate` |
| 8 | Cambio | spec actualizada antes que el código | `/sdd-change <req>` |

Más la skill `sdd` (punto de entrada, explica el flujo y trae las plantillas) y
`spec-generator` (la entrevista de requisitos de la fase 2).

## Instalación

### Claude Code — como plugin (recomendado)

```
/plugin marketplace add jandrescodes/sdd-toolkit
/plugin install sdd@sdd-toolkit
```

Actualizar: `/plugin update sdd`. Los commands quedan como `/sdd-*`.

### opencode, o Claude Code sin plugin — script

```
git clone https://github.com/jandrescodes/sdd-toolkit
cd sdd-toolkit
./install.sh --target both        # claude | opencode | both
```

Opciones: `--dry-run` (no escribe), `--force` (sobrescribe destinos que
difieren). Idempotente: reejecutar sin cambios no toca nada.

## Uso rápido

En un proyecto nuevo:

1. `/sdd-constitution` — acuerda los principios del proyecto.
2. Copia `AGENTS.md` de la plantilla y crea `CLAUDE.md` con `@AGENTS.md`.
3. `/sdd-spec <funcionalidad>` — entrevista + `spec.md`.
4. `/sdd-clarify` → `/sdd-plan` → `/sdd-tasks`.
5. `/sdd-implement 1`, `/sdd-implement 2`, … una tarea a la vez.
6. `/sdd-validate` cuando estén todas.

## Estructura del repo

```
plugins/sdd/            ← fuente única de verdad (skills + commands)
docs/constitution.md    ← constitución del propio toolkit (ejemplo vivo)
specs/001-sdd-toolkit/  ← spec + plan + tasks del propio toolkit
install.sh              ← distribución para opencode / Claude sin plugin
tests/validate.sh       ← puerta de calidad (JSON + frontmatter)
```

Este repo está construido con su propio flujo: los artefactos SDD de
`specs/001-sdd-toolkit/` son reales y sirven de ejemplo.

## Desarrollo

```
bash tests/validate.sh                          # puerta de calidad
claude plugin validate ./plugins/sdd --strict   # manifiesto del plugin
```

Edita solo bajo `plugins/sdd/`. Todo lo demás son copias o ejemplo.

## Créditos

El flujo, la notación EARS aplicada así, la plantilla de spec y la idea de la
skill `spec-generator` vienen del **curso gratuito de Spec-Driven Development de
[Brais Moure (MoureDev)](https://moure.dev)**:

- Vídeo: <https://youtube.com/live/5HaOxAAA5qI>
- Repo del curso: <https://github.com/mouredev/hello-sdd>

Este repo solo **empaqueta** ese flujo como plugin y script de instalación para
reusarlo entre proyectos. Todo el mérito del método es de MoureDev.

## Licencia

MIT — ver [LICENSE](./LICENSE).
