# Spec 001 — sdd-toolkit

**Status:** implemented ✅ (0.3.0) — see "Later changes" at the end.

## Context and goal

The Spec-Driven Development flow (Constitution → Spec → Clarification → Plan
→ Tasks → Implementation → Validation → Change) today lives scattered:
loose prompts and a skill installed by hand in a project. This toolkit
packages it as something reusable and installable, so any new project has
the 8 phases available as skills and slash commands, in Claude Code and in
opencode.

## Users / actors

Developers working with AI agents (Claude Code or opencode) who want a
consistent SDD flow across projects, without copying prompts by hand.

## User stories

- U1: As a developer I want to install the toolkit once to have the SDD
  flow in all my projects.
- U2: As a developer I want one command per phase so I don't have to
  memorize prompts.
- U3: As a developer I want a guided requirements interview that generates
  the spec in the agreed format.
- U4: As a maintainer I want to edit the content in a single place.

## Functional requirements (EARS acceptance criteria)

### Distribution and installation

- FR-1: WHEN the user runs `/plugin marketplace add <repo>` and then
  `/plugin install sdd@sdd-toolkit` in Claude Code, THE SYSTEM shall expose
  8 slash commands (namespaced by the plugin as `/sdd:<phase>`) and 2 skills
  (`sdd-flow`, `spec-generator`).
- FR-2: WHEN the user runs `bash install.sh --target opencode`, THE SYSTEM
  shall copy the skills to `~/.config/opencode/skills/` and the commands to
  `~/.config/opencode/commands/`, each command file prefixed with `sdd-`.
- FR-3: WHEN the user runs `bash install.sh --target claude`, THE SYSTEM
  shall copy the skills to `~/.claude/skills/` and the commands to
  `~/.claude/commands/`, each command file prefixed with `sdd-`.
- FR-4: IF `--target both` is passed, THEN THE SYSTEM shall apply FR-2 and
  FR-3 in the same run.
- FR-5: WHEN `install.sh` runs twice in a row with no changes to the
  source, THE SYSTEM shall leave the destination identical the second time
  (idempotent).
- FR-6: IF a destination file already exists and differs from the source,
  THEN `install.sh` shall skip it and report it, unless `--force` is
  passed.
- FR-7: WHEN `--dry-run` is passed, THE SYSTEM shall list what it would
  copy without writing anything.
- FR-8: IF an unrecognized `--target` is passed, or none at all, THEN
  `install.sh` shall print usage and exit with status 1.

### Flow phases

- FR-9: WHEN `/sdd:constitution` is invoked, THE SYSTEM shall propose a
  constitution of short, verifiable principles and wait for approval
  before writing `docs/constitution.md`.
- FR-10: WHEN `/sdd:spec` is invoked, THE SYSTEM shall start an interview
  of at most 6 questions asked one at a time, shall NOT write code, and
  when done shall generate `specs/NNN-<slug>/spec.md` with FRs in EARS and
  an "Out of scope" section.
- FR-11: WHEN `/sdd:clarify` is invoked, THE SYSTEM shall review the
  active spec like a QA and list ambiguities, contradictions, missing edge
  cases, and conflicts with the constitution, without proposing solutions.
- FR-12: WHEN `/sdd:plan` is invoked, THE SYSTEM shall generate
  `specs/NNN-<slug>/plan.md` with modules, data model, justified decisions,
  risks, and a verification strategy, without writing code.
- FR-13: IF `docs/constitution.md` doesn't exist or there's no active spec
  in `specs/` when `/sdd:plan` is invoked, THEN THE SYSTEM shall warn and
  stop.
- FR-14: WHEN `/sdd:tasks` is invoked, THE SYSTEM shall generate
  `specs/NNN-<slug>/tasks.md` with tasks ordered by dependency, each with
  its FRs, a checkbox, and a verifiable "Done when:" line.
- FR-15: WHEN `/sdd:implement <n>` is invoked, THE SYSTEM shall implement
  only task T\<n\>, verification first (automated suite or manual
  checklist), run it, mark the task, and stop.
- FR-16: WHEN `/sdd:validate` is invoked, THE SYSTEM shall walk the spec
  FR by FR with its verification, write `specs/NNN-<slug>/validation.md`,
  and issue a compliance verdict.
- FR-17: WHEN `/sdd:change <requirement>` is invoked, THE SYSTEM shall
  update the spec first and show the diff, without touching code.

### Maintenance and quality

- FR-18: THE SYSTEM shall keep `plugins/sdd/` as the single editable copy;
  `install.sh`'s destinations are copies.
- FR-19: IF `tests/validate.sh` detects a JSON file that fails to parse,
  or a `SKILL.md` or command missing `name`/`description` in its
  frontmatter, THEN it shall exit with status 1 and list each failure.
- FR-20: THE SYSTEM shall include the SDD artifacts from its own build
  (`docs/constitution.md`, `specs/001-sdd-toolkit/`) as a living example in
  the repo.

## Non-functional requirements

- No runtime dependencies beyond `bash` and `python3` or `node` to
  validate JSON.
