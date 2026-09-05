# Changelog

Format based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).
Semantic versioning. The canonical version lives in
`plugins/sdd/.claude-plugin/plugin.json`; every release carries a git tag
**without the `v` prefix** (`0.1.0`, `0.2.0`, …).

## [Unreleased]

—

## [0.3.0] - 2026-09-04

The toolkit's own prompts, commands, skills, and docs translated from
Spanish to English — the ecosystem convention for Claude Code plugins, and
more reliable for the model to follow. Generated spec/plan/tasks/validation
**content** is no longer hardcoded to Spanish: it now follows the target
project's constitution (or the user's language if none is declared).

### Changed

- **Breaking**: `RF-` requirement numbering renamed to `FR-` throughout
  commands, skills, and templates. Existing specs written under `RF-` are
  unaffected (historical artifacts, not rewritten) but new specs use `FR-`.
- EARS keywords now canonical in English (`WHEN`, `THE SYSTEM SHALL`,
  `IF...THEN`, `WHILE`, `WHERE`) instead of Spanish (`CUANDO`, `EL SISTEMA`,
  `SI...ENTONCES`, `MIENTRAS`, `DONDE`).
- Coupled section headers translated together to keep commands and
  templates in sync: `Hecho cuando:` → `Done when:`, `## Cierre de la
feature` → `## Feature closeout`, `PASA/FALLA/SIN COBERTURA` →
  `PASS/FAIL/NOT COVERED`, `Hecho ✅`/`Siguiente 🔜` → `Done ✅`/`Next 🔜`,
  `[NECESITA ACLARACIÓN]` → `[NEEDS CLARIFICATION]`, `**Estado:**` →
  `**Status:**`.
- `docs/constitution.md` principle 2 rewritten: the toolkit itself (prompts,
  commands, docs) is English; generated artifact **content** language is
  chosen by the target project's constitution, defaulting to the user's
  language. Every prompt must stay tolerant of whatever language it's
  addressed in.
- `sdd-flow` skill's `description` kept bilingual (English + Spanish trigger
  phrases) so it still activates regardless of the language the user writes
  in.
- `implement.md` made tolerant of the feature-closeout block's language for
  repos that adopted the toolkit before this change (e.g. a Spanish `##
Cierre de la feature` header).
- `docs/artefactos.md` renamed to `docs/artifacts.md`.
- `README.md`, `docs/ADOPTING.md`, `docs/roadmap.md`, `NOTICE`,
  `plugin.json`, and `marketplace.json` descriptions translated to English.
