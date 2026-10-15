# Validation — Spec 003 (derived-docs)

**Date:** 2026-10-14

**Verification run:** `bash tests/validate.sh` → exit 0 ("OK — sin problemas");
`claude plugin validate ./plugins/sdd --strict` → passed. Behavior scenarios
were **simulated** by subagents that read `SKILL.md` and the templates from
the working tree and followed them literally on throwaway projects (not
committed): T19 = scenarios A–C, T20 = D and H, T21 = E and G, T22 = F,
T23 = this repo, plus a re-check after the corrections and a FR-3/FR-24
check. No real `claude -p "/sdd:docs …"` session was run (see Notes).
Abbreviations: **S** = structural check in `tests/validate.sh`; **N** =
negative test in a temp copy; **A–H** = manual scenarios; **R** = re-check
after the corrections; **I** = inspection of the rule text.

## FR by FR

| FR    | Summary                                                              | Evidence                                                                                      | Result             |
| ----- | -------------------------------------------------------------------- | --------------------------------------------------------------------------------------------- | ------------------ |
| FR-1  | `flow`, `ux`, `delivery` accepted alongside the five                 | I: table and §1 list the eight; `argument-hint` of `commands/docs.md` agrees                  | PASS               |
| FR-2  | `flow`/`ux` generate instead of "write by hand"                      | A, T23: documents generated                                                                   | PASS               |
| FR-3  | Missing/unknown name → list the eight, generate nothing              | I + literal run of `foo` and no argument                                                      | PASS               |
| FR-4  | Ambiguous natural-language request → ask                             | G: "documento de entrega" routed by closest single match; §1 asks when two or none fit (I)   | PASS               |
| FR-5  | `flow` filled from closed specs                                      | A (EN, ES): 5 journeys from closed specs, open feature not read                               | PASS               |
| FR-6  | Actors, journey per story, general journey, alternative/error paths  | A; R (General journey, system-only FRs rule added)                                            | PASS               |
| FR-7  | No source → `TODO: provide …`                                        | A, B, T23: gaps listed, nothing invented                                                      | PASS               |
| FR-8  | No `lite` gate for `flow`                                            | A, T23 ran without a gate                                                                     | PASS               |
| FR-9  | No closed feature → say so, generate nothing                         | C: `flow` refused in EN and ES, no file written                                               | PASS               |
| FR-10 | `ux` from constitution + closed specs/plans                          | B, C: sourced fields only; constitution alone when none closed                                | PASS               |
| FR-11 | Audience context, goals, tone, visual direction as gaps              | B, T23, R                                                                                     | PASS               |
| FR-12 | No gate for `ux`, no closed feature required                         | C (ux without closed features)                                                                | PASS               |
| FR-13 | Proposal ends with the gap list                                      | A, B, T23: gap list present                                                                   | PASS               |
| FR-14 | One project-level `delivery`, roadmap order                          | E, T23, R                                                                                     | PASS               |
| FR-15 | Goal, plain requirements + outcome, changes, Known limits           | E, R: "verified with limits" for qualified results; limits only from the heading              | PASS               |
| FR-16 | Client-facing rules, review list, gaps out of limits                 | E, R: no risks/Reasons/open questions; `FR-` only allowed in the changes table; gaps listed   | PASS               |
| FR-17 | `lite` gate on `delivery`, every time                                | E: asked each request, decline wrote nothing                                                  | PASS               |
| FR-18 | Non-closed features in one line each                                 | E, T23: `003-derived-docs` listed as in progress                                              | PASS               |
| FR-19 | `delivery` with no closed feature → say so, nothing                  | I: §8 `delivery` step 1; not exercised                                                        | PASS (inspection)  |
| FR-20 | Blank hand-off lines                                                 | E, T23: block present (the formatter mangles the underscores, as in `acceptance`)             | PASS               |
| FR-21 | `flow`/`ux` use the schema write path                                | D, T23: header, diff, approval, no `.gitignore` check                                         | PASS               |
| FR-22 | `delivery` uses the full client write path                           | E: header, diff, approval, `.gitignore` proposal accepted and verified with `git check-ignore`| PASS               |
| FR-23 | Existing file: diff, approval, notes kept                            | D: "no" left files untouched; "yes" kept notes byte-identical                                 | PASS               |
| FR-24 | No notes heading → empty notes section + report                      | Check after the corrections: new file ends with an empty notes section and the report is made | PASS               |
| FR-25 | Templates carry notes section and derived header                     | S: notes heading check for both; `grep -c 'written by hand'` = 0                              | PASS               |
| FR-26 | Unchanged sources → "up to date"                                     | F: `flow`, `ux` identical; `delivery` after R and a day shift: only the date line differs     | PASS (English only)|
| FR-27 | Reuse wording for unchanged items, stable order                      | F, R: comparison logic verified; the rule now also requires the old wording to still comply   | PASS (observed)    |
| FR-28 | `validate.sh` fails on a missing template reference                  | S: ok on the repo; N: missing template and unprefixed command reference fail, prefixed ok     | PASS               |
| FR-29 | Command, skills, docs, README, roadmap, CHANGELOG updated            | `grep` of "written by hand" = 0 in both files; README usage line has `delivery` and `flow`    | PASS               |
| FR-30 | Version 0.6.0 and CHANGELOG section                                  | S: "las 4 cadenas coinciden (0.6.0)" and heading `[0.6.0]`                                    | PASS               |
| FR-31 | `delivery.md` shipped in the skill for all install paths             | S: smoke install copies `delivery`, `app-flow`, `ux-brief` to `.claude/` and `opencode/`      | PASS               |
| FR-32 | Keep non-gap content of existing `flow`/`ux` sections                | D: hand-written screen line kept; R: item-level merge kept a hand-written Tone line           | PASS               |
| FR-33 | `## Known limits` in the validation template; no gaps in it          | I: template and `validate.md` step 8; E, R used it                                            | PASS               |
| FR-34 | Missing template → name it, generate nothing                         | H, R: named and stopped, before the `lite` question                                           | PASS               |

