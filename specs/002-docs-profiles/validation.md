# Validation — Spec 002 (docs-profiles)

**Date:** 2026-10-14

**Verification run:** `bash tests/validate.sh` → exit 0 ("OK — sin problemas");
`claude plugin validate ./plugins/sdd --strict` → passed. Manual scenarios ran
with `claude -p "/sdd:<cmd>" --plugin-dir plugins/sdd` (Claude Code 2.1.299)
on throw-away projects (not committed): T28 = sample A, T29 = sample B,
T30 = this repo. Abbreviations: **S** = structural check in `tests/validate.sh`;
**A** = T28 result; **B** = T29 result.

## FR by FR

| FR    | Summary                                                                                 | Evidence                                                                                                                | Result            |
| ----- | --------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------- | ----------------- |
| FR-1  | One `Docs profile: lite\|formal` setting in the `AGENTS.md` SDD section                 | S: template has exactly one active line; A: p-formal                                                                    | PASS              |
| FR-2  | Absent line / file / section → `lite`                                                   | A: p-nofile, p-noline                                                                                                   | PASS              |
| FR-3  | Invalid or duplicated value → report + `lite`                                           | A: p-invalid, p-dup, p-case, p-comment (ignored)                                                                        | PASS              |
| FR-4  | Fulfilled → update `docs/schema.md` without asking (migrations, else models)            | A: v-mig, v-models, v-noroadmap                                                                                         | PASS              |
| FR-5  | Not fulfilled → schema untouched                                                        | A: v-fail (`git status` shows only validation.md)                                                                       | PASS              |
| FR-6  | No schema source → skip, record `schema: skipped, no schema source found`               | A: v-none; this repo's own validation (below)                                                                           | PASS              |
| FR-7  | Fulfilled → feature moved to Done in roadmap (added if absent)                          | A: v-mig (Next → Done), v-absent; this run (appended item 5)                                                            | PASS              |
| FR-8  | Not fulfilled → roadmap untouched                                                       | A: v-fail                                                                                                               | PASS              |
| FR-9  | No roadmap file → skip + note                                                           | A: v-noroadmap                                                                                                          | PASS              |
| FR-10 | Updated files listed in `validation.md`                                                 | A: v-mig, v-models; this file's `## Updated files`                                                                      | PASS              |
| FR-11 | Approved change → `CHG-n — date — title` entry (Type, FRs, Reason)                      | A: c-approve, c-nosect, c-decline (nothing recorded)                                                                    | PASS              |
| FR-12 | `n` = highest + 1; duplicates reported                                                  | A: c-approve (CHG-4), c-dup (reported, CHG-3)                                                                           | PASS              |
| FR-13 | Free-form "Later changes" tolerated                                                     | A: c-approve (section untouched); B: b-main (001 has CHG before validation)                                             | PASS              |
| FR-14 | Generate PRD, TRD, acceptance, changes, schema from artifacts                           | B: prd/trd/acceptance/changes; schema via validate automatic mode (A). Interactive `/sdd:docs schema` not run by hand   | PASS (see gap 1)  |
| FR-15 | Generation available through a skill, natural language                                  | B: b-nl nl1/nl2; S: skill exists                                                                                        | PASS              |
| FR-48 | Ambiguous natural-language request → ask, generate nothing                              | B: b-nl                                                                                                                 | PASS              |
| FR-16 | `/sdd:docs <name>` runs the generation                                                  | B: all `/sdd:docs …` runs; S: `commands/docs.md`                                                                        | PASS              |
| FR-17 | Missing/unknown name → list valid names, nothing generated                              | B: b-misc m3, m4                                                                                                        | PASS              |
| FR-18 | Proposal first, write only after explicit approval                                      | A: p-formal (not written without approval); B: s1, s4                                                                   | PASS              |
| FR-19 | `lite` → warn + confirm on every request; schema exempt                                 | A: p-nofile…; B: b-lite l1, b-lite3 q1–q3; schema exemption by skill text (S only)                                      | PASS              |
| FR-20 | `lite` declined → nothing written                                                       | B: b-lite2                                                                                                              | PASS              |
| FR-21 | Missing source artifact → name it, generate nothing                                     | B: b-acc a3 (no validation.md); b-empty z1                                                                              | PASS              |
| FR-22 | Existing file → diff ignoring date line, approval to overwrite                          | B: b-main s2/s3 (hand-edited file byte-identical on "No")                                                               | PASS              |
| FR-50 | Only date line changes → "up to date", nothing written                                  | B: b-utd u2 (English). Not byte-stable in b-es (see limits)                                                             | PASS (see limits) |
| FR-23 | Only closed features, roadmap order else spec number                                    | B: b-main s1 (004, 001 in roadmap order), s5                                                                            | PASS              |
| FR-24 | Excluded features listed in one line                                                    | B: b-main s1 (002 "re-validation required", 003 "in progress")                                                          | PASS              |
| FR-45 | No closed feature → say so, nothing generated                                           | B: b-empty z1                                                                                                           | PASS              |
| FR-43 | `acceptance` for a single closed feature (arg or latest)                                | B: b-main s6 (latest), b-acc a1 (argument)                                                                              | PASS              |
| FR-44 | Acceptance of non-closed feature → reason, nothing generated                            | B: b-acc a2 (stale), a3 (in progress), a9 (unknown)                                                                     | PASS              |
| FR-25 | Header: sources, date, specs prevail                                                    | T30: `deliverables/prd.md` header (Generated, Sources, precedence line); B: s1                                          | PASS              |
| FR-26 | Fixed output paths                                                                      | B: s1, s4, s5, s6 (`acceptance-004-export.md`); T30: `acceptance-001-sdd-toolkit.md`, `prd.md`, `trd.md`                | PASS              |
| FR-27 | Omit risks, verification, open questions, NEEDS CLARIFICATION; changes omit Reason      | B: l1 (no Risks/Verification), s5 (Reasons omitted); T30                                                                | PASS              |
| FR-28 | Review list (queries, thresholds, identifiers, hostnames, credentials, omitted Reasons) | B: l1 (table lists hostname, credential, threshold, query), s5                                                          | PASS              |
| FR-29 | PRD as plain sentences, no EARS/FR-/technical ids                                       | B: s1, e1; T30 PRD                                                                                                      | PASS              |
| FR-30 | Document entirely in the constitution's language                                        | B: b-es e1 (Spanish headings)                                                                                           | PASS              |
| FR-31 | `deliverables/` not ignored → propose `.gitignore`; declined → write + remind once      | B: s1, n1b (created), n2b (declined); T30 (`.gitignore` has `deliverables/`, `git status` clean)                        | PASS              |
| FR-32 | `deliverables/` documented as excluded from deploy                                      | grep: `AGENTS-sdd-section.md`, `docs/ADOPTING.md`, `sdd-flow/SKILL.md`, `docs/artifacts.md`                             | PASS              |
| FR-46 | Schema is internal; FR-27–30 don't apply                                                | A: v-mig (full schema incl. internals); skill text                                                                      | PASS              |
| FR-33 | Templates for `app-flow`, `ux-brief`, `schema` in the skill                             | S: 7 template checks                                                                                                    | PASS              |
| FR-34 | `flow`/`ux` → hand-written notice                                                       | B: b-misc m1, m2                                                                                                        | PASS              |
| FR-35 | Flow stays at eight phases; docs cross-cutting                                          | grep `sdd-flow/SKILL.md`, `AGENTS-sdd-section.md`; README "9 slash commands" / 8 phases                                 | PASS              |
| FR-41 | Latest CHG date > validation date (or CHG with no date) → not closed                    | B: b-main (002 stale), b-acc a2; legacy 001 without date counted as closed (T30)                                        | PASS              |
| FR-36 | Templates inside the skill folder                                                       | S: template paths; install smoke (`sdd-documents/templates/prd.md`)                                                     | PASS              |
| FR-37 | `install.sh` installs command with `sdd-` prefix + skill folder                         | S: install smoke (claude and opencode targets), idempotent, `--force`                                                   | PASS              |
| FR-38 | `tests/validate.sh` covers command, skill, templates                                    | S: "Capa de documentos" (12), "Versión" (2), smoke additions; negative tests done in T23, T25                           | PASS              |
| FR-39 | Version `0.5.0` in every manifest and `CHANGELOG.md`                                    | S: "las 4 cadenas coinciden (0.5.0)", heading `[0.5.0]`                                                                 | PASS              |
| FR-40 | `validation.md` records the validation date                                             | A: v-mig; this file                                                                                                     | PASS              |
| FR-42 | Hand-written schema notes untouched                                                     | A: v-mig (`KEEP-ME` kept), v-disc                                                                                       | PASS              |
| FR-47 | Already Done → roadmap unchanged                                                        | A: v-done                                                                                                               | PASS              |
| FR-49 | Migrations vs models disagree → note + follow migrations                                | A: v-disc, v-mig                                                                                                        | PASS              |
| FR-51 | Roadmap sentence of principle 3 reworded; no "purely by hand" left                      | `docs/constitution.md:27`, `docs/roadmap.md:4`, `README.md:29`, `sdd-flow/SKILL.md:21` all say "by hand or by validate" | PASS              |

