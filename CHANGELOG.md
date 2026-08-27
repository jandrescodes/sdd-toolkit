# Changelog

Formato basado en [Keep a Changelog](https://keepachangelog.com/es/1.1.0/).
Versionado: la versión vive en `plugins/sdd/.claude-plugin/plugin.json`.

## [No publicado]

### Corregido

- **Licencia**: el material derivado del curso de MoureDev
  ([hello-sdd](https://github.com/mouredev/hello-sdd), Apache-2.0) se
  redistribuía como MIT. Ahora hay licencia dual: MIT para el trabajo propio y
  Apache-2.0 (`LICENSE-APACHE`, `NOTICE`) para los 4 archivos derivados, cada
  uno marcado.
- **Nombres de command en el plugin**: eran `sdd-constitution.md`, etc., lo que
  el plugin exponía como `/sdd:sdd-constitution`. Renombrados a la fase pelada
  (`constitution.md` → `/sdd:constitution`). `install.sh` antepone `sdd-` solo
  al instalar en un directorio plano.
- **`install.sh --target` sin valor** (`./install.sh --target`) abortaba sin
  mensaje por `set -e`; ahora imprime el uso y sale 1.
- **Ruta de commands de opencode**: `~/.config/opencode/command/` →
  `~/.config/opencode/commands/` (la documentada).
- **Nombre de la skill de flujo**: `sdd` → `sdd-flow`. `sdd` a secas es
  demasiado genérico y colisiona fácil con otras skills globales.
- **README**: afirmaba que el plugin deja los commands como `/sdd-*`; corregido
  a `/sdd:<fase>`. Añadido aviso de no mezclar plugin + script.

### Añadido

- `tests/validate.sh` ahora corre una prueba de humo real de `install.sh`
  (rutas, prefijo, idempotencia, `--dry-run`, `--force`, salidas de error)
  contra un `HOME` temporal. Antes solo estaba descrita en el plan.
- `allowed-tools` en los commands de solo lectura: `clarify` (Read/Grep/Glob) y
  `validate` (+ Bash).
- `CHANGELOG.md`.
