# Adopting SDD into a repo with history

The `sdd-flow` skill's flow covers "starting from scratch". This document
covers the opposite case: a repo that **already** has an MVP, scattered
conventions, and finished features. The short version of this checklist
lives in `sdd-flow/SKILL.md` § "Adopting into a repo with history"; here's
the detail and a worked example.

> General rule: **no code**. Adoption is a documentation task. Everything
> goes into a separate `docs:` commit, approved before writing.

## Checklist

### 1. Inventory where conventions currently live

`CLAUDE.md`, `AGENT.md`/`AGENTS.md`, `CONTRIBUTING.md`, `docs/`, wikis,
headers of your own skills, PR templates. Make the list before moving
anything.

### 2. Consolidate into a terse `AGENTS.md` + `docs/`

`AGENTS.md` is the index of **rules** ("do X" / "never Y"). Anything that's
reference material — API dumps, endpoint catalogs, schema tables,
step-by-step flows — goes to `docs/<topic>.md`, linked with one line.
`CLAUDE.md` keeps the `@AGENTS.md` line + whatever's exclusive to Claude
Code. Paste the `templates/AGENTS-sdd-section.md` block into `AGENTS.md`.

### 3. Derive `docs/constitution.md` from what the repo already does

Real stack, rules implicit in the code, limits already respected. Don't
invent it: if the code never does a hard `DELETE`, that's a principle; if
all authorization goes through a single point, that's a principle.

### 4. Seed `docs/roadmap.md`

`Done ✅` section with the existing features, **one line each**. Don't
retroactively write `spec/plan/tasks` for what's already done — point to the
`CHANGELOG`. `Next` / `Backlog` with what's coming.

### 5. Decide where product scope lives

The "what it is and what it's NOT" (`mission` in older structures): if the
repo has a public README, the long version goes there and the constitution
summarizes it in one principle; if not, it goes entirely in the
constitution.

### 6. `specs/` numbering

If the repo already had numbered specs (e.g. a prior `spec/features/007-…`
folder), **continue the series** — the next feature is `008`, not `001` —
and note that decision in `AGENTS.md`. The number doesn't have to match the
roadmap's ordinal or historical FRs.

### 7. Exclude `docs/`, `specs/`, and `deliverables/` from deployment

They're development artifacts and often contain schema, queries, and
thresholds; `deliverables/` holds the client documents that `/sdd:docs`
generates. If the deploy does `rsync`/a checkout copy, add
`--exclude='docs/' --exclude='specs/' --exclude='deliverables/'` (and
`.github/`). If the server serves the repo directly, remove them from the
docroot.

### 8. Sweep the references

`README.md`, prompt files, internal docs, headers of your own skills, PR
templates: any prior "read `CLAUDE.md` first" or ad-hoc flow now points to
the SDD flow. Leave historical `CHANGELOG` mentions intact.

## Example — a repo with an MVP and a prior ad-hoc `spec/` structure

Typical shape of the adoption, in a single `docs:` commit (no code touched):

| What was done   | Detail                                                                                                            |
| --------------- | ----------------------------------------------------------------------------------------------------------------- |
| Merge context   | `AGENT.md` + the bulk of `CLAUDE.md` → terse `AGENTS.md`; `CLAUDE.md` reduced to `@AGENTS.md` + Claude Code notes |
| Constitution    | Principles derived from the real code (implicit rules already respected)                                          |
| Roadmap         | `spec/constitution/roadmap.md` → `docs/roadmap.md`, rewriting internal paths                                      |
| Mission / scope | `spec/constitution/mission.md` → `README.md § Scope` (it was a product with a public README)                      |
| Tech stack      | `spec/constitution/tech-stack.md` merged into `AGENTS.md` (rules) + `docs/` (reference)                           |
| Example feature | The feature already documented in `spec/features/NNN-…` was kept only as reference                                |
| Numbering       | The `specs/` series continued from the last number used, noted in `AGENTS.md`                                     |
| Deploy          | Deploy workflow: `--exclude='docs/' --exclude='specs/' --exclude='deliverables/'` in the `rsync`                  |
| Sweep           | README, internal prompts, internal docs, and headers of the repo's own skills                                     |

After that, the normal flow's phases 1-8 apply unchanged.
