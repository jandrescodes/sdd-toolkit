# SDD artifact map — where each file lives

Canonical reference: which file each phase produces or consumes, where it
goes, who touches it, and which template it comes from. Paths relative to
the root of the **project repo** using the toolkit.

Everything is versioned in git, except `deliverables/` (ignored by default).
**None of this gets deployed**: exclude `docs/`, `specs/`, and `deliverables/`
from the deploy artifact and the docroot.

## Project level

| Artifact                       | Path                                                | Who creates / edits it                                                                                                     | Phase · command         | Source template                                   |
| ------------------------------ | --------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | ----------------------- | ------------------------------------------------- |
| Constitution                   | `docs/constitution.md`                              | The agent proposes, the user approves; after that only with explicit approval                                              | 1 · `/sdd:constitution` | `sdd-flow/templates/constitution.md` (Apache-2.0) |
| Roadmap                        | `docs/roadmap.md`                                   | By hand when starting/adopting. **Read** by `/sdd:spec` (numbering); **updated** by `/sdd:validate` when closing a feature | cross-cutting           | `sdd-flow/templates/roadmap.md` (MIT)             |
| Agent context                  | `AGENTS.md` (root)                                  | By hand. **Terse** index of rules                                                                                          | template                | `sdd-flow/templates/AGENTS.md` (Apache-2.0)       |
| ↳ SDD block inside `AGENTS.md` | `## Feature planning (SDD)` section                 | By hand, pasted from the template                                                                                          | —                       | `sdd-flow/templates/AGENTS-sdd-section.md` (MIT)  |
| Claude Code entry point        | `CLAUDE.md` (root)                                  | By hand. `@AGENTS.md` + only what's exclusive to Claude Code                                                               | template                | `sdd-flow/templates/CLAUDE.md` (MIT)              |
| Reference detail               | `docs/<topic>.md`                                   | By hand. Anything that doesn't fit as a rule in `AGENTS.md`                                                                | —                       | no template                                       |
| Version history                | `CHANGELOG.md` (root)                               | By hand / feature closeout block                                                                                           | —                       | no template                                       |
| Project verification           | e.g. `.claude/skills/<verifier>/` or a test command | The repo's own. **Declared once in `AGENTS.md` § Commands**                                                                | used by phases 6 and 7  | no template                                       |

## Documentation layer — `docs/` and `deliverables/`

Derived views of the artifacts above, never a second source of truth: if one
disagrees with the constitution, specs, or plans, those prevail. They are not
phase artifacts and `/sdd:docs` is not a ninth phase.

| Artifact          | Path                                    | Who creates / edits it                                                                                                                                                                                      | Phase · command                                  | Source template                               |
| ----------------- | --------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------ | --------------------------------------------- |
| Schema            | `docs/schema.md`                        | Derived. Refreshed automatically by `/sdd:validate` on a fulfilled verdict, or on request with `/sdd:docs schema`. Everything under `## Notes (hand-written)` is yours and is kept                          | cross-cutting · `/sdd:docs schema`               | `sdd-documents/templates/schema.md` (MIT)     |
| App flow          | `docs/app-flow.md`                      | Derived from closed features' specs and the constitution. Internal: no `lite` gate (the proposal still needs approval). Gaps are `TODO: provide <what>`. Everything under `## Notes (hand-written)` is kept | cross-cutting · `/sdd:docs flow`                 | `sdd-documents/templates/app-flow.md` (MIT)   |
| UX brief          | `docs/ux-brief.md`                      | Derived from the constitution and closed features. Internal: no `lite` gate (the proposal still needs approval); needs no closed feature. UX content is never invented. Notes section is kept               | cross-cutting · `/sdd:docs ux`                   | `sdd-documents/templates/ux-brief.md` (MIT)   |
| PRD               | `deliverables/prd.md`                   | Derived from closed features' specs, after you approve a proposal                                                                                                                                           | cross-cutting · `/sdd:docs prd`                  | `sdd-documents/templates/prd.md` (MIT)        |
| TRD               | `deliverables/trd.md`                   | Derived from closed features' plans, after you approve a proposal                                                                                                                                           | cross-cutting · `/sdd:docs trd`                  | `sdd-documents/templates/trd.md` (MIT)        |
| Scope change log  | `deliverables/changes.md`               | Derived from the `## Changes` entries of closed features, after you approve a proposal                                                                                                                      | cross-cutting · `/sdd:docs changes`              | `sdd-documents/templates/changes.md` (MIT)    |
| Delivery package  | `deliverables/delivery.md`              | Project-level, derived from all closed features (what was delivered, known limits, scope changes), after you approve a proposal                                                                             | cross-cutting · `/sdd:docs delivery`             | `sdd-documents/templates/delivery.md` (MIT)   |
| Acceptance record | `deliverables/acceptance-NNN-<slug>.md` | Derived from one closed feature, after you approve a proposal                                                                                                                                               | cross-cutting · `/sdd:docs acceptance [feature]` | `sdd-documents/templates/acceptance.md` (MIT) |

