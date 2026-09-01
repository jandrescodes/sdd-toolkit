# Spec 001 — sdd-toolkit

**Estado:** implementada ✅ (0.2.0) — ver "Cambios posteriores" al final.

## Contexto y objetivo

El flujo de Spec-Driven Development (Constitución → Spec → Clarificación → Plan →
Tareas → Implementación → Validación → Cambio) hoy vive disperso: prompts sueltos
y una skill instalada a mano en un proyecto. Este toolkit lo empaqueta como algo
reutilizable e instalable, para que cualquier proyecto nuevo tenga las 8 fases
disponibles como skills y slash commands, en Claude Code y en opencode.

## Usuarios / actores

Desarrolladores que trabajan con agentes de IA (Claude Code u opencode) y quieren
un flujo SDD consistente entre proyectos, sin copiar prompts a mano.

## Historias de usuario

- H1: Como desarrollador quiero instalar el toolkit una vez para tener el flujo
  SDD en todos mis proyectos.
- H2: Como desarrollador quiero un comando por fase para no memorizar prompts.
- H3: Como desarrollador quiero una entrevista guiada de requisitos que genere la
  spec con el formato acordado.
- H4: Como mantenedor quiero editar el contenido en un solo sitio.

## Requisitos funcionales (criterios de aceptación en EARS)

### Distribución e instalación

- RF-1: CUANDO el usuario ejecute `/plugin marketplace add <repo>` y luego
  `/plugin install sdd@sdd-toolkit` en Claude Code, EL SISTEMA expondrá 8 slash
  commands (namespaced por el plugin como `/sdd:<fase>`) y 2 skills
  (`sdd-flow`, `spec-generator`).
- RF-2: CUANDO el usuario ejecute `bash install.sh --target opencode`, EL SISTEMA
  copiará las skills a `~/.config/opencode/skills/` y los commands a
  `~/.config/opencode/commands/`, cada command con el nombre de archivo
  prefijado `sdd-`.
- RF-3: CUANDO el usuario ejecute `bash install.sh --target claude`, EL SISTEMA
  copiará las skills a `~/.claude/skills/` y los commands a `~/.claude/commands/`,
  cada command con el nombre de archivo prefijado `sdd-`.
- RF-4: SI se pasa `--target both`, ENTONCES EL SISTEMA aplicará RF-2 y RF-3 en la
  misma ejecución.
- RF-5: CUANDO `install.sh` se ejecute dos veces seguidas sin cambios en el
  origen, EL SISTEMA dejará el destino idéntico la segunda vez (idempotente).
- RF-6: SI un archivo de destino ya existe y difiere del origen, ENTONCES
  `install.sh` lo omitirá e informará, salvo que se pase `--force`.
- RF-7: CUANDO se pase `--dry-run`, EL SISTEMA listará qué copiaría sin escribir
  nada.
- RF-8: SI se pasa un `--target` no reconocido o ningún target, ENTONCES
  `install.sh` mostrará el uso y terminará con salida 1.

### Fases del flujo

- RF-9: CUANDO se invoque `/sdd:constitution`, EL SISTEMA propondrá una
  constitución de principios cortos y verificables y esperará aprobación antes de
  escribir `docs/constitution.md`.
- RF-10: CUANDO se invoque `/sdd:spec`, EL SISTEMA iniciará una entrevista de
  máximo 6 preguntas de una en una, NO escribirá código, y al terminar generará
  `specs/NNN-<slug>/spec.md` con RF en EARS y sección "Fuera de alcance".
- RF-11: CUANDO se invoque `/sdd:clarify`, EL SISTEMA revisará la spec activa como
  QA y listará ambigüedades, contradicciones, casos límite ausentes y conflictos
  con la constitución, sin proponer soluciones.
- RF-12: CUANDO se invoque `/sdd:plan`, EL SISTEMA generará
  `specs/NNN-<slug>/plan.md` con módulos, modelo de datos, decisiones
  justificadas, riesgos y estrategia de verificación, sin escribir código.
- RF-13: SI al invocar `/sdd:plan` no existe `docs/constitution.md` o no hay
  spec activa en `specs/`, ENTONCES EL SISTEMA avisará y se detendrá.
- RF-14: CUANDO se invoque `/sdd:tasks`, EL SISTEMA generará
  `specs/NNN-<slug>/tasks.md` con tareas ordenadas por dependencia, cada una con
  sus RF, un checkbox y una línea "Hecho cuando:" verificable.
- RF-15: CUANDO se invoque `/sdd:implement <n>`, EL SISTEMA implementará solo la
  tarea T\<n\>, verificación primero (suite automatizada o checklist manual),
  la ejecutará, marcará la tarea y se detendrá.
- RF-16: CUANDO se invoque `/sdd:validate`, EL SISTEMA recorrerá la spec RF por RF
  con su verificación, escribirá `specs/NNN-<slug>/validation.md` y emitirá un
  veredicto de cumplimiento.
- RF-17: CUANDO se invoque `/sdd:change <requisito>`, EL SISTEMA actualizará
  primero la spec y mostrará el diff, sin tocar código.

### Mantenimiento y calidad

- RF-18: EL SISTEMA mantendrá `plugins/sdd/` como única copia editable; los
  destinos de `install.sh` son copias.