- Dogfood: `docs/constitution.md`, `docs/roadmap.md`, and
  `specs/001-sdd-toolkit/{spec,plan,tasks,validation}.md` (this repo's own
  artifacts, not a third-party adopter's) translated to English, including
  `RF-` → `FR-` and EARS keywords. This CHANGELOG's own past entries
  (0.1.0, 0.2.0) translated too, for the same reason.

## [0.2.0] - 2026-09-01

Flow improvements after applying the toolkit to a real repo with history.
The `0.2.0` tag sits on the merge commit into `main`.

### Added

- CI workflow (`.github/workflows/validate.yml`): runs `tests/validate.sh`
  on every push to `main` and every PR.
- Phase 7 (`/sdd:validate`) leaves an artifact: writes
  `specs/NNN-<slug>/validation.md` with the FR-by-FR table and the verdict.
  `allowed-tools` gains `Write` and `Skill`.
- New templates in `sdd-flow/templates/` (MIT): `roadmap.md`,
  `validation.md`, `CLAUDE.md`, and `AGENTS-sdd-section.md` (block to paste
  into the project's `AGENTS.md`: artifact tree, phase table, numbering /
  verification / precedence / no-deploy rules).
- `templates/plan.md`: `## Risks` section.
- `templates/tasks.md`: `## Feature closeout` block (checkboxes outside the
  `Tn` numbering: validation, roadmap, CHANGELOG, deploy, conventions).
- `spec-generator`: `specs/NNN` numbering rule (own counter, monotonic,
  never reused, not tied to the roadmap or historical FRs) and a
  `**Status:**` field under the spec's title (see `NOTICE`).
- `docs/roadmap.md` as a project-level artifact: `/sdd:spec` reads it when
  picking a number, `/sdd:validate` moves the feature to `Done ✅` when it
  closes.
- `docs/ADOPTING.md`: 8-step checklist for adopting SDD into a repo with
  history, with a worked example. Linked from `README` and
  `sdd-flow/SKILL.md`.
- `docs/artefactos.md`: canonical map of where each SDD artifact lives
  (path, who touches it, phase, source template) + numbering and
  precedence rules.

### Changed

- **Verification as a gate** (previously "tests as a gate"): admits a
  documented manual checklist with evidence when the project has no
  automated suite. Affects `commands/constitution.md`,
  `templates/constitution.md` (see `NOTICE`), `/sdd:implement`,
  `/sdd:validate`, and `sdd-flow/SKILL.md`.
- Phase 3 (`/sdd:clarify`): resolved clarifications are recorded in
  `spec.md § Clarifications`, not in `plan.md`. Reflected in the phase
  table.
- `/sdd:tasks`: always appends the "Feature closeout" block when
  generating `tasks.md`. `/sdd:implement` clarifies it doesn't implement
  it.
- `/sdd:plan`: also generates `## Risks`; "Test strategy" becomes
  "Verification strategy" (automated suite or manual checklist).
- `/sdd:change`: also updates `validation.md` if it already existed.
- `/sdd:constitution`: asks for a "product scope" principle; notes that
  the constitution and roadmap are the two project-level artifacts.
- `sdd-flow/SKILL.md`: new sections "Adopting into a repo with history" and
  "About `AGENTS.md`" (a content rule, not a length one); "Golden rules"
  gains precedence and the no-deploy rule for `docs/`/`specs/`.
- `sdd-flow`'s `description`: no longer claims it "installs" the
  templates; the body states where `templates/` lives depending on the
  install method, and that `spec-generator` brings the `spec.md` template.
- `docs/constitution.md` (the toolkit's own): principle 3 lists all four
  feature artifacts plus the roadmap; principle 6 becomes "verification as
  a gate" and includes `claude plugin validate --strict`.
- Dogfood: `specs/001-sdd-toolkit/` updated (`**Status:**` field,
  `## Risks`, `## Feature closeout`, "Later changes" section).
- `README`: rewritten — centered header and footer, badges (CI, version,
  license), up-to-date sections, dual-license note reordered.

## [0.1.0] - 2026-09-01

First version of the toolkit. Tag on `64ebc84`.

### Added

- SDD toolkit as a Claude Code plugin (`marketplace.json` + `plugin.json`),
  `sdd-flow` and `spec-generator` skills, 8 slash commands, base templates.
- `install.sh` for opencode / Claude Code without the plugin (`--target`,
  `--dry-run`, `--force`, idempotent).
- `tests/validate.sh` with a real `install.sh` smoke test (paths, prefix,
  idempotence, `--dry-run`, `--force`, error exits) against a temporary
  `HOME`.
- `allowed-tools` on the read-only commands: `clarify` (Read/Grep/Glob) and
  `validate` (+ Bash).
- `CHANGELOG.md`.

### Fixed

- **License**: material derived from MoureDev's course
  ([hello-sdd](https://github.com/mouredev/hello-sdd), Apache-2.0) was
  being redistributed as MIT. Now there's a dual license: MIT for the
  toolkit's own work and Apache-2.0 (`LICENSE-APACHE`, `NOTICE`) for the 4
  derived files.
- **Command names in the plugin**: `sdd-constitution.md`, etc. →
  `/sdd:sdd-constitution`. Renamed to the bare phase name
  (`constitution.md` → `/sdd:constitution`). `install.sh` now prefixes
  `sdd-` only when installing into a flat directory.
- **`install.sh --target` with no value** (`./install.sh --target`) used
  to abort with no message due to `set -e`; now it prints usage and exits
  1.
- **opencode's commands path**: `~/.config/opencode/command/` →
  `~/.config/opencode/commands/` (the documented one).
- **Flow skill's name**: `sdd` → `sdd-flow` (`sdd` alone collides easily
  with other global skills).
- **README**: claimed the plugin leaves commands as `/sdd-*`; fixed to
  `/sdd:<phase>`. Added a warning against mixing plugin + script.

[Unreleased]: https://github.com/jandrescodes/sdd-toolkit/compare/0.3.0...HEAD
[0.3.0]: https://github.com/jandrescodes/sdd-toolkit/compare/0.2.0...0.3.0
[0.2.0]: https://github.com/jandrescodes/sdd-toolkit/compare/0.1.0...0.2.0
[0.1.0]: https://github.com/jandrescodes/sdd-toolkit/releases/tag/0.1.0
