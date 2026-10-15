# Tasks — Spec 003

Tasks under 30 min, ordered by dependency. Each one: its FRs, a checkbox, and
a verifiable "Done when:" line. Paths are under `plugins/sdd/` unless stated.
Skill = `skills/sdd-documents/`.

## Templates

- [x] T1. Create `skills/sdd-documents/templates/delivery.md`: derived-view
      header, summary, per-feature chapter (goal, requirements with outcome,
      known limits), scope changes, features not yet closed, and hand-off
      block (recipient, date, signature). (FR-20, 31)
      Done when: the file exists with the header block and a `## ` heading
      for each of those parts, and contains no `FR-` identifier.
- [x] T2. Edit `templates/app-flow.md` and `templates/ux-brief.md`: replace the
      "Written by hand" banner with the derived-view header and add a final
      `## Notes (hand-written)` section. (FR-25)
      Done when: `grep -c 'Written by hand'` is 0 and
      `grep -c '## Notes (hand-written)'` is 1 in both files.
- [x] T3. Add the optional `## Known limits` section to
      `skills/sdd-flow/templates/validation.md` and make `commands/validate.md`
      write it only with client-readable product restrictions, never
      verification gaps. (FR-33)
      Done when: both files mention `## Known limits`, and `validate.md`
      states the "restrictions, not verification gaps" rule.

## Skill: logic

- [x] T4. SKILL.md routing: update `description`, the name table, and § 1 to
      the eight names (`flow`/`ux` generated, not "by hand"), including the
      "list all eight" and "ask which one" rules. (FR-1, 2, 3, 4)
      Done when: `grep -c 'written by hand'` finds no hand-written notice for
      `flow`/`ux`, and § 1 names all eight and states the ask rule.
- [x] T5. SKILL.md § 3, § 4, and § 6: extend the `lite` gate and the
      client-facing rules to `delivery`, and add `delivery` and `flow` to the
      "closed features only" list (`ux` reads the constitution plus closed
      features). (FR-9, 10, 12, 16, 17)
      Done when: § 3 and § 6 name `delivery`, § 4 lists which names need a
      closed feature, and states that `flow` and `ux` have no gate.
- [x] T6. SKILL.md: add `delivery` — assembly from closed features in
      roadmap order, plain sentences with outcome, `## Known limits` only,
      verification gaps dropped to the review list, scope changes without
      Reason, non-closed features one line each, hand-off block, no-closed-feature
      stop, full client write path. (FR-14, 15, 16, 18, 19, 20, 22)
      Done when: the section cites `templates/delivery.md`, `deliverables/delivery.md`,
      the `## Known limits` source rule, and the stop condition.
- [x] T7. SKILL.md: add `flow` — derivation (actors, one journey per user
      story by shared actor/action wording, general journey for unmatched
      FRs, IF…THEN → alternative paths, edge cases → error states), gap marker
      `TODO: provide …`, no gate, closed-feature stop, gap list at the end of
      the proposal. (FR-5, 6, 7, 8, 9, 13)
      Done when: the section cites `templates/app-flow.md`,
      `docs/app-flow.md`, the general-journey rule, and the gap-list rule.
- [x] T8. SKILL.md: add `ux` — sources (constitution plus closed features),
      what is derived (language, accessibility/usability, platforms,
      audience), what is always a gap (experience goals, tone, visual
      direction), no gate, gap list. (FR-10, 11, 12, 13)
      Done when: the section cites `templates/ux-brief.md`,
      `docs/ux-brief.md`, and lists the three always-gap items.
- [x] T9. SKILL.md § 5: internal write path shared by `schema`, `flow`, `ux`
      (no `.gitignore` check), keep-existing-content rule for sections with no
      source, and notes preservation with the "no notes heading → empty
      section, report replacement" case. (FR-21, 23, 24, 32)
      Done when: § 5 has the internal variant and the three rules, each
      findable by `grep` on its key phrase.
- [x] T10. SKILL.md § 5: add the reuse-wording rule (existing text kept for
      unchanged sources, fixed ordering, only the `Generated:` line excluded
      from the comparison) and the missing-template stop. (FR-26, 27, 34)
      Done when: § 5 states the reuse rule and "names the missing template and
      generates nothing".
- [x] T11. Update `commands/docs.md`: `description` and `argument-hint` list
      the eight names; the command still carries no rules. (FR-29)
      Done when: `argument-hint` contains `flow|ux|delivery` and the body has
      no rule beyond "run the skill".

