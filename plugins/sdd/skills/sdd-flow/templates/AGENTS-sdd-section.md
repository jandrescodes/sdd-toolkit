<!--
  Block ready to paste into the project's AGENTS.md. Toolkit's own work
  (MIT). Adjust the <…> and delete the italicized notes.
-->

## Feature planning (Spec-Driven Development)

This project runs on SDD: spec first, then plan, then tasks, and only then
code. **The spec is the contract: if it isn't there, it isn't implemented.**

### Artifacts

```
docs/constitution.md          ← project principles (project level)
docs/roadmap.md               ← what's done / in progress / backlog (project level)
specs/NNN-<slug>/
├── spec.md                   ← WHAT and WHY (FRs in EARS) + § Clarifications
├── plan.md                   ← HOW (modules, data, decisions, risks)
├── tasks.md                  ← <30 min tasks + closeout block
└── validation.md             ← FR-by-FR walkthrough + verdict (left by phase 7)
```

A feature isn't closed until all four files exist.

### Phases

| #   | Phase          | Command (plugin / script)                   |
| --- | -------------- | ------------------------------------------- |
| 1   | Constitution   | `/sdd:constitution` · `/sdd-constitution`   |
| 2   | Specification  | `/sdd:spec` · `/sdd-spec`                   |
| 3   | Clarification  | `/sdd:clarify` · `/sdd-clarify`             |
| 4   | Planning       | `/sdd:plan` · `/sdd-plan`                   |
| 5   | Tasks          | `/sdd:tasks` · `/sdd-tasks`                 |
| 6   | Implementation | `/sdd:implement <n>` · `/sdd-implement <n>` |
| 7   | Validation     | `/sdd:validate` · `/sdd-validate`           |
| 8   | Change         | `/sdd:change <req>` · `/sdd-change <req>`   |

### Rules

- **`specs/NNN` numbering**: `specs/`'s own counter, three digits, monotonic,
  never reusing deleted numbers. <Starts at `001` | continues the inherited
  series from `NNN` — adoption decision>. It is not the roadmap's ordinal nor
  a historical FR.
- **Verification as a gate**: no task is marked `[x]` without
  <automated suite green | running `<command or skill>` and attaching the
  evidence>.
- **Precedence**: `docs/constitution.md` rules over specs and plans. On
  conflict between `docs/`/`specs/` and this file, this file is the
  operational source for **code** and `docs/`/`specs/` is the **planning**
  layer.
- **`docs/` and `specs/` are versioned but not deployed**: exclude them from
  the deploy artifact and the docroot.
- Don't modify `specs/` outside its phase without an explicit request.
