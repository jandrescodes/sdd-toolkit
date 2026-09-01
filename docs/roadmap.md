# Roadmap — sdd-toolkit

Vista cross-feature del propio toolkit. Artefacto de nivel proyecto (junto con
`docs/constitution.md`). Se mantiene a mano.

Cada entrada de Hecho / Siguiente enlaza la carpeta de la feature.

## Hecho ✅

1. **Toolkit SDD empaquetado** — las 8 fases como plugin de Claude Code +
   `install.sh` para opencode / Claude sin plugin; skills `sdd-flow` y
   `spec-generator`; `tests/validate.sh` como puerta de calidad.
   → `specs/001-sdd-toolkit/`
2. **Mejoras de flujo 0.2.0** — roadmap como artefacto, regla de `AGENTS.md`,
   plantillas `CLAUDE.md` / `validation.md` / `roadmap.md` / `AGENTS-sdd-section.md`,
   `validation.md` como salida de la fase 7, verificación como puerta para
   proyectos sin suite, `docs/ADOPTING.md`, `docs/artefactos.md`, CI.
   → `specs/001-sdd-toolkit/spec.md § Cambios posteriores` + `CHANGELOG.md`

## Siguiente 🔜

_Sin feature en curso — mantenimiento sobre 0.2.0._

## Backlog · ideas 💡

_Toda idea debe respetar `docs/constitution.md`._

- **Soporte para Cursor u otros agentes** — hoy solo Claude Code y opencode.
- **Versionado semántico automatizado** (release-please o similar).
- **Chequeo opcional en `validate.sh`** de que cada plantilla referenciada en
  `SKILL.md` existe.
