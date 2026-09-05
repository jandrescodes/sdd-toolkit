---
name: sdd-flow
description: Use this skill when the user wants to start or drive a project with Spec-Driven Development (SDD) — in any language they ask in ("start a project with SDD", "spec-driven flow", "do it phase by phase with a spec", "empezar con SDD", "flujo spec-driven"). Explains the 8 phases, which artifact each one leaves, and which slash command runs it, and brings the base templates to copy into the project.
---

# Spec-Driven Development (SDD)

Building software with agents starting from an agreed-upon spec, not
improvised prompts. **The spec is the contract: if it isn't in it, it isn't
implemented.** Every phase leaves a versioned artifact in the repo.

## The 8 phases

Commands are shown as `/sdd:<phase>` (plugin); with the install script
they're `/sdd-<phase>`.

| #   | Phase          | Artifact                                    | Command              |
| --- | -------------- | ------------------------------------------- | -------------------- |
| 1   | Constitution   | `docs/constitution.md`                      | `/sdd:constitution`  |
| —   | Agent context  | `AGENTS.md` (+ `CLAUDE.md` → `@AGENTS.md`)  | (template)           |
| —   | Roadmap        | `docs/roadmap.md` (project level, by hand)  | (template)           |
| 2   | Specification  | `specs/NNN-<slug>/spec.md`                  | `/sdd:spec`          |
| 3   | Clarification  | `specs/NNN-<slug>/spec.md` § Clarifications | `/sdd:clarify`       |
| 4   | Planning       | `specs/NNN-<slug>/plan.md`                  | `/sdd:plan`          |
| 5   | Tasks          | `specs/NNN-<slug>/tasks.md`                 | `/sdd:tasks`         |
| 6   | Implementation | code + tests, one task at a time            | `/sdd:implement <n>` |
| 7   | Validation     | `specs/NNN-<slug>/validation.md`            | `/sdd:validate`      |
| 8   | Change         | updated spec (diff) before code             | `/sdd:change <req>`  |

`/sdd:spec` **reads** `docs/roadmap.md` when picking a number; `/sdd:validate`
**moves** the feature to `Done ✅` when it closes. Full map of paths,
templates, and who touches what: the toolkit's `docs/artifacts.md`.

## Starting a project from scratch

1. Copy the templates from this skill's `templates/` folder into the
   project. Depending on how the toolkit is installed, `templates/` lives
   at:
   - Plugin: inside the `sdd` plugin (Claude Code resolves it on its own).
   - Script (`install.sh`): `~/.claude/skills/sdd-flow/templates/` and/or
     `~/.config/opencode/skills/sdd-flow/templates/`.

   Copies:
   - `constitution.md` → `docs/constitution.md`
   - `roadmap.md` → `docs/roadmap.md`
   - `AGENTS.md` → `AGENTS.md`; paste the `AGENTS-sdd-section.md` block into
     it
   - `CLAUDE.md` → `CLAUDE.md` (already has the `@AGENTS.md` line)
   - `plan.md`, `tasks.md`, and `validation.md` stay as reference; they get
     filled in during phases 4, 5, and 7.
   - The `spec.md` template is **not** in `templates/`: it's brought by the
     `spec-generator` skill (`spec-template.md`), applied by `/sdd:spec`.

2. Run `/sdd:constitution` and agree on the principles.
3. Run `/sdd:spec` for the first feature.
4. Follow the table's order. Don't skip phases.

## Adopting into a repo with history

If the repo already has an MVP, scattered conventions, and finished
features, **don't** start from scratch. Checklist (long version with an
example in the toolkit's `docs/ADOPTING.md`):

1. Inventory where conventions currently live (`CLAUDE.md`, `AGENT(S).md`,
   `CONTRIBUTING`, `docs/`, wiki) and consolidate them into a **terse**
   `AGENTS.md` + `docs/<topic>.md`. Paste the `AGENTS-sdd-section.md` block.
2. Derive `docs/constitution.md` from what the repo **already does** (real
   stack, rules implicit in the code), not from scratch.
3. Seed `docs/roadmap.md`: `Done ✅` with the existing features, one line
   each, without retroactively writing `spec/plan/tasks` (point to the
   `CHANGELOG`).
4. Decide where product scope lives: if there's a public README, there; if
   not, in the constitution.
5. `specs/` numbering: if the repo already had numbered specs, continue the
   series and note it in `AGENTS.md`; if not, start at `001`.
6. Exclude `docs/` and `specs/` from the deploy artifact.
7. Sweep the references (README, prompts, internal docs, your own skills).
8. No code. Everything into a separate `docs:` commit, approved before
   writing.

After that, phases 1-8 proceed as usual.

## Golden rules

- **WHAT and WHY in the spec; HOW in the plan.** No stack, files, or
  algorithms in the spec.
- **One task at a time, verification first.** Never proceed without the
  automated suite green or — if there is none — the manual checklist with
  its evidence.
- **Change = spec before code.** New requirement → spec diff first, then
  implement.
- **If a decision is missing, stop and ask.** A visible gap is information;
  a silent assumption is debt.
- **Precedence**: `docs/constitution.md` rules over specs and plans. On
  conflict between `docs/`/`specs/` and `AGENTS.md`, `AGENTS.md` is the
  operational source for code and `docs/`/`specs/` is the planning layer.
- **`docs/` and `specs/` are versioned but not deployed.**
- **Content language**: whatever the project's constitution declares; if
  there is none, whatever the user is writing in. Be tolerant of the
  language you're addressed in regardless of the content language chosen.

## About `AGENTS.md`

`AGENTS.md` holds **rules the agent must obey**, not reference material.
Anything that's reference — API dumps, endpoint catalogs, long checklists,
step-by-step flows, schema tables — goes in `docs/<topic>.md`, and
`AGENTS.md` links it with **one rule line + "see `docs/X`"**. Quick test: if
a paragraph can't be rewritten as "do X" / "never do Y", it doesn't belong
in `AGENTS.md`.

## EARS notation (for specs)

| Pattern      | Form                                        |
| ------------ | ------------------------------------------- |
| Ubiquitous   | THE SYSTEM \<shall\>                        |
| Event-driven | WHEN \<trigger\>, THE SYSTEM \<shall\>      |
| State-driven | WHILE \<state\>, THE SYSTEM \<shall\>       |
| Optional     | WHERE \<feature\>, THE SYSTEM \<shall\>     |
| Unwanted     | IF \<condition\>, THEN THE SYSTEM \<shall\> |

The requirements interview and spec drafting are done by the
`spec-generator` skill (triggered by `/sdd:spec`).
