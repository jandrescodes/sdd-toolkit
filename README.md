<div align="center">

# sdd-toolkit

**The complete Spec-Driven Development (SDD) flow packaged as skills and
slash commands for [Claude Code](https://claude.com/claude-code) and
[opencode](https://opencode.ai).**

[![validate](https://github.com/jandrescodes/sdd-toolkit/actions/workflows/validate.yml/badge.svg)](https://github.com/jandrescodes/sdd-toolkit/actions/workflows/validate.yml)
&nbsp;[![plugin](https://img.shields.io/badge/plugin-0.3.0-2f81f7)](./CHANGELOG.md)
&nbsp;![license](https://img.shields.io/badge/license-MIT%20%2B%20Apache--2.0-blue)

<em>The spec is the contract: if it isn't there, it isn't implemented.<br>
Every phase leaves a versioned artifact in the repo.</em>

</div>

---

## The flow

Eight phases, each with its artifact and slash command.

| #   | Phase          | Artifact                                            | Command         |
| --- | -------------- | --------------------------------------------------- | --------------- |
| 1   | Constitution   | `docs/constitution.md`                              | `constitution`  |
| —   | Roadmap        | `docs/roadmap.md` <sub>(by hand)</sub>              | _(template)_    |
| 2   | Specification  | `specs/NNN-<slug>/spec.md` <sub>(FRs in EARS)</sub> | `spec`          |
| 3   | Clarification  | `spec.md` § Clarifications                          | `clarify`       |
| 4   | Planning       | `specs/NNN-<slug>/plan.md`                          | `plan`          |
| 5   | Tasks          | `specs/NNN-<slug>/tasks.md`                         | `tasks`         |
| 6   | Implementation | code + verification <sub>(one task at a time)</sub> | `implement <n>` |
| 7   | Validation     | `specs/NNN-<slug>/validation.md`                    | `validate`      |
| 8   | Change         | updated spec <sub>(before code)</sub>               | `change <req>`  |

How you invoke each command depends on the install method:

- **Plugin** (Claude Code) — `/sdd:constitution`, `/sdd:spec`, …
- **Script** (flat directory) — `/sdd-constitution`, `/sdd-spec`, … <sub>(the
  script prefixes `sdd-` to avoid collisions)</sub>

The entry point is the **`sdd-flow`** skill (explains the flow and brings the
templates); phase 2 is driven by **`spec-generator`** (requirements
interview). Full map of artifacts and paths:
[`docs/artifacts.md`](./docs/artifacts.md).

## Installation

### Claude Code — plugin _(recommended)_

```
/plugin marketplace add jandrescodes/sdd-toolkit
/plugin install sdd@sdd-toolkit
```

Update with `/plugin update sdd`. Commands are `/sdd:<phase>`.

### opencode, or Claude Code without the plugin — script

```
git clone https://github.com/jandrescodes/sdd-toolkit
cd sdd-toolkit
./install.sh --target both        # claude | opencode | both
```

Copies to `~/.claude/{skills,commands}/` and/or
`~/.config/opencode/{skills,commands}/`. Options: `--dry-run` (writes
nothing), `--force` (overwrites destinations that differ). Idempotent.

> **Pick one path.** Installing the plugin and also running `install.sh
--target claude` duplicates every phase (`/sdd:spec` and `/sdd-spec`). On
> opencode, `install.sh --target opencode` is enough.

## Quick start

New project _(commands shown as the plugin form; with the script they're
`/sdd-<phase>`)_:

1. Copy the templates from `sdd-flow/templates/` — `constitution.md` and
   `roadmap.md` to `docs/`, `CLAUDE.md` and `AGENTS.md` to the root — and
   paste the `AGENTS-sdd-section.md` block into your `AGENTS.md`.
2. `/sdd:constitution` — agree on the project's principles.
3. `/sdd:spec <feature>` — guided interview → `spec.md`.
4. `/sdd:clarify` → `/sdd:plan` → `/sdd:tasks`.
5. `/sdd:implement 1`, `/sdd:implement 2`, … one task at a time.
6. `/sdd:validate` when done → `specs/NNN-<slug>/validation.md`.

**Repo with history** (existing MVP, scattered conventions)**?** Don't start
from scratch: [`docs/ADOPTING.md`](./docs/ADOPTING.md).

## Repo structure

```
plugins/sdd/                             single source of truth (skills + commands)
  skills/sdd-flow/templates/             artifact templates (MIT)
  skills/spec-generator/spec-template.md spec template (Apache-2.0)
docs/constitution.md · docs/roadmap.md   the toolkit's own SDD artifacts (living example)
docs/ADOPTING.md                         adopting SDD into a repo with history
docs/artifacts.md                        canonical map: where each artifact lives
specs/001-sdd-toolkit/                   the toolkit's own spec + plan + tasks + validation
install.sh                               distribution for opencode / Claude without the plugin
tests/validate.sh                        quality gate (JSON + frontmatter + install.sh smoke test)
CHANGELOG.md                             per-version history
```

This repo is built with its own flow: the artifacts in `docs/` and
`specs/001-sdd-toolkit/` are real.

## Versioning

Semantic versioning. The canonical version lives in
`plugins/sdd/.claude-plugin/plugin.json` and every release carries a git tag
**without the `v` prefix** (`0.1.0`, `0.2.0`, …) on the corresponding `main`
commit. Per-version detail is in [`CHANGELOG.md`](./CHANGELOG.md).

## Development

```
bash tests/validate.sh                          # quality gate
claude plugin validate ./plugins/sdd --strict   # plugin manifest
```

Only edit under `plugins/sdd/`. Everything else is a copy or an example.

## License

Dual license:

- **MIT** — the repo's own work: `install.sh`, `tests/validate.sh`, the 8
  slash commands, the `sdd-flow` skill and its templates (`roadmap.md`,
  `validation.md`, `CLAUDE.md`, `AGENTS-sdd-section.md`, `plan.md`,
  `tasks.md`), and the plugin manifests. See [`LICENSE`](./LICENSE).
- **Apache License 2.0** — files derived from MoureDev's course
  ([hello-sdd](https://github.com/mouredev/hello-sdd), Apache-2.0):
  `spec-generator/SKILL.md`, `spec-generator/spec-template.md`,
  `sdd-flow/templates/AGENTS.md`, and
  `sdd-flow/templates/constitution.md`. See
  [`LICENSE-APACHE`](./LICENSE-APACHE) and [`NOTICE`](./NOTICE).

---

<div align="center">

**Credits** — The SDD method, EARS notation applied this way, the spec
template, and the idea for the `spec-generator` skill come from the free
Spec-Driven Development course by **[Brais Moure (MoureDev)](https://moure.dev)**
· [video](https://youtube.com/live/5HaOxAAA5qI)
· [hello-sdd](https://github.com/mouredev/hello-sdd)

This repository only **packages** that flow as a plugin and an install
script. All credit for the method goes to MoureDev.

</div>
