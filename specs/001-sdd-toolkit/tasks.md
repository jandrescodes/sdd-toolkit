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
- [x] T5. Skill `sdd` + 4 plantillas en `templates/`. (RF-9, RF-20)
      Hecho cuando: SKILL.md describe las 8 fases y enlaza cada plantilla.
- [x] T6. Los 8 slash commands. (RF-9, RF-11..RF-17)
      Hecho cuando: cada uno con frontmatter `description`; `validate.sh` verde.
- [x] T7. `install.sh` con `--target`, `--dry-run`, `--force`. (RF-2..RF-8, RF-18)
      Hecho cuando: prueba de humo contra `HOME=$(mktemp -d)` deja los archivos
      en las rutas correctas y es idempotente al repetir.
- [x] T8. `README.md` + validación final RF por RF. (Todos)
      Hecho cuando: cada RF con evidencia y demo del flujo documentada.
