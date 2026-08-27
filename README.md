# sdd-toolkit

El flujo completo de **Spec-Driven Development (SDD)** empaquetado como skills y
slash commands para **Claude Code** y **opencode**. Basado en el
[curso de SDD de MoureDev](https://youtube.com/live/5HaOxAAA5qI).

> La spec es el contrato: si algo no está en ella, no se implementa. Cada fase
> deja un artefacto versionado en el repo.

## El flujo

| #   | Fase           | Artefacto                               | Command         |
| --- | -------------- | --------------------------------------- | --------------- |
| 1   | Constitución   | `docs/constitution.md`                  | `constitution`  |
| 2   | Especificación | `specs/NNN-<slug>/spec.md` (RF en EARS) | `spec`          |
| 3   | Clarificación  | revisión QA de la spec                  | `clarify`       |
| 4   | Planificación  | `specs/NNN-<slug>/plan.md`              | `plan`          |
| 5   | Tareas         | `specs/NNN-<slug>/tasks.md`             | `tasks`         |
| 6   | Implementación | código + tests, una tarea a la vez      | `implement <n>` |
| 7   | Validación     | recorrido RF por RF                     | `validate`      |
| 8   | Cambio         | spec actualizada antes que el código    | `change <req>`  |

Cómo se invoca cada command depende de cómo lo instales:

- **Plugin** (Claude Code): `/sdd:constitution`, `/sdd:spec`, …
- **Script** (`install.sh`, en un directorio plano): `/sdd-constitution`,
  `/sdd-spec`, … (el script antepone `sdd-` para que no colisionen).

Más la skill `sdd-flow` (punto de entrada, explica el flujo y trae las plantillas) y
`spec-generator` (la entrevista de requisitos de la fase 2).

## Instalación

### Claude Code — como plugin (recomendado)

```
/plugin marketplace add jandrescodes/sdd-toolkit
/plugin install sdd@sdd-toolkit
```

Actualizar: `/plugin update sdd`. Los commands quedan como `/sdd:<fase>`.

### opencode, o Claude Code sin plugin — script

```
git clone https://github.com/jandrescodes/sdd-toolkit
cd sdd-toolkit
./install.sh --target both        # claude | opencode | both
```

Copia a `~/.claude/{skills,commands}/` y/o `~/.config/opencode/{skills,commands}/`.
Opciones: `--dry-run` (no escribe), `--force` (sobrescribe destinos que
difieren). Idempotente: reejecutar sin cambios no toca nada.

> **Elige una sola vía.** Si instalas el plugin y además corres
> `install.sh --target claude`, tendrás cada fase duplicada (`/sdd:spec` y
> `/sdd-spec`). En opencode, `install.sh --target opencode` basta; no instales
> además las skills en `~/.claude/`, que opencode también lee.

## Uso rápido

En un proyecto nuevo (commands mostrados en su forma de plugin, `/sdd:<fase>`;
con el script son `/sdd-<fase>`):

1. `/sdd:constitution` — acuerda los principios del proyecto.
2. Copia `AGENTS.md` de la plantilla y crea `CLAUDE.md` con `@AGENTS.md`.
3. `/sdd:spec <funcionalidad>` — entrevista + `spec.md`.
4. `/sdd:clarify` → `/sdd:plan` → `/sdd:tasks`.
5. `/sdd:implement 1`, `/sdd:implement 2`, … una tarea a la vez.
6. `/sdd:validate` cuando estén todas.

## Estructura del repo

```
plugins/sdd/            ← fuente única de verdad (skills + commands)
docs/constitution.md    ← constitución del propio toolkit (ejemplo vivo)
specs/001-sdd-toolkit/  ← spec + plan + tasks del propio toolkit
install.sh              ← distribución para opencode / Claude sin plugin
tests/validate.sh       ← puerta de calidad (JSON + frontmatter + humo install.sh)
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

**MIT** para el trabajo propio de este repo (`install.sh`, `tests/validate.sh`,
los 8 slash commands, la skill `sdd-flow`, los manifiestos del plugin) — ver
[LICENSE](./LICENSE).

**Apache License 2.0** para los archivos derivados del curso de MoureDev
([hello-sdd](https://github.com/mouredev/hello-sdd), que es Apache-2.0) — ver
[LICENSE-APACHE](./LICENSE-APACHE) y [NOTICE](./NOTICE). Son:
`plugins/sdd/skills/spec-generator/SKILL.md`,
`plugins/sdd/skills/spec-generator/spec-template.md`,
`plugins/sdd/skills/sdd-flow/templates/AGENTS.md` y
`plugins/sdd/skills/sdd-flow/templates/constitution.md`.
