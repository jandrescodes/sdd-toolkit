# Validation — Spec 001

**Date:** 2026-08-27

FR-by-FR walkthrough. First pass 2026-08-27; revised after the corrections
the same day (see "Later corrections" in `spec.md`).

| FR    | Summary                                                                    | Evidence                                                                                                                                                                                                                                                          | Verdict                 |
| ----- | -------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------- |
| FR-1  | Plugin exposes 8 commands + 2 skills                                       | Installed locally from a Directory-type marketplace: `claude plugin details sdd` → commands `constitution, spec, clarify, plan, tasks, implement, validate, change`; skills `sdd-flow`, `spec-generator`. `--strict` green. Invoked via plugin as `/sdd:<phase>`. | PASS                    |
| FR-2  | `install.sh --target opencode` → opencode paths, prefixed commands         | Smoke test in `tests/validate.sh`: `~/.config/opencode/skills/…` and `~/.config/opencode/commands/sdd-*.md`                                                                                                                                                       | PASS                    |
| FR-3  | `install.sh --target claude` → claude paths, prefixed commands             | Smoke test: `~/.claude/skills/…` and `~/.claude/commands/sdd-*.md`; no bare `spec.md`                                                                                                                                                                             | PASS                    |
| FR-4  | `--target both` applies both                                               | Smoke test: 30 files across the 4 paths                                                                                                                                                                                                                           | PASS                    |
| FR-5  | Idempotent                                                                 | Smoke test: second pass → "No changes (already up to date)"                                                                                                                                                                                                       | PASS                    |
| FR-6  | A differing destination is skipped without `--force`; `--force` overwrites | Smoke test: `sdd-spec.md` modified at destination → unchanged without `--force`; identical to source again with `--force`                                                                                                                                         | PASS                    |
| FR-7  | `--dry-run` writes nothing                                                 | Smoke test: after `--target both --dry-run`, 0 files in the temporary `HOME`                                                                                                                                                                                      | PASS                    |
| FR-8  | Invalid / missing / valueless target → usage + exit 1                      | Smoke test: `install.sh` (no args), `--target zzz`, `--target` (no value) → all three exit 1                                                                                                                                                                      | PASS                    |
| FR-9  | `/sdd:constitution` proposes and waits for approval                        | `commands/constitution.md` step 4: "wait for my explicit approval"                                                                                                                                                                                                | PASS (command contract) |
| FR-10 | `/sdd:spec` interviews ≤6, no code, generates an EARS spec                 | `commands/spec.md` + `spec-generator` skill (max 6, one at a time, EARS, "Out of scope")                                                                                                                                                                          | PASS (contract)         |
| FR-11 | `/sdd:clarify` lists without resolving                                     | `commands/clarify.md`: 4 blocks, "only detect, don't resolve"; `allowed-tools: Read, Grep, Glob` (can't write)                                                                                                                                                    | PASS (contract)         |
| FR-12 | `/sdd:plan` generates a plan with no code                                  | `commands/plan.md` step 3: "Do NOT write code" + sections                                                                                                                                                                                                         | PASS (contract)         |
| FR-13 | `/sdd:plan` stops without a constitution/spec                              | `commands/plan.md` step 1: "warn and stop"                                                                                                                                                                                                                        | PASS (contract)         |
| FR-14 | `/sdd:tasks` tasks <30min + "Done when:"                                   | `commands/tasks.md`                                                                                                                                                                                                                                               | PASS (contract)         |
| FR-15 | `/sdd:implement <n>` only Tn, verification first, stops                    | `commands/implement.md` steps 4-7 (suite or checklist)                                                                                                                                                                                                            | PASS (contract)         |
| FR-16 | `/sdd:validate` walks FRs, writes `validation.md`, gives a verdict         | `commands/validate.md` steps 2-6; `allowed-tools: …, Write, Skill`                                                                                                                                                                                                | PASS (contract)         |
| FR-17 | `/sdd:change` updates the spec + diff before code                          | `commands/change.md` steps 1, 4, 5                                                                                                                                                                                                                                | PASS (contract)         |
| FR-18 | `plugins/sdd/` is the only editable copy                                   | `install.sh` copies FROM `plugins/sdd/`; README and constitution fix this                                                                                                                                                                                         | PASS                    |
| FR-19 | `validate.sh` fails on invalid JSON/frontmatter                            | `tests/validate.sh`: `json_check` + `frontmatter_value`, exit 1 with a list                                                                                                                                                                                       | PASS                    |
| FR-20 | Own SDD artifacts in the repo                                              | `docs/constitution.md`, `specs/001-sdd-toolkit/{spec,plan,tasks,validation}.md`                                                                                                                                                                                   | PASS                    |

## Completion criteria

- [x] All FRs with evidence (table above).
- [x] `bash tests/validate.sh` green (includes `install.sh`'s smoke test).
- [x] `claude plugin validate ./plugins/sdd --strict` with no errors.
- [x] Plugin install verified locally: `claude plugin marketplace add
<path>` + `claude plugin install sdd@sdd-toolkit` OK; `claude plugin
details sdd` lists the 8 commands (`constitution`, `spec`, …) and the
      2 skills (`sdd-flow`, `spec-generator`); `--strict` green.
- [x] Install from the marketplace **published on GitHub**:
      `claude plugin marketplace add jandrescodes/sdd-toolkit` +
      `claude plugin install sdd@sdd-toolkit` OK; `claude plugin details
  sdd` lists the 8 commands and the 2 skills.
- [ ] End-to-end walkthrough of the 8 phases on a real project using the
      installed plugin (left as the toolkit's normal usage).

## Verdict

**Spec fulfilled at the artifact and automated quality-gate level.**
FR-9..FR-17 are validated at the slash command's contract level (the
agent's behavior when running them). The only check that can't be
automated here remains pending: installing the plugin from the already
published marketplace and walking through a real project with it.

## Notes

- **2026-09 flow improvements (0.2.0)**: FR-15/FR-16 revised (verification
  instead of tests; `validate` leaves `validation.md`). No new FRs — the
  rest of that batch is templates and docs for the `sdd-flow` skill.
  `bash tests/validate.sh` and `claude plugin validate --strict` stayed
  green after the changes.
- **2026-09 English toolkit, user-chosen spec language (0.3.0)**: no new
  FRs — `RF-` renamed to `FR-` throughout, EARS keywords translated to
  English, spec content language now chosen by the target project's
  constitution instead of hardcoded. `bash tests/validate.sh` and `claude
plugin validate --strict` stayed green after the changes.
- `install.sh` uses `find -type f` with no stable order across
  filesystems; doesn't affect the result (copies file by file) but the
  listing order may vary.
- Dual license since the review: MIT for the toolkit's own work,
  Apache-2.0 for the 4 files derived from hello-sdd (`LICENSE-APACHE`,
  `NOTICE`).
