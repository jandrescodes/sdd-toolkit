# Tareas — Spec 001

- [x] T1. Esqueleto: repo, `.gitignore`, `LICENSE` (MIT), estructura de
      carpetas, `tests/validate.sh`. (RF: —)
      Hecho cuando: `bash tests/validate.sh` corre (aunque falle por piezas
      aún ausentes, sin errores de bash).
- [x] T2. Dogfood docs: `docs/constitution.md` + `specs/001-sdd-toolkit/`
      (spec con clarificación aplicada + plan + estas tareas). (RF-20)
      Hecho cuando: spec con RF numerados en EARS y "Fuera de alcance".
- [x] T3. Plugin base: `.claude-plugin/marketplace.json` +
      `plugins/sdd/.claude-plugin/plugin.json`. (RF-1, RF-19)
      Hecho cuando: `claude plugin validate ./plugins/sdd --strict` pasa y
      `validate.sh` valida ambos JSON.
- [x] T4. Skill `spec-generator`: copiada y generalizada. (RF-10)
      Hecho cuando: frontmatter válido, sin referencias a proyectos concretos.
- [x] T5. Skill `sdd-flow` + 4 plantillas en `templates/`. (RF-9, RF-20)
      Hecho cuando: SKILL.md describe las 8 fases y enlaza cada plantilla.
- [x] T6. Los 8 slash commands. (RF-9, RF-11..RF-17)
      Hecho cuando: cada uno con frontmatter `description`; `validate.sh` verde.
- [x] T7. `install.sh` con `--target`, `--dry-run`, `--force`. (RF-2..RF-8, RF-18)
      Hecho cuando: prueba de humo contra `HOME=$(mktemp -d)` deja los archivos
      en las rutas correctas y es idempotente al repetir.
- [x] T8. `README.md` + validación final RF por RF. (Todos)
      Hecho cuando: cada RF con evidencia y demo del flujo documentada.

## Correcciones posteriores (revisión 2026-08-27)

- [x] T9. Licencia dual: `LICENSE-APACHE` + `NOTICE` para el material derivado
      de hello-sdd (Apache-2.0); marcar los archivos derivados; sección de
      licencia del README reescrita. (RF-18, licencia)
      Hecho cuando: existen `LICENSE-APACHE` y `NOTICE`; el README distingue MIT
      vs Apache-2.0 y enumera los 4 archivos Apache.
- [x] T10. Commands del plugin sin prefijo (`/sdd:<fase>`); `install.sh`
      antepone `sdd-` al instalar en directorio plano. Docs (README, skill
      `sdd-flow`) actualizadas. (RF-1, RF-2, RF-3)
      Hecho cuando: `plugins/sdd/commands/*.md` sin prefijo; prueba de humo
      confirma `sdd-spec.md` en los destinos y ningún `spec.md` suelto.
- [x] T11. `install.sh`: `--target` sin valor → uso + salida 1; ruta opencode a
      `commands/` (plural). (RF-2, RF-8)
      Hecho cuando: `./install.sh --target` sale 1 con mensaje; destinos
      opencode en `~/.config/opencode/commands/`.
- [x] T12. `tests/validate.sh`: prueba de humo real de `install.sh`
      (rutas, prefijo, idempotencia, `--dry-run`, `--force`, salidas de error).
      (RF-2..RF-8, RF-19)
      Hecho cuando: `bash tests/validate.sh` ejecuta la instalación en un `HOME`
      temporal y todas las aserciones pasan.