- The toolkit's own content (prompts, commands, docs) in English;
  identifiers in English.
- Compatible with macOS and Linux (bash 3.2+). Windows via WSL.

## Edge cases

- `install.sh` with neither `~/.config/opencode/` nor `~/.claude/` →
  creates the paths.
- Reinstalling over a previous version → FR-5, FR-6.
- Destination file modified by the user → FR-6 (skipped without
  `--force`).
- `/sdd:plan` in a project with no constitution → FR-13.
- Corrupt `marketplace.json` or `plugin.json` → FR-19.

## Out of scope

Support for Cursor or other agents; automatic semantic versioning; a
graphical interface; publishing the repo on GitHub (done by hand by the
maintainer).

## Completion criteria

- All FRs with evidence in the validation (`specs/001-sdd-toolkit/` +
  `/sdd:validate` walkthrough).
- `bash tests/validate.sh` green.
- `claude plugin validate ./plugins/sdd --strict` with no errors.
- Manual demo: install on a scratch project and run `/sdd:constitution` and
  `/sdd:spec` with no errors.

## Open questions

- None. (Resolved during clarification — see below.)

## Clarifications

Findings from the QA pass and their resolution:

1. **Ambiguity**: "copy commands to opencode" — to which path? Resolved:
   FR-2 fixes `~/.config/opencode/commands/` (the one opencode documents;
   tested: `command/` singular also works, but the documented one is
   used).
2. **Missing edge case**: what happens if the destination was edited by
   the user. Resolved: FR-6 (skip + report; `--force` to overwrite).
3. **Potential contradiction**: FR-1 says "8 commands", the list had loose
   names. Resolved: canonical list fixed — constitution, spec, clarify,
   plan, tasks, implement, validate, change.
4. **Conflict with constitution #4**: validating JSON needs a parser.
   Resolved: `python3` **or** `node` accepted (both common), no new
   dependency added.
5. **Ambiguity**: "waits for approval" in FR-9 — what about FR-10/12?
   Resolved: spec and plan also ask for explicit approval; reflected in
   each command.
6. **Edge case**: `/sdd:implement` with no number. Resolved: the command
   asks for the number if missing (doesn't assume T1).

## Later corrections (2026-08-27 review)

Second review pass over the initial version. Spec changes:

- **FR-1**: the plugin's command files do **not** carry an `sdd-` prefix;
  Claude Code namespaces them as `/sdd:<phase>`. The `sdd-` prefix is
  added by `install.sh` only when copying them into a flat directory
  (FR-2, FR-3).
- **FR-2**: opencode's commands path changes to
  `~/.config/opencode/commands/` (plural, documented) instead of
  `command/`.
- **FR-8**: also covers `--target` present but with no value
  (`./install.sh --target`) → usage + exit 1.
- **Completion criteria / FR-19**: `tests/validate.sh` gains a real smoke
  test of `install.sh` (installs against a temporary `HOME` and checks
  paths, prefix, idempotence, `--dry-run`, `--force`, and error exits).
  Previously that test was only described in the plan.
- **License**: material derived from `mouredev/hello-sdd` (Apache-2.0) is
  redistributed under Apache-2.0, not MIT — see `LICENSE-APACHE` and
  `NOTICE`.

## Later changes (flow improvements, 2026-09)

Friction found when applying the toolkit to a real repo with history (MVP
done, scattered conventions), fixed in version 0.2.0. Spec changes:

- **FR-15 / FR-16**: "tests" → "verification" (automated suite **or**
  documented manual checklist), for projects without a suite. FR-16 also
  requires phase 7 to leave `validation.md` behind.
- **Out of scope**: CI/GitHub Actions removed from the list —
  `.github/workflows/validate.yml` added.
- **New project-level artifacts / templates** (don't change FRs; material
  of the `sdd-flow` skill): `docs/roadmap.md`, `templates/roadmap.md`,
  `templates/validation.md`, `templates/CLAUDE.md`,
  `templates/AGENTS-sdd-section.md`, `docs/ADOPTING.md`.
- **Phase 3**: its trace is fixed at `spec.md § Clarifications`.
- Plugin version: `0.1.0` → `0.2.0`.

## Later changes (English toolkit, user-chosen spec language, 2026-09)

The out-of-scope item ruling out "translating the content to other
languages" is superseded: the toolkit's own prompts, commands, skills, and
docs are now English (the ecosystem convention for Claude Code plugins),
while generated spec/plan/tasks/validation **content** language is chosen
by the target project's constitution (defaulting to the user's language).
Spec changes:

- **`RF-` renamed to `FR-`** throughout this spec and the rest of the
  toolkit. Past occurrences in this document were rewritten for
  consistency, since this spec is the toolkit's own dogfood artifact, not
  a third-party adopter's.
- EARS keywords translated to their English canonical form (`WHEN`, `THE
SYSTEM SHALL`, `IF...THEN`).
- Non-functional requirements: "content in Spanish" → "the toolkit's own
  content in English"; per-project spec content language is now a
  constitution-level decision, documented in `docs/constitution.md`
  principle 2.
- Plugin version: `0.2.0` → `0.3.0`.