## FRs without verification

None uncovered. Partial coverage:

1. **FR-14 / FR-16 — `/sdd:docs schema` in interactive mode** was not run by
   hand; the schema procedure was exercised through `/sdd:validate`
   (automatic mode) only.
2. **FR-19 schema exemption from the `lite` gate** is stated in the skill
   but has no manual scenario.

## Completion criteria

- [x] All FRs verified (structural checks + documented manual scenarios,
      with the two partial gaps above).
- [x] `bash tests/validate.sh` and `claude plugin validate ./plugins/sdd --strict` pass.
- [x] PRD, TRD, and acceptance record generated end-to-end from this repo's
      own artifacts under `deliverables/` (ignored by git), with sources and
      date stated; schema verified on sample A, scope change log on sample B.
- [x] Install paths: plugin manifest (`claude plugin validate`), `install.sh`
      against a temporary home (claude and opencode targets). **Not
      exercised:** a real opencode session, a real Copilot CLI session (skill
      layout only checked structurally), a flat install in a real Claude Code.
- [x] `git diff --name-only` shows none of `NOTICE`, `spec-generator/SKILL.md`,
      `spec-template.md`, `templates/AGENTS.md`, `templates/constitution.md`.

## Known limits

- Regeneration is model-written and not byte-stable: in `b-es` the second
  run translated two titles and showed a diff instead of "up to date"
  (FR-50); in English it reached "up to date".
- Spec 001's `validation.md` has no `**Date:**`; the acceptance record for it
  used the date of the first pass (2026-08-27) and said so.
- The spec's `Status` still reads `proposed` (closeout task).

## Updated files

- `docs/roadmap.md` — feature moved to Done (appended as item 5; it was not
  listed).
- `docs/schema.md` — skipped: `schema: skipped, no schema source found` (this
  repo has no persistent data structures).

## Verdict

**Spec fulfilled.** Every FR passes; the two partial gaps and the unexercised
opencode/Copilot sessions are reported above and do not change the verdict.