- RF-19: SI `tests/validate.sh` detecta un JSON que no parsea, o un `SKILL.md` o
  command sin `name`/`description` en frontmatter, ENTONCES terminará con salida 1
  y listará cada fallo.
- RF-20: EL SISTEMA incluirá los artefactos SDD de su propia construcción
  (`docs/constitution.md`, `specs/001-sdd-toolkit/`) como ejemplo vivo en el repo.

## Requisitos no funcionales

- Sin dependencias de runtime más allá de `bash` y `python3` o `node` para
  validar JSON.
- Contenido en español; identificadores en inglés.
- Compatible con macOS y Linux (bash 3.2+). Windows queda vía WSL.

## Casos límite

- `install.sh` sin `~/.config/opencode/` ni `~/.claude/` → crea las rutas.
- Reinstalar sobre una versión anterior → RF-5, RF-6.
- Archivo de destino modificado por el usuario → RF-6 (se omite sin `--force`).
- `/sdd:plan` en un proyecto sin constitución → RF-13.
- `marketplace.json` o `plugin.json` corrupto → RF-19.

## Fuera de alcance

Soporte para Cursor u otros agentes; versionado semántico automático; traducción
del contenido a otros idiomas; interfaz gráfica; publicar el repo en GitHub (lo
hace el mantenedor a mano).

## Criterios de finalización

- Todos los RF con evidencia en la validación (`specs/001-sdd-toolkit/` +
  recorrido de `/sdd:validate`).
- `bash tests/validate.sh` en verde.
- `claude plugin validate ./plugins/sdd --strict` sin errores.
- Demo manual: instalar en un proyecto scratch y ejecutar `/sdd:constitution` y
  `/sdd:spec` sin errores.

## Dudas abiertas

- Ninguna. (Resueltas en la clarificación — ver más abajo.)

## Clarificaciones

Hallazgos de la pasada QA y su resolución:

1. **Ambigüedad**: "copiar commands a opencode" — ¿a qué ruta? Resuelto: RF-2
   fija `~/.config/opencode/commands/` (la que documenta opencode; probado:
   también acepta `command/` en singular, pero se usa la documentada).
2. **Caso límite ausente**: qué pasa si el destino fue editado por el usuario.
   Resuelto: RF-6 (omitir + informar; `--force` para sobrescribir).
3. **Contradicción potencial**: RF-1 dice "8 commands", la lista tenía nombres
   sueltos. Resuelto: lista canónica fijada — constitution, spec, clarify, plan,
   tasks, implement, validate, change.
4. **Conflicto con constitución nº4**: validar JSON necesita un parser. Resuelto:
   se acepta `python3` **o** `node` (ambos habituales), no se añade dependencia.
5. **Ambigüedad**: "esperará aprobación" en RF-9 — ¿y RF-10/12? Resuelto: spec y
   plan también piden aprobación explícita; recogido en cada command.
6. **Caso límite**: `/sdd:implement` sin número. Resuelto: el command pide el
   número si falta (no asume T1).

## Correcciones posteriores (revisión 2026-08-27)

Segunda pasada de revisión sobre la versión inicial. Cambios de spec:

- **RF-1**: los archivos de command del plugin **no** llevan prefijo `sdd-`;
  Claude Code los namespacea como `/sdd:<fase>`. El prefijo `sdd-` lo añade
  `install.sh` solo al copiarlos a un directorio plano (RF-2, RF-3).
- **RF-2**: ruta de commands de opencode pasa a `~/.config/opencode/commands/`
  (plural, documentada) en vez de `command/`.
- **RF-8**: se cubre también `--target` presente pero sin valor (`./install.sh
--target`) → uso + salida 1.
- **Criterios de finalización / RF-19**: `tests/validate.sh` incorpora una
  prueba de humo real de `install.sh` (instala contra un `HOME` temporal y
  verifica rutas, prefijo, idempotencia, `--dry-run`, `--force` y salidas de
  error). Antes esa prueba solo estaba descrita en el plan.
- **Licencia**: el material derivado de `mouredev/hello-sdd` (Apache-2.0) se
  redistribuye bajo Apache-2.0, no MIT — ver `LICENSE-APACHE` y `NOTICE`.

## Cambios posteriores (mejoras de flujo, 2026-09)

Fricciones detectadas al aplicar el toolkit a un repo real con historia
(`un-repo-con-historia`) y corregidas en la versión 0.2.0. Cambios de spec:

- **RF-15 / RF-16**: "tests" → "verificación" (suite automatizada **o** checklist
  manual documentado), para proyectos sin suite. RF-16 además exige que la fase 7
  deje `validation.md`.
- **Fuera de alcance**: CI/GitHub Actions sale de la lista — se añade
  `.github/workflows/validate.yml`.
- **Nuevos artefactos de nivel proyecto / plantillas** (no cambian RF; son
  material de la skill `sdd-flow`): `docs/roadmap.md`, `templates/roadmap.md`,
  `templates/validation.md`, `templates/CLAUDE.md`,
  `templates/AGENTS-sdd-section.md`, `docs/ADOPTING.md`.
- **Fase 3**: su rastro se fija en `spec.md § Clarificaciones`.
- Versión del plugin: `0.1.0` → `0.2.0`.
