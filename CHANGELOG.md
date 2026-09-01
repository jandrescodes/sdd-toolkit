# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.1.0/).
Versionado semántico. La versión canónica vive en
`plugins/sdd/.claude-plugin/plugin.json`; cada release lleva un tag de git
**sin prefijo `v`** (`0.1.0`, `0.2.0`, …).

## [No publicado]

—

## [0.2.0] - 2026-09-01

Mejoras de flujo tras aplicar el toolkit a un repo real con historia. El tag
`0.2.0` va sobre el commit de merge a `main`.

### Añadido

- Workflow de CI (`.github/workflows/validate.yml`): corre `tests/validate.sh`
  en cada push a `main` y en cada PR.
- Fase 7 (`/sdd:validate`) deja artefacto: escribe
  `specs/NNN-<slug>/validation.md` con la tabla RF por RF y el veredicto.
  `allowed-tools` gana `Write` y `Skill`.
- Plantillas nuevas en `sdd-flow/templates/` (MIT): `roadmap.md`,
  `validation.md`, `CLAUDE.md` y `AGENTS-sdd-section.md` (bloque para pegar en
  el `AGENTS.md` del proyecto: árbol de artefactos, tabla de fases, reglas de
  numeración / verificación / precedencia / no-deploy).
- `templates/plan.md`: sección `## Riesgos`.
- `templates/tasks.md`: bloque `## Cierre de la feature` (checkboxes fuera de la
  numeración `Tn`: validación, roadmap, CHANGELOG, deploy, convenciones).
- `spec-generator`: regla de numeración de `specs/NNN` (contador propio,
  monótono, sin reutilizar, no ligado al roadmap ni a RF históricos) y campo
  `**Estado:**` bajo el título de la spec (ver `NOTICE`).
- `docs/roadmap.md` como artefacto de nivel proyecto: `/sdd:spec` lo lee al
  elegir número, `/sdd:validate` mueve la feature a `Hecho ✅` al cerrarla.
- `docs/ADOPTING.md`: checklist de 8 pasos para adoptar SDD en un repo con
  historia, con un caso real. Enlazado desde `README` y `sdd-flow/SKILL.md`.
- `docs/artefactos.md`: mapa canónico de dónde vive cada artefacto SDD (ruta,
  quién lo toca, fase, plantilla origen) + reglas de numeración y precedencia.

### Cambiado

- **Verificación como puerta** (antes "tests como puerta"): admite checklist
  manual documentado con evidencia cuando el proyecto no tiene suite
  automatizada. Afecta a `commands/constitution.md`, `templates/constitution.md`
  (ver `NOTICE`), `/sdd:implement`, `/sdd:validate` y `sdd-flow/SKILL.md`.
- Fase 3 (`/sdd:clarify`): las clarificaciones resueltas se anotan en
  `spec.md § Clarificaciones`, no en `plan.md`. Reflejado en la tabla de fases.
- `/sdd:tasks`: añade siempre el bloque "Cierre de la feature" al generar
  `tasks.md`. `/sdd:implement` aclara que no lo implementa.
- `/sdd:plan`: genera además `## Riesgos`; "Estrategia de tests" pasa a
  "Estrategia de verificación" (suite o checklist manual).
- `/sdd:change`: actualiza también `validation.md` si ya existía.
- `/sdd:constitution`: pide un principio de "alcance del producto"; menciona que
  constitución y roadmap son los dos artefactos de nivel proyecto.
- `sdd-flow/SKILL.md`: secciones nuevas "Adoptar en un repo con historia" y
  "Sobre `AGENTS.md`" (regla de contenido, no de longitud); "Reglas de oro"
  gana precedencia y no-deploy de `docs/`/`specs/`.
- `description` de la skill `sdd-flow`: ya no afirma que "instala" las
  plantillas; el cuerpo indica dónde está `templates/` según la vía de
  instalación y que la plantilla de `spec.md` la trae `spec-generator`.
- `docs/constitution.md` (del propio toolkit): principio 3 enumera los cuatro
  artefactos de feature y el roadmap; principio 6 pasa a "verificación como
  puerta" e incluye `claude plugin validate --strict`.
- Dogfood: `specs/001-sdd-toolkit/` actualizado (campo `**Estado:**`,
  `## Riesgos`, `## Cierre de la feature`, sección "Cambios posteriores").
- `README`: reescrito — cabecera y pie centrados, badges (CI, versión,
  licencia), secciones al día y nota de licencia dual reordenada.

## [0.1.0] - 2026-09-01

Primera versión del toolkit. Tag sobre `64ebc84`.

### Añadido

- Toolkit SDD como plugin de Claude Code (`marketplace.json` + `plugin.json`),
  skills `sdd-flow` y `spec-generator`, 8 slash commands, plantillas base.
- `install.sh` para opencode / Claude Code sin plugin (`--target`, `--dry-run`,
  `--force`, idempotente).
- `tests/validate.sh` con prueba de humo real de `install.sh` (rutas, prefijo,
  idempotencia, `--dry-run`, `--force`, salidas de error) contra un `HOME`
  temporal.
- `allowed-tools` en los commands de solo lectura: `clarify` (Read/Grep/Glob) y
  `validate` (+ Bash).
- `CHANGELOG.md`.

### Corregido

- **Licencia**: el material derivado del curso de MoureDev
  ([hello-sdd](https://github.com/mouredev/hello-sdd), Apache-2.0) se
  redistribuía como MIT. Ahora hay licencia dual: MIT para el trabajo propio y
  Apache-2.0 (`LICENSE-APACHE`, `NOTICE`) para los 4 archivos derivados.
- **Nombres de command en el plugin**: `sdd-constitution.md`, etc. →
  `/sdd:sdd-constitution`. Renombrados a la fase pelada
  (`constitution.md` → `/sdd:constitution`). `install.sh` antepone `sdd-` solo
  al instalar en un directorio plano.
- **`install.sh --target` sin valor** (`./install.sh --target`) abortaba sin
  mensaje por `set -e`; ahora imprime el uso y sale 1.
- **Ruta de commands de opencode**: `~/.config/opencode/command/` →
  `~/.config/opencode/commands/` (la documentada).
- **Nombre de la skill de flujo**: `sdd` → `sdd-flow` (`sdd` a secas colisiona
  fácil con otras skills globales).
- **README**: afirmaba que el plugin deja los commands como `/sdd-*`; corregido
  a `/sdd:<fase>`. Añadido aviso de no mezclar plugin + script.

[No publicado]: https://github.com/jandrescodes/sdd-toolkit/compare/0.2.0...HEAD
[0.2.0]: https://github.com/jandrescodes/sdd-toolkit/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/jandrescodes/sdd-toolkit/releases/tag/0.1.0
