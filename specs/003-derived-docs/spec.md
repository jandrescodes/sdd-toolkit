# Spec 003 — Derived app-flow, UX brief, and delivery documents

**Status:** implemented

## Context and goal

In 0.5.0 `/sdd:docs` generates PRD, TRD, acceptance record, scope change log,
and schema. `app-flow` and `ux-brief` are only templates written by hand, and
there is no document that packages what a client receives at the end of a
release. This feature (0.6.0) makes `/sdd:docs` derive all three from the
existing artifacts: `flow` and `ux` into `docs/` (internal, no gate) and a new
`delivery` into `deliverables/` (client-facing, `lite` gate). Whatever the
artifacts do not contain is marked as a gap, never invented. It also pays two
backlog items that protect this feature: a `validate.sh` check that every
template referenced by a skill exists, and byte-stable regeneration.

## Users / actors

- **Developer** running the SDD flow who wants journeys, a UX brief, and a
  delivery package without writing them from scratch.
- **Client / stakeholder** who receives the delivery package.
- **Toolkit maintainer** shipping across Claude Code, opencode, and Copilot CLI.

## User stories

- U1: As a developer I want `/sdd:docs flow` to draft `docs/app-flow.md` from
  my specs so that actors and journeys are not written twice.
- U2: As a developer I want `/sdd:docs ux` to draft `docs/ux-brief.md` from
  what the artifacts already say and a visible list of what is missing.
- U3: As a developer I want `/sdd:docs delivery` to produce one release-level
  package for the client from the closed features.
- U4: As a developer I want regenerating an unchanged document to report "up
  to date" in any language.
- U5: As a maintainer I want `validate.sh` to fail when a skill references a
  template that does not exist.

## Terms

- **Closed feature**, **client-facing document**: as in spec 002.
- **Gap**: a template section whose content is not present in any artifact.
  It is written as `TODO: provide <what>` and listed in the proposal.

## Functional requirements (EARS acceptance criteria)

### Names and routing

- FR-1: THE SYSTEM shall accept `flow`, `ux`, and `delivery` as valid
  `/sdd:docs` names, alongside the five existing ones.
- FR-2: WHEN the request is `flow` or `ux`, THE SYSTEM shall generate the
  document instead of telling the user to write it by hand.
- FR-3: IF the name is missing or unknown, THEN THE SYSTEM shall list all
  eight valid names and generate nothing.
- FR-4: WHEN a natural-language request does not identify exactly one of the
  eight names, THE SYSTEM shall ask which one and generate nothing yet.

### `flow` — `docs/app-flow.md`

- FR-5: WHEN `flow` is requested, THE SYSTEM shall fill
  `templates/app-flow.md` from the `spec.md` of every closed feature (actors,
  user stories, functional requirements, edge cases).
- FR-6: THE SYSTEM shall derive actors from "Users / actors", one journey
  per user story (its steps taken from the FRs whose wording shares the
  story's actor and action; an FR that matches no story goes to a general
  journey), and alternative paths and error/empty states from IF…THEN FRs
  and edge cases.
- FR-7: IF a template section has no source (e.g. screens or views), THEN THE
  SYSTEM shall write a `TODO: provide …` gap instead of inventing content.
- FR-8: THE SYSTEM shall not apply the `lite` gate to `flow`.
- FR-9: IF no feature is closed, THEN THE SYSTEM shall say so and generate
  nothing.

### `ux` — `docs/ux-brief.md`

- FR-10: WHEN `ux` is requested, THE SYSTEM shall fill `templates/ux-brief.md`
  using only the constitution and the specs and plans of closed features
  (language(s), requirements that mention accessibility or usability,
  platforms, and the audience named in "Users / actors"). With no closed
  feature, it shall use the constitution alone.
- FR-11: THE SYSTEM shall write audience context, experience goals, tone, and
  visual direction as `TODO: provide …` gaps when no artifact states them.
- FR-12: THE SYSTEM shall not apply the `lite` gate to `ux`, and shall not
  require a closed feature.
- FR-13: WHEN a proposal for `flow` or `ux` is shown, THE SYSTEM shall end it
  with the list of gaps, so the user knows what to complete by hand.

### `delivery` — `deliverables/delivery.md`

- FR-14: WHEN `delivery` is requested, THE SYSTEM shall produce a single
  project-level document covering all closed features, in roadmap order.
- FR-15: THE SYSTEM shall compose it from each closed feature's goal and
  plain-sentence requirements with their validated outcome, the scope changes
  (type, date, title, FR references, no Reason), and a "Known limits" section
  taken only from the `## Known limits` heading of each `validation.md`,
  written in plain language. A feature without that heading gets one line
  saying no limits are recorded.
- FR-16: THE SYSTEM shall apply the client-facing rules of spec 002 to
  `delivery`: no risks, verification strategy, open questions, or change
  Reasons; plain sentences without EARS or `FR-` identifiers; and a "Review
  before approving" list. Known limits that describe untested situations
  (verification gaps) rather than product restrictions shall be left out and
  listed in the review list.
- FR-17: WHILE the profile is `lite`, THE SYSTEM shall apply the `lite` gate
  to `delivery`, asking for confirmation on every request.
- FR-18: THE SYSTEM shall list non-closed features in one line each.
- FR-19: IF no feature is closed, THEN THE SYSTEM shall say so and generate
  nothing.
- FR-20: THE SYSTEM shall include blank hand-off lines (recipient, date,
  signature) in `delivery`.

### Writing and existing files

- FR-21: THE SYSTEM shall write `flow` and `ux` through the write path of the
  schema document: header, diff against an existing file, explicit approval,
  and no `.gitignore` check.