## Tests

- [x] T12. `tests/validate.sh`: add `delivery` to the template loop of the
      documents section and check that `app-flow.md` and `ux-brief.md` have the
      notes heading. (FR-25, 31)
      Done when: `bash tests/validate.sh` prints an `ok` line for
      `template delivery.md` and for each notes heading, and exits 0.
- [x] T13. `tests/validate.sh`: add the template-reference check (strip HTML
      comments, extract `([a-z0-9-]+/)?templates/<file>.md`, resolve against the
      skill folder, fail on missing or unprefixed command references).
      (FR-28)
      Done when: the script prints an `ok` line per file with references and
      exits 0 on the repo.
- [x] T14. Negative test of T13: in a temp copy of the plugin point a
      `SKILL.md` at a missing template and run the check.
      (FR-28)
      Done when: the run prints `references ... which does not exist` and exits
      non-zero; the temp copy is deleted afterwards.

## Docs and version

- [x] T15. Update `skills/sdd-flow/SKILL.md` and `docs/artifacts.md`: `flow`
      and `ux` are generated (internal, no gate), `delivery` added to the
      table with its path and kind. (FR-29)
      Done when: `grep -c 'written by hand'` is 0 for `flow`/`ux` in both files
      and both mention `deliverables/delivery.md`.
- [x] T16. Update `README.md`: command usage line with the eight names and
      the output paths. (FR-29)
      Done when: the README usage line contains `delivery` and `flow`.
- [x] T17. Bump the three manifests to `0.6.0` and add the `## [0.6.0]`
      section to `CHANGELOG.md` (flow/ux/delivery, Known limits, reuse rule,
      template-reference check). (FR-29, 30)
      Done when: `bash tests/validate.sh` reports the 4 version strings
      matching `0.6.0` and the CHANGELOG heading.
- [x] T18. Run the gate: `bash tests/validate.sh` and
      `claude plugin validate ./plugins/sdd --strict`. (FR-28, 30, 31)
      Done when: both exit 0 with no failures.

## Verification by scenario

- [x] T19. Throwaway project A (two closed features, one open, English and
      Spanish constitutions): scenarios A, B, C — `flow`, `ux`, `ux` with no
      closed feature, `flow` with none. (FR-5–13)
      Done when: each scenario has a result line in a scratch notes file and
      no content appears that is absent from the artifacts.
- [x] T20. Scenarios D and H — existing hand-written `app-flow.md` and
      `ux-brief.md` (kept content, notes, diff, no write without yes) and a
      missing template. (FR-21, 23, 24, 25, 32, 34)
      Done when: each scenario has a result line, and no file changed without
      a yes.
- [x] T21. Scenarios E and G — `delivery` under `lite` (gate every time,
      decline writes nothing, confirm writes, `.gitignore` proposal, no
      risks/Reasons/open questions/`FR-` ids, review list, limits only from
      the heading) and a Spanish request with no name. (FR-1–4, 14–20, 22)
      Done when: each scenario has a result line.
- [x] T22. Scenario F — repeat `flow`, `ux`, and `delivery` unchanged, in
      English and Spanish. (FR-26, 27)
      Done when: each run has a result line stating "up to date" or the
      observed diff; failures are copied as known limits.
- [x] T23. Generate `flow`, `ux`, and `delivery` for this repo from specs
      001–002 and check sources, date, precedence line, and gaps; the `docs/`
      files are not committed unless the user approves. (FR-5–20)
      Done when: the three files exist, `delivery.md` is not listed by
      `git status` (`deliverables/` ignored), and the checks above hold.

## Feature closeout

_Standalone checkboxes, outside the `Tn` numbering — not implemented via
`/sdd:implement`._

- [x] Verify all FRs (`/sdd:validate` → `specs/003-derived-docs/validation.md`).
- [x] Confirm `/sdd:validate` moved the feature to `Done ✅` in
      `docs/roadmap.md`, linking this folder.
- [x] Set the spec status to implemented and confirm the `0.6.0` entry in
      `CHANGELOG.md` is complete.
- [ ] Propose commits grouped by area through `git-commit` (skill,
      commands/templates, tests, docs/version); the user confirms each.
      _The `0.6.0` tag is created by the user after the commits, so it is not a
      checkbox here._