## Uncovered FRs

None without verification. FR-19 is covered by inspection only.

## Completion criteria

- [x] All FRs verified; `bash tests/validate.sh` and `claude plugin validate
      ./plugins/sdd --strict` pass — table above; both commands exit 0.
- [x] Manual run of `flow`, `ux`, and `delivery` over this repo (specs
      001–002) — T23 and R; a second run reported "up to date" (F, in
      English; simulated).
- [x] `validation.md` written; roadmap moved to Done — this file and
      `docs/roadmap.md`.
- [ ] 0.6.0 tagged — pending: the user creates the tag after the commits.

## Verdict

**Spec fulfilled.** The `0.6.0` tag is the user's step after the commits;
nothing else is missing.

## Updated files

- `docs/roadmap.md` — feature added to `## Done ✅`.
- `docs/schema.md` — schema: skipped, no schema source found.

## Known limits

- Regenerating a document may rephrase prose that did not change; the
  "up to date" check relies on the model reusing the existing wording.

## Notes

- Scenarios were simulated by following `SKILL.md` literally, not run through
  real `/sdd:docs` sessions, so they test the rules' wording and not live
  model behavior. The second run of each document (FR-26/27) copied the first
  run's wording, so it proves the comparison logic, not stability across
  independent runs. Real Copilot CLI and opencode sessions were not run.
- The 14 defects found by the scenarios were fixed in `SKILL.md` and the
  templates before this validation and re-checked (R). Open points: the
  hand-off underscore lines are mangled by the formatter (as in
  `acceptance.md`); "concerns the user experience" in the `ux` mapping is a
  judgment call; a free-text hand-written file with no `##` sections is
  replaced as a whole (consistent with the FR-24 report).
- FR-26 was observed in English only; the Spanish repeat was not run.
- `docs/app-flow.md` and `docs/ux-brief.md` were regenerated before the last
  five small wording fixes and were not refreshed afterwards.
- Spec 002 FR-34 still says `flow` and `ux` are hand-written; it is kept as
  history of a closed feature.
