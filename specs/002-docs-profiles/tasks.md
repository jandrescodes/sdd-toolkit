# Tasks — Spec 002

Tasks under 30 min, ordered by dependency. Each one: its FRs, a checkbox, and
a verifiable "Done when:" line. Paths are under `plugins/sdd/` unless stated.
Skill = `skills/sdd-documents/`.

## Skill: logic

- [x] T1. Create `skills/sdd-documents/SKILL.md`: frontmatter (`name:
    sdd-documents`, natural-language trigger description) and the request
      entry flow — resolve the document name, list valid names, `flow`/`ux`
      hand-written notice, ask when the request names no single document.
      (FR-15, 17, 34, 48)
      Done when: `grep -c` finds the five valid names, the `flow`/`ux`
      notice, and the "ask which one" rule in the file; `name` equals the
      folder name.
- [x] T2. SKILL.md: profile resolution (`lite`/`formal`, absent file or line →
      `lite`, invalid or duplicated active line → warn and `lite`, commented
      lines ignored, value trimmed and case-sensitive) and the `lite` gate
      (warn + confirm on every request, decline writes nothing, schema
      exempt). (FR-1, 2, 3, 19, 20)
      Done when: the file has a numbered profile step covering absent,
      invalid, duplicated, and commented cases, and a gate step stating
      "every request" and "schema excluded".
- [x] T3. SKILL.md: closed-feature test (verdict line, `**Date:**`, staleness
      rule), feature ordering (roadmap first occurrence, then `NNN`), one-line
      listing of non-closed features, "no closed feature" stop, and the
      missing-source stop. (FR-21, 23, 24, 41, 45)
      Done when: the file defines the three states (closed, in progress,
      re-validation required) and each stop condition by name.
- [x] T4. SKILL.md: common write path — proposal, explicit approval, diff that
      ignores the `Generated:` line, "up to date" shortcut, generated-document
      header, fixed output paths, single-language rule, `.gitignore` handling
      (propose, create if missing, declined → write and remind once).
      (FR-18, 22, 25, 26, 30, 31, 50)
      Done when: the header block, the five output paths, and the declined
      `.gitignore` branch all appear in the file.
- [x] T5. SKILL.md: client-facing rules — omitted sections, plain-sentence
      requirement rewrite, review list (queries, thresholds, identifiers,
      hostnames, credentials, omitted Reasons) labelled as a review aid; schema
      declared internal. (FR-27, 28, 29, 46)
      Done when: the file lists each omitted section and each review-list
      category, and states that FR-27–30 rules do not apply to the schema.
- [x] T6. SKILL.md: per-document derivation for `prd` and `trd` (sources,
      sections kept, sections omitted). (FR-14, 23, 27)
      Done when: each document has a "sources → sections" entry and the TRD
      entry names Risks and Verification strategy as omitted.
- [x] T7. SKILL.md: per-document derivation for `acceptance [feature]`
      (argument or latest closed, refusal reasons) and `changes` (CHG entries
      only, Reason omitted, no `## Changes` → say so, legacy sections
      ignored). (FR-13, 14, 43, 44)
      Done when: both entries exist, with the "not closed → state why" and
      "no `## Changes`" branches written.
- [x] T8. SKILL.md: schema procedure — source priority (migrations, then
      models), discrepancy note, skip message, preserved
      `## Notes (hand-written)` section, interactive vs automatic mode.
      (FR-4, 5, 6, 14, 42, 49)
      Done when: the file contains the exact skip message `schema: skipped, no
    schema source found` and both modes are described.

## Skill: templates (original MIT work, English, storage-neutral)

- [x] T9. Write `templates/prd.md` and `templates/trd.md` with the shared
      header block and blanks only. (FR-25, 36)
      Done when: both files exist, contain the header block, and contain no
      technology-specific example.
