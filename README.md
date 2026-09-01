<div align="center">

# sdd-toolkit

**El flujo completo de Spec-Driven Development (SDD) empaquetado como skills y
slash commands para [Claude Code](https://claude.com/claude-code) y
[opencode](https://opencode.ai).**

[![validate](https://github.com/jandrescodes/sdd-toolkit/actions/workflows/validate.yml/badge.svg)](https://github.com/jandrescodes/sdd-toolkit/actions/workflows/validate.yml)
&nbsp;[![plugin](https://img.shields.io/badge/plugin-0.2.0-2f81f7)](./CHANGELOG.md)
&nbsp;![license](https://img.shields.io/badge/license-MIT%20%2B%20Apache--2.0-blue)

<em>La spec es el contrato: si algo no está en ella, no se implementa.<br>
Cada fase deja un artefacto versionado en el repo.</em>

</div>

---

## El flujo

Ocho fases, cada una con su artefacto y su slash command.

| #   | Fase           | Artefacto                                             | Command         |
| --- | -------------- | ----------------------------------------------------- | --------------- |
| 1   | Constitución   | `docs/constitution.md`                                | `constitution`  |
| —   | Roadmap        | `docs/roadmap.md` <sub>(a mano)</sub>                 | _(plantilla)_   |
| 2   | Especificación | `specs/NNN-<slug>/spec.md` <sub>(RF en EARS)</sub>    | `spec`          |
| 3   | Clarificación  | `spec.md` § Clarificaciones                           | `clarify`       |
| 4   | Planificación  | `specs/NNN-<slug>/plan.md`                            | `plan`          |
| 5   | Tareas         | `specs/NNN-<slug>/tasks.md`                           | `tasks`         |
| 6   | Implementación | código + verificación <sub>(una tarea a la vez)</sub> | `implement <n>` |
| 7   | Validación     | `specs/NNN-<slug>/validation.md`                      | `validate`      |
| 8   | Cambio         | spec actualizada <sub>(antes que el código)</sub>     | `change <req>`  |

La forma de invocar cada command depende de la instalación:

- **Plugin** (Claude Code) — `/sdd:constitution`, `/sdd:spec`, …
- **Script** (directorio plano) — `/sdd-constitution`, `/sdd-spec`, … <sub>(el
  script antepone `sdd-` para evitar colisiones)</sub>

El punto de entrada es la skill **`sdd-flow`** (explica el flujo y trae las
plantillas); la fase 2 la conduce **`spec-generator`** (entrevista de requisitos).
Mapa completo de artefactos y rutas: [`docs/artefactos.md`](./docs/artefactos.md).

## Instalación

### Claude Code — plugin _(recomendado)_

```
/plugin marketplace add jandrescodes/sdd-toolkit
/plugin install sdd@sdd-toolkit
```

Actualizar con `/plugin update sdd`. Los commands quedan como `/sdd:<fase>`.

### opencode, o Claude Code sin plugin — script

```
git clone https://github.com/jandrescodes/sdd-toolkit
cd sdd-toolkit
./install.sh --target both        # claude | opencode | both
```

Copia a `~/.claude/{skills,commands}/` y/o
`~/.config/opencode/{skills,commands}/`. Opciones: `--dry-run` (no escribe),
`--force` (sobrescribe destinos que difieren). Idempotente.

> **Elige una sola vía.** Instalar el plugin y además correr `install.sh
> --target claude` duplica cada fase (`/sdd:spec` y `/sdd-spec`). En opencode
> basta `install.sh --target opencode`.

## Uso rápido

Proyecto nuevo _(commands en forma de plugin; con el script son `/sdd-<fase>`)_:

1. Copia las plantillas de `sdd-flow/templates/` — `constitution.md` y
   `roadmap.md` a `docs/`, `CLAUDE.md` y `AGENTS.md` a la raíz — y pega el bloque
   `AGENTS-sdd-section.md` en tu `AGENTS.md`.
2. `/sdd:constitution` — acuerda los principios del proyecto.
3. `/sdd:spec <funcionalidad>` — entrevista guiada → `spec.md`.
4. `/sdd:clarify` → `/sdd:plan` → `/sdd:tasks`.
5. `/sdd:implement 1`, `/sdd:implement 2`, … una tarea a la vez.
6. `/sdd:validate` al terminar → `specs/NNN-<slug>/validation.md`.

**¿Repo con historia** (MVP hecho, convenciones dispersas)**?** No empieces de
cero: [`docs/ADOPTING.md`](./docs/ADOPTING.md).

## Estructura del repo

```
plugins/sdd/                             fuente única de verdad (skills + commands)
  skills/sdd-flow/templates/             plantillas de artefactos (MIT)
  skills/spec-generator/spec-template.md plantilla de spec (Apache-2.0)
docs/constitution.md · docs/roadmap.md   artefactos SDD del propio toolkit (ejemplo vivo)
docs/ADOPTING.md                         adoptar SDD en un repo con historia
docs/artefactos.md                       mapa canónico: dónde vive cada artefacto
specs/001-sdd-toolkit/                   spec + plan + tasks + validation del toolkit
install.sh                               distribución para opencode / Claude sin plugin
tests/validate.sh                        puerta de calidad (JSON + frontmatter + humo install.sh)
CHANGELOG.md                             historial por versión
```

Este repo se construye con su propio flujo: los artefactos de `docs/` y
`specs/001-sdd-toolkit/` son reales.

## Versionado

Versionado semántico. La versión canónica vive en `plugins/sdd/.claude-plugin/plugin.json`
y cada release lleva un tag de git **sin prefijo `v`** (`0.1.0`, `0.2.0`, …)
sobre el commit de `main` correspondiente. El detalle por versión está en
[`CHANGELOG.md`](./CHANGELOG.md).

## Desarrollo

```
bash tests/validate.sh                          # puerta de calidad
claude plugin validate ./plugins/sdd --strict   # manifiesto del plugin
```

Edita solo bajo `plugins/sdd/`. Todo lo demás son copias o ejemplo.

## Licencia

Licencia dual:

- **MIT** — el trabajo propio del repo: `install.sh`, `tests/validate.sh`, los 8
  slash commands, la skill `sdd-flow` y sus plantillas (`roadmap.md`,
  `validation.md`, `CLAUDE.md`, `AGENTS-sdd-section.md`, `plan.md`, `tasks.md`) y
  los manifiestos del plugin. Ver [`LICENSE`](./LICENSE).
- **Apache License 2.0** — los archivos derivados del curso de MoureDev
  ([hello-sdd](https://github.com/mouredev/hello-sdd), Apache-2.0):
  `spec-generator/SKILL.md`, `spec-generator/spec-template.md`,
  `sdd-flow/templates/AGENTS.md` y `sdd-flow/templates/constitution.md`. Ver
  [`LICENSE-APACHE`](./LICENSE-APACHE) y [`NOTICE`](./NOTICE).

---

<div align="center">

**Créditos** — El método SDD, la notación EARS aplicada así, la plantilla de spec
y la idea de la skill `spec-generator` provienen del curso gratuito de
Spec-Driven Development de **[Brais Moure (MoureDev)](https://moure.dev)**
· [vídeo](https://youtube.com/live/5HaOxAAA5qI)
· [hello-sdd](https://github.com/mouredev/hello-sdd)

Este repositorio solo **empaqueta** ese flujo como plugin y script de
instalación. Todo el mérito del método es de MoureDev.

</div>