- **Docs profile**: one line, `Docs profile: lite` or `Docs profile: formal`,
  in the SDD section of `AGENTS.md`. It decides whether the client-facing
  documents (`deliverables/*`) are enabled: with `lite`, which is also the
  default when the line is absent, each request needs a confirmation. The
  schema document is not affected.
- Only **closed** features appear in the client-facing documents: a fulfilled
  `validation.md` not older than the spec's latest `CHG-n` change.
- `deliverables/` is added to `.gitignore` after you approve it.

## Feature level — all under `specs/NNN-<slug>/`

| Artifact            | Path                                        | Who creates / edits it                                                                                                     | Phase · command      | Source template                                                          |
| ------------------- | ------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------- | -------------------- | ------------------------------------------------------------------------ |
| Specification       | `specs/NNN-<slug>/spec.md`                  | Created by `/sdd:spec` (`spec-generator` skill). Updated by `/sdd:change` with an approved diff. `/sdd:clarify` only reads | 2 · `/sdd:spec`      | `spec-generator/spec-template.md` (Apache-2.0 — **not** in `templates/`) |
| ↳ Clarifications    | `specs/NNN-<slug>/spec.md` § Clarifications | Written when resolving phase 3's findings                                                                                  | 3 · `/sdd:clarify`   | (same template)                                                          |
| Technical plan      | `specs/NNN-<slug>/plan.md`                  | Created by `/sdd:plan` (same `NNN`). Updated by `/sdd:change`                                                              | 4 · `/sdd:plan`      | `sdd-flow/templates/plan.md` (MIT)                                       |
| Tasks               | `specs/NNN-<slug>/tasks.md`                 | Created by `/sdd:tasks`. `/sdd:implement <n>` marks `[x]`. Updated by `/sdd:change`                                        | 5 · `/sdd:tasks`     | `sdd-flow/templates/tasks.md` (MIT)                                      |
| Code + verification | project path                                | `/sdd:implement <n>`, one task at a time                                                                                   | 6 · `/sdd:implement` | —                                                                        |
| Validation          | `specs/NNN-<slug>/validation.md`            | Written by `/sdd:validate`                                                                                                 | 7 · `/sdd:validate`  | `sdd-flow/templates/validation.md` (MIT)                                 |

## Rules that resolve the ambiguities

- **`NNN`**: three digits, `specs/`'s own counter, monotonic, never reusing
  deleted numbers. Starts at `001` in a new repo; when adopting SDD on top of
  an already-numbered series, continue it and note it in `AGENTS.md`. It is
  **not** the roadmap's ordinal nor a historical FR.
- **`<slug>`**: kebab-case, short, in the constitution's content language.
- **One folder per feature**, and when it closes, all four files exist
  (`spec`, `plan`, `tasks`, `validation`). If `validation.md` is missing, the
  feature isn't closed.
- **The roadmap links folder paths**, never bare numbers.
- **Precedence**: `docs/constitution.md` rules over specs and plans. On
  conflict between `docs/`/`specs/` and `AGENTS.md`, `AGENTS.md` is the
  operational source for **code** and `docs/`/`specs/` is the **planning**
  layer.
- **`specs/` isn't modified** outside its phase without an explicit request.
- Clarifications go in `spec.md § Clarifications`, not in `plan.md`.

## On the toolkit's side (single source of truth)

| What               | Path in `sdd-toolkit`                                                                                                            |
| ------------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| The 9 commands     | `plugins/sdd/commands/{constitution,spec,clarify,plan,tasks,implement,validate,change,docs}.md`                                  |
| Flow skill         | `plugins/sdd/skills/sdd-flow/SKILL.md`                                                                                           |
| Phase templates    | `plugins/sdd/skills/sdd-flow/templates/`                                                                                         |
| Documents skill    | `plugins/sdd/skills/sdd-documents/SKILL.md`                                                                                      |
| Document templates | `plugins/sdd/skills/sdd-documents/templates/`                                                                                    |
| Spec template      | `plugins/sdd/skills/spec-generator/spec-template.md` (separate, Apache-2.0)                                                      |
| Installed as       | plugin: `/sdd:<phase>` · script: `~/.claude/{skills,commands}/` and `~/.config/opencode/{skills,commands}/` with a `sdd-` prefix |

The newer templates (`roadmap.md`, `validation.md`, `CLAUDE.md`,
`AGENTS-sdd-section.md`) are the toolkit's own work → MIT, outside `NOTICE`.
Touching `spec-template.md` or `templates/{AGENTS,constitution}.md`
(Apache-2.0) requires updating `NOTICE`.