- [x] T10. Write `templates/acceptance.md` (with sign-off lines) and
      `templates/changes.md`. (FR-25, 36)
      Done when: both files exist with the header block; acceptance has blank
      sign-off lines.
- [x] T11. Write `templates/schema.md`: header, one block per structure
      (fields, constraints, keys, relationships) in neutral wording, final
      `## Notes (hand-written)` section. (FR-33, 36, 42)
      Done when: the file exists, ends with that heading, and `grep -i` finds
      no table/column/SQL-only wording.
- [x] T12. Write `templates/app-flow.md` (diagram blanks) and
      `templates/ux-brief.md`, marked as hand-written. (FR-33, 36)
      Done when: both files exist and say they are written by hand.

## Commands

- [x] T13. Write `commands/docs.md`: frontmatter (`description`,
      `argument-hint: <prd|trd|acceptance|changes|schema> [feature]`,
      `allowed-tools`), body that forwards `$ARGUMENTS` to the skill and holds
      no rules. (FR-16, 17)
      Done when: the file has a `description`, mentions the skill by name, and
      is under 25 lines.
- [x] T14. `commands/validate.md`: add `Edit` to `allowed-tools`; add the
      roadmap step (Done unchanged / Next → Done / absent → append; missing
      file and missing `## Done` → skip and note; not fulfilled → untouched).
      (FR-7, 8, 9, 47)
      Done when: frontmatter lists `Edit` and the step covers the five cases.
- [x] T15. `commands/validate.md` and `sdd-flow/templates/validation.md`:
      schema step via the skill's procedure (fulfilled only), `**Date:**` line,
      `## Updated files` block. (FR-4, 5, 10, 40)
      Done when: both files carry the date line and the updated-files block,
      and `validate.md` calls the skill for the schema step.
- [x] T16. `commands/change.md`: after the diff is approved, append the
      `### CHG-n — YYYY-MM-DD — <title>` entry (Type, FRs, Reason) under
      `## Changes`; numbering rule; report duplicates; plain-language title;
      nothing recorded if not approved. (FR-11, 12, 13)
      Done when: the file contains the entry format and the three rules.

## Templates and wording elsewhere

- [x] T17. `sdd-flow/templates/AGENTS-sdd-section.md`: one active `Docs
    profile: lite` line with its explanation inside an HTML comment,
      `deliverables/` in the deploy exclusion, `/sdd:docs` as a cross-cutting
      command next to the eight phases. (FR-1, 32, 35)
      Done when: `grep -c '^.*Docs profile:'` on non-comment lines returns 1
      and the deploy rule names `deliverables/`.