- FR-22: THE SYSTEM shall write `delivery` through the full client-facing
  write path (header, up-to-date check, diff, approval, `.gitignore` check).
- FR-23: WHEN `docs/app-flow.md` or `docs/ux-brief.md` already exists, THE
  SYSTEM shall show the diff, overwrite only after approval, and keep
  everything from its `## Notes (hand-written)` heading onward unchanged.
- FR-24: IF the existing file has no notes heading, THEN THE SYSTEM shall
  write an empty notes section and report that the previous content was
  replaced.
- FR-32: WHEN a section of an existing `flow` or `ux` file holds content
  other than a `TODO: provide …` gap and the artifacts give no source for it,
  THE SYSTEM shall keep that content instead of replacing it with a gap.
- FR-25: THE SYSTEM shall give the templates for `flow` and `ux` a `## Notes
(hand-written)` section and update their "written by hand" banner to the
  derived-view header.

### Stable regeneration

- FR-26: WHEN a document is regenerated and its sources are unchanged, THE
  SYSTEM shall report it as up to date in any content language.
- FR-27: WHEN a generated file already exists, THE SYSTEM shall reuse its
  exact wording for every item whose source text did not change, and write
  new wording only for items whose source changed. Item order shall follow
  the sources (feature order of section 4, then FR number), and the
  generation-date line is the only line excluded from the comparison.

### Plumbing and docs

- FR-28: THE SYSTEM shall make `tests/validate.sh` fail when any
  `templates/<file>` path referenced by a `SKILL.md` or a command file does
  not exist, resolved against the referencing skill's folder (or the folder
  of the skill the file names). Paths with placeholders (`<…>`) and text
  inside HTML comments are skipped.
- FR-29: THE SYSTEM shall update the `/sdd:docs` command, the
  `sdd-documents` skill (description, name table, sections 1, 3, 4, and 6),
  the `sdd-flow` skill, `docs/artifacts.md`, `README.md`, the roadmap, and
  `CHANGELOG.md` so `flow`, `ux`, and `delivery` are no longer described as
  hand-written or missing, and the `lite` gate and client-facing rules cover
  `delivery`.
- FR-30: THE SYSTEM shall bump the version to 0.6.0 in `plugin.json` and the
  manifests, with its CHANGELOG section.
- FR-31: THE SYSTEM shall deliver the templates, including a new
  `templates/delivery.md`, inside the `sdd-documents` skill so the feature
  works on Copilot CLI, opencode, and flat installs.
- FR-33: THE SYSTEM shall add an optional `## Known limits` section to the
  validation template, and `/sdd:validate` shall write it only with product
  restrictions a client may read, never verification gaps.
- FR-34: IF a template the requested document needs is missing, THEN THE
  SYSTEM shall name it and generate nothing.

## Non-functional requirements

- No new runtime dependencies (constitution 4); `bash` only for the check.
- Toolkit text in English; generated content in the project's content
  language (constitution 2). `flow` and `ux` keep the template's English
  headings, the notes heading, and the literal `TODO: provide` marker (fixed
  tokens, like `Done when:`), with the body in the content language.
  `delivery` is written entirely in the content language like the other
  client-facing documents. `delivery` has no version field: it is titled by
  project (the date lives in the header line).
- Documents remain derived views: artifacts prevail on disagreement.

## Edge cases

- A closed feature with no user stories: its journey section is a gap.
- A project with no `docs/constitution.md`: `ux` writes language and
  accessibility as gaps and the content language follows the user's.
- `delivery` when a feature is "re-validation required": listed as non-closed.
- `flow` or `ux` existing as a hand-written file from 0.5.0 users.
- A template referenced in prose but intentionally absent (e.g. an example
  path in a code fence): the check must only count real references.

## Out of scope

- Generating diagrams (the journeys are text and tables inside the template
  blocks).
- Asking the user about tone, audience, or visuals (gaps only, no interview).
- A per-feature delivery document.
- Cursor / other agents and automated semantic versioning (stay in backlog).
- Changing the Docs profile semantics.

## Completion criteria

- All FRs verified; `bash tests/validate.sh` and `claude plugin validate
./plugins/sdd --strict` pass.
- Manual run of `flow`, `ux`, and `delivery` over this repo (specs 001–002),
  and a second run of each reporting "up to date".
- `validation.md` written; roadmap moved to Done; 0.6.0 tagged.

## Clarifications

- Q: How does "up to date" stay stable when the model rephrases prose? →
  Reuse the existing file's wording for unchanged sources; rewrite only
  changed items; fixed ordering. Touches FR-26, FR-27.
- Q: Where does "Known limits" come from? → A new optional `## Known limits`
  heading in `validation.md`, limited to client-readable product
  restrictions. Touches FR-15, new FR-33.
- Contradiction: "Known limits" vs the rule that client documents omit risks
  and verification strategy → verification gaps are excluded and shown in the
  review list. Touches FR-15, FR-16.
- Ambiguity: which FRs form a journey → shared actor and action wording, rest
  in a general journey. Touches FR-6.
- Ambiguity: which artifacts feed `ux` → constitution plus closed features.
  Touches FR-10.
- Edge case: a gap overwriting hand-written content of a 0.5.0 file → content
  without source is kept. New FR-32.
- Edge case: missing template, and what counts as a "referenced" template →
  FR-34 and a precise rule in FR-28.
- Constitution 2 vs the English `TODO: provide` marker in non-English
  projects → treated as a fixed token; body stays in the content language.
  Non-functional requirements.
- Gap: `delivery` has no template or version → new `templates/delivery.md`
  (FR-31), no version field. Touches FR-31, non-functional requirements.
- Gap: skill sections 1, 3, 4, 6 and the five-name list still described the
  old behavior → FR-3 now says eight names; FR-29 lists the sections.