- [x] T18. `sdd-flow/templates/tasks.md` closeout (validate also moves the
      feature to Done) and `sdd-flow/templates/roadmap.md` (no longer "by
      hand" only). (FR-7, 51)
      Done when: both files show the new wording.
- [x] T19. Roadmap wording: `docs/constitution.md` principle 3 ("by hand or by
      `/sdd:validate`"), `docs/roadmap.md:4`, `README.md:28`,
      `sdd-flow/SKILL.md:21`. (FR-51)
      Done when: `grep -rn "by hand" docs README.md plugins | grep -i roadmap`
      returns nothing that says roadmap is purely by hand.
- [x] T20. `sdd-flow/SKILL.md`: introduce `sdd-documents`, the profile,
      `deliverables/` in the deploy exclusion (step 6 and golden rule), and
      the 8 → 9 command count (lines 3, 12, 81) while phases stay 8.
      (FR-32, 35)
      Done when: the file mentions all four and no longer says "8 commands".
- [x] T21. `docs/artifacts.md`: rows for `schema.md`, `app-flow.md`,
      `ux-brief.md`, and `deliverables/*`; the profile; line 56 count. (FR-32,
      33, 35)
      Done when: every new path appears in the table and the count reads 9.
- [x] T22. `README.md` (lines 23, 143 and a short section) and
      `docs/ADOPTING.md` (line 83, exclusions): command, profile,
      `deliverables/`. (FR-32, 35)
      Done when: both files mention `/sdd:docs` and `deliverables/` and no
      "8 commands".

## Quality gate

- [x] T23. `tests/validate.sh`: structural checks — `sdd-documents` skill and
      its seven templates exist, `commands/docs.md` has a description,
      `validate.md` lists `Edit`, `change.md` mentions `## Changes`, the
      section template has exactly one active profile line. (FR-1, 3, 33, 36, 38)
      Done when: the script passes, and fails when one template is
      temporarily renamed (restored afterwards).
- [x] T24. `tests/validate.sh`: install smoke additions —
      `skills/sdd-documents/templates/prd.md` and `commands/sdd-docs.md` exist
      after install; idempotency and `--force` still pass. (FR-37, 38)
      Done when: the smoke section prints both new checks green.
- [x] T25. `tests/validate.sh`: version consistency — the four manifest
      strings are equal and `CHANGELOG.md` has a matching heading. (FR-38, 39)
      Done when: the check passes on 0.4.0 and fails when one manifest is
      temporarily edited (restored afterwards).
- [x] T26. Bump to `0.5.0` in `plugins/sdd/.claude-plugin/plugin.json`,
      `plugins/sdd/plugin.json`, both entries of
      `.github/plugin/marketplace.json`; add the `0.5.0` section and link to
      `CHANGELOG.md`. (FR-39)
      Done when: `bash tests/validate.sh` passes with the version check.
- [x] T27. Run both gates: `bash tests/validate.sh` and `claude plugin
    validate ./plugins/sdd --strict`; confirm with `git diff --name-only`
      that none of `NOTICE`, `spec-generator/SKILL.md`, `spec-template.md`,
      `templates/AGENTS.md`, `templates/constitution.md` changed. (FR-37, 38)
      Done when: both gates exit 0 and the diff list excludes those files.

## Manual verification (sample projects live in the scratchpad; not committed)

- [x] T28. Sample project A (migrations, models-only, none): profile cases,
      `validate` roadmap and schema behavior, notes preserved, discrepancy
      note, `change` approved and declined, `CHG-n` numbering and duplicates.
      Record evidence per scenario. (FR-1–13, 40, 42, 47, 49)
      Done when: each scenario in the plan's manual list for this group has a
      result line.
- [x] T29. Sample project B: `prd`, `trd`, `acceptance`, `changes` in `lite`
      and `formal`; stale feature excluded; repeat run reports up to date;
      existing file shows a diff; `deliverables/` with and without
      `.gitignore`; natural-language request without a name; `flow`/`ux`;
      unknown name. (FR-14–34, 41, 43–46, 48, 50)
      Done when: each scenario in the plan's manual list for this group has a
      result line.
- [x] T30. Generate PRD, TRD, and an acceptance record from this repo's own
      artifacts and check that sources, date, and the precedence line are
      stated and internal sections are absent. `deliverables/` is added to this
      repo's `.gitignore` through the FR-31 flow. (FR-25–31)
      Done when: the three files exist under `deliverables/`, `git status`
      does not list them, and the checks above hold.

## Feature closeout

_Standalone checkboxes, outside the `Tn` numbering — not implemented via
`/sdd:implement`._

- [x] Verify all FRs (`/sdd:validate` → `specs/002-docs-profiles/validation.md`).
- [x] Confirm `/sdd:validate` moved the feature to `Done ✅` in
      `docs/roadmap.md` (first real use of the new step).
- [x] Set the spec status to implemented and add the `0.5.0` entry to
      `CHANGELOG.md` if T26 left it incomplete.
- [x] Propose commits grouped by area through `git-commit` (skill, commands,
      templates/docs, tests, version/changelog); the user confirms each.
_Tags `0.4.0` (on `4036167`) and `0.5.0` are created by the user after the
commits, so they are not a checkbox here._
