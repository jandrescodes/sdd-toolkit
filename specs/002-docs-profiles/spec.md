# Spec 002 — Documentation profiles

**Status:** implemented

## Context and goal

The toolkit leaves a trace per phase (constitution, spec, plan, tasks,
validation) but nothing for what a team or a client needs on top of that:
a consolidated description of the project's stored data (each `plan.md` only
holds its own slice), and formal documents a client can read (PRD, TRD,
acceptance record, scope change log). Today those get written by hand and
drift from the specs. This feature adds a documentation layer by levels —
core, recommended, optional, and client-facing — where the formal documents
are **derived views** of the existing artifacts, never a second source of
truth. A single per-project setting (`Docs profile`) decides how much of it
applies, so practice projects stay light and client projects can produce
deliverables.

## Users / actors

- **Developer** running the SDD flow on a project (own, course, or client).
- **Client / stakeholder** who receives the formal documents and never
  reads specs or plans.
- **Toolkit maintainer** shipping the feature across Claude Code, opencode,
  and GitHub Copilot CLI.

## User stories

- U1: As a developer I want a single `Docs profile` setting so that light
  projects aren't burdened with formal documents.
- U2: As a developer I want `docs/schema.md` kept current when a feature
  closes so that the project's stored data is documented in one place.
- U3: As a developer I want `/sdd:validate` to actually move a closed
  feature to Done in the roadmap, as the documentation already promises.
- U4: As a developer I want every approved scope change recorded in a
  structured way so that a change log can be derived from it.
- U5: As a developer I want to generate PRD, TRD, acceptance record, and
  scope change log from my existing artifacts, after reviewing a proposal.
- U6: As a client I want documents in business language, without internal
  risks, queries, thresholds, or unresolved questions.
- U7: As a Copilot CLI user (skills only, no slash commands) I want the same
  document generation available by asking for it.

## Terms

- **Closed feature**: a feature whose `validation.md` verdict reads "Spec
  fulfilled" and whose validation is not outdated (FR-41).
- **Client-facing document**: PRD, TRD, acceptance record, and scope change
  log (everything written to `deliverables/`). The schema document is
  internal.

## Functional requirements (EARS acceptance criteria)

### Docs profile

- FR-1: THE SYSTEM shall support one per-project setting,
  `Docs profile: lite | formal`, declared in the SDD section of the project's
  `AGENTS.md`.
- FR-2: WHERE the `Docs profile` line is absent, or `AGENTS.md` or its SDD
  section does not exist, THE SYSTEM shall treat the profile as `lite`.
- FR-3: IF the `Docs profile` value is neither `lite` nor `formal`, or more
  than one uncommented `Docs profile` line exists, THEN THE SYSTEM shall
  report the problem in the command output and apply `lite`.

### Living schema document

- FR-4: WHEN `/sdd:validate` issues a "fulfilled" verdict and the project
  defines persistent data structures, THE SYSTEM shall update
  `docs/schema.md`, without asking for approval, so it reflects the data
  structures as defined by the applied migrations when present, otherwise by
  the project's declared models or schema definitions.
- FR-5: IF the verdict is not "fulfilled", THEN THE SYSTEM shall leave
  `docs/schema.md` unchanged.
- FR-6: IF no definition of persistent data structures is found, THEN THE
  SYSTEM shall skip the schema update, record "schema: skipped, no schema
  source found" in `validation.md`, and leave the verdict unchanged.
- FR-42: WHEN updating `docs/schema.md`, THE SYSTEM shall leave its
  hand-written notes section unchanged.
- FR-49: IF the project's migrations and its declared models or schema
  definitions disagree, THEN THE SYSTEM shall note the discrepancy in
  `validation.md` and follow the applied migrations.

### Roadmap update

- FR-7: WHEN `/sdd:validate` issues a "fulfilled" verdict, THE SYSTEM shall
  move the feature to Done in `docs/roadmap.md`, linking its folder, and add
  it there if it was not listed.
- FR-47: IF the feature is already listed as Done, THEN THE SYSTEM shall
  leave `docs/roadmap.md` unchanged.
- FR-8: IF the verdict is not "fulfilled", THEN THE SYSTEM shall leave
  `docs/roadmap.md` unchanged.
- FR-9: IF `docs/roadmap.md` does not exist, THEN THE SYSTEM shall skip the
  roadmap update and note it in `validation.md`.
- FR-10: WHEN `/sdd:validate` updates `docs/roadmap.md` or `docs/schema.md`,
  THE SYSTEM shall list each updated file in `validation.md`.
- FR-40: WHEN `/sdd:validate` writes `validation.md`, THE SYSTEM shall
  record the validation date in it.

### Scope change record

- FR-11: WHEN `/sdd:change` applies a spec change the user approved, THE
  SYSTEM shall append to the spec's `## Changes` section (creating it if
  missing) an entry titled `CHG-n — YYYY-MM-DD — <title>`, where the date is
  the approval date, with the fields Type (`add`, `modify`, or `remove`),
  FRs (every requirement added, modified, or removed), and Reason.
- FR-12: THE SYSTEM shall number `CHG-n` entries as one more than the highest
  existing number in the spec (starting at 1), and IF duplicate numbers
  already exist, THEN THE SYSTEM shall report them.
- FR-13: THE SYSTEM shall tolerate existing free-form "Later changes"
  sections without migrating or rewriting them.

### Document generation

- FR-14: THE SYSTEM shall generate each of these documents from existing
  artifacts on request: PRD, TRD, acceptance record, scope change log, and
  schema.
- FR-15: THE SYSTEM shall make that generation available through a skill
  that works when asked in natural language, without any slash command.
- FR-48: IF a natural-language request does not identify exactly one
  document, THEN THE SYSTEM shall ask which one and generate nothing yet.
- FR-16: WHEN the user runs `/sdd:docs <prd|trd|acceptance|changes|schema>`,
  THE SYSTEM shall run the generation for that document.
- FR-17: IF `/sdd:docs` receives a missing name, or a name other than the
  five valid ones and `flow`/`ux` (FR-34), THEN THE SYSTEM shall list the
  valid names and generate nothing.
- FR-18: WHEN a document is requested, THE SYSTEM shall present the proposed
  content and shall write the file only after explicit user approval.
- FR-19: WHILE the profile is `lite`, THE SYSTEM shall warn that formal
  documents are not enabled and ask for confirmation before proposing a
  client-facing document, on every request, without remembering earlier
  answers; this does not apply to the schema document.
- FR-20: IF the user declines the `lite` confirmation, THEN THE SYSTEM shall
  write nothing.
- FR-21: IF a source artifact required by the requested document is missing,
  THEN THE SYSTEM shall name the missing artifact and generate nothing.
- FR-22: IF `/sdd:docs` would overwrite an existing file, THEN THE SYSTEM
  shall show what changes against it, ignoring the generation-date line, and
  overwrite it only after explicit user approval.
- FR-50: IF only the generation-date line would change, THEN THE SYSTEM shall
  report the file as up to date and write nothing.
- FR-23: WHEN generating the PRD, TRD, or scope change log, THE SYSTEM shall
  include only closed features, ordered as in `docs/roadmap.md` or, if not
  listed there, by spec number.
- FR-24: WHEN a feature is excluded by FR-23, THE SYSTEM shall list it in
  one line as in progress (or as "re-validation required" under FR-41),
  without its requirements or design.
- FR-45: IF no closed feature exists, THEN THE SYSTEM shall say so and
  generate nothing.
- FR-43: WHEN the user runs `/sdd:docs acceptance`, THE SYSTEM shall generate
  one acceptance record for a single closed feature, the one given as
  argument or, if none, the most recently closed one.
- FR-44: IF the requested feature for the acceptance record is not closed,
  THEN THE SYSTEM shall state why (verdict or outdated validation) and
  generate nothing.

### Derived-view rules

- FR-25: THE SYSTEM shall state, in every generated document, the artifacts
  it was derived from, the generation date, and that the specs, plans, and
  constitution prevail on conflict.
- FR-26: THE SYSTEM shall write the client-facing documents to
  `deliverables/prd.md`, `deliverables/trd.md`, `deliverables/changes.md`,
  and `deliverables/acceptance-NNN-<slug>.md`, and the schema document to
  `docs/schema.md`.
- FR-27: WHEN generating a client-facing document, THE SYSTEM shall omit
  internal risks, verification strategy, open questions, and unresolved
  `[NEEDS CLARIFICATION]` items, and the scope change log shall omit each
  entry's Reason.
- FR-28: WHEN proposing a client-facing document, THE SYSTEM shall list, each
  with its location, the queries, numeric thresholds, internal identifiers,
  hostnames, and credentials found in the text it kept or removed, so the user
  can review them before approving; the omitted Reason fields are listed so
  the user can choose to include them.
- FR-29: WHEN generating the PRD, THE SYSTEM shall express each requirement
  as a plain sentence naming who benefits and what they get, without EARS
  keywords, `FR-` identifiers, or technical identifiers such as file names,
  table names, or commands.
- FR-30: THE SYSTEM shall write client-facing documents entirely, headings
  included, in the content language declared by the project's constitution,
  or the user's language if none is declared.
- FR-31: WHEN writing to `deliverables/` and the project's `.gitignore` does
  not cover it, THE SYSTEM shall propose adding it (creating `.gitignore` if
  missing) and wait for approval; if the user declines, THE SYSTEM shall still
  write the document and remind once that `deliverables/` is not ignored.
- FR-32: THE SYSTEM shall document `deliverables/` as excluded from deploy,
  alongside `docs/` and `specs/`, in the adoption guide and the SDD section
  template.
- FR-46: THE SYSTEM shall treat the schema document as internal: FR-27 to
  FR-30 do not apply to it.

### Manually maintained documents

- FR-33: THE SYSTEM shall provide, as part of the document-generation skill,
  templates for the optional documents `docs/app-flow.md` (diagrams) and
  `docs/ux-brief.md`, and for the recommended `docs/schema.md`.
- FR-34: IF the user requests a flow or UX document from `/sdd:docs`, THEN
  THE SYSTEM shall state that these are written by hand from the template and
  are not generated.

### Flow integrity

- FR-35: THE SYSTEM shall keep the SDD flow at eight phases, treating
  document generation as a cross-cutting action, not a phase.

### Staleness

- FR-41: IF a spec's latest `CHG-n` date is later than its `validation.md`
  date, or the spec has any `CHG-n` entry and `validation.md` records no
  date, THEN THE SYSTEM shall treat the feature as not closed.

### Distribution and quality

- FR-36: THE SYSTEM shall keep every template used by document generation
  inside the document-generation skill's own folder, so the skill works when
  installed alone on Claude Code (plugin), opencode (`install.sh`), and Copilot
  CLI (skills).
- FR-37: WHEN `install.sh` runs against a temporary home, THE SYSTEM shall
  install the new command with the existing `sdd-` prefix and the skill
  under its own folder, with the existing install checks still passing.
- FR-38: THE SYSTEM shall cover the new command, skill, and templates in
  `tests/validate.sh`.
- FR-39: THE SYSTEM shall publish version `0.5.0` consistently in every
  manifest that carries a version and in `CHANGELOG.md`.
- FR-51: THE SYSTEM shall reword the roadmap sentence of principle 3 in this
  repo's `docs/constitution.md` to say the roadmap is maintained by hand or
  by `/sdd:validate`, and shall update every other statement that the
  roadmap is purely by hand.

## Non-functional requirements

- Toolkit content (commands, skills, templates, docs) in English
  (constitution principle 2).
- Templates assume no storage technology (relational or otherwise), only
  blanks (constitution principle 2).
- No new runtime dependencies (constitution principle 4).
- New templates are original work under MIT; files under Apache-2.0 and
  `NOTICE` stay untouched.
- Backward compatible: a project that doesn't add the `Docs profile` line
  behaves as before apart from the corrected roadmap update.
- Portable across Claude Code, opencode, and Copilot CLI; where a tool lacks
  slash commands (Copilot), the skill alone must be sufficient.
- Constitution principle 3 governs the artifact each **phase** leaves.
  `docs/schema.md`, `docs/app-flow.md`, and `docs/ux-brief.md` are reference
  documents under `docs/` (not phase artifacts), and the client-facing
  documents are derived views whose traceable sources stay versioned; none is
  a phase artifact. The constitution's only change is the roadmap sentence
  (FR-51), because `/sdd:validate` now writes the roadmap.

## Edge cases

- Project without persistent data: no schema update, flow continues (FR-6).
- Feature closed before this change, with no `## Changes` section: the scope
  change log has nothing to derive from it and says so, instead of reading
  free-form legacy sections (FR-13).
- Feature whose `validation.md` verdict is "NOT fulfilled", missing, or
  outdated: excluded from client documents and listed in one line (FR-23,
  FR-24, FR-41).
- `Docs profile: Formal` (case variant; surrounding whitespace is ignored), or two active
  `Docs profile` lines: treated as invalid (FR-3).
- Schema document edited by hand and then refreshed: structures follow the
  project's migrations or definitions; the notes section is preserved (FR-42).
- Document generated twice in a row with no other changes: reported as up to
  date, nothing written (FR-50).
- No closed feature, or acceptance requested for one that isn't closed:
  nothing generated, reason stated (FR-44, FR-45).
- Parallel branches that both add `CHG-n` entries: duplicates are reported
  but not merged (FR-12).
- Natural-language request that doesn't name a single document (Copilot):
  asks which one (FR-48).
- Change approved and spec re-validated on the same day: dates have day
  granularity, so a change made after validation on that same day is not
  detected as stale (FR-41); known limit, accepted.
- Legacy `validation.md` without a date and a spec with no `CHG-n`: stays
  closed; with a `CHG-n`, it needs re-validation (FR-41).

## Out of scope

- Generating any document automatically, without the user's approval.
- Exporting to PDF or Word.
- Generating `app-flow`, `ux-brief`, or an implementation timeline
  (`delivery`) from artifacts — planned for 0.6.0; `app-flow.md` and
  `ux-brief.md` ship in 0.5.0 only as manual templates.
- Amending the constitution beyond the roadmap sentence (FR-51).
- Migrating existing "Later changes" entries to the `CHG-n` format.
- Making `/sdd:docs` a ninth phase.
- Syncing generated documents back into specs or plans.
- Resolving duplicate `CHG-n` numbers automatically.

## Completion criteria

- All FRs verified (automated checks where possible; documented manual
  checklist for the interactive behaviors).
- `bash tests/validate.sh` and `claude plugin validate ./plugins/sdd
--strict` pass.
- PRD, TRD, and acceptance record generated end-to-end from this repo's own
  artifacts, with sources and date stated; the schema document and the scope
  change log verified against temporary sample projects (one with persistent
  data, one with a `CHG-n` entry), not committed.
- Install paths checked: plugin manifest, `install.sh` against a temporary
  home, and the Copilot skill layout; anything not exercised is reported.

## Open questions

None open.

## Clarifications

Findings numbered as in the phase-3 review.

1. `AGENTS.md` or its SDD section missing → `lite` (FR-2).
2. Where an invalid profile is reported → in the command output (FR-3).
3. What counts as schema source → applied migrations first, otherwise
   declared models or schema definitions (FR-4); disagreements noted and
   migrations followed (FR-49).
4. Relational-only wording → neutral "persistent data structures" (FR-4,
   FR-6; NFR on storage technology).
5. Feature absent from the roadmap → added to Done; already Done → unchanged
   (FR-7, FR-47).
6. `Approved` field vs title date → the title date is the approval date; the
   separate field was dropped (FR-11).
7. Missing `## Changes` or next `n` → section created; `n` = highest + 1,
   starting at 1 (FR-11, FR-12).
8. Meaning of "client-facing" → PRD, TRD, acceptance, changes; schema is
   internal (Terms, FR-46).
9. Does the `lite` warning cover `schema`? → no (FR-19).
10. Meaning of "fulfilled" → `validation.md` verdict reads "Spec fulfilled"
    (Terms); no or NOT-fulfilled verdict is not closed.
11. Internal content in the TRD → omitted by section; sensitive details in
    kept text are listed for review (FR-27, FR-28).
12. "Doubted" not verifiable → replaced by a concrete list of queries,
    thresholds, identifiers, hostnames, credentials (FR-28).
13. "Business language" unmeasurable → plain sentence naming who benefits and
    what they get, no EARS/FR/technical identifiers (FR-29).
14. Language of headings → whole document in one language (FR-30).
15. Output paths and ordering → fixed paths; features ordered as in the
    roadmap, else by spec number (FR-26, FR-23).
16. "Works"/"prefix rules" not verifiable → templates inside the skill's
    folder; install checked against a temporary home (FR-36, FR-37). All new
    templates now live in the document-generation skill.
17. `/sdd:validate` bookkeeping vs approval → validate updates roadmap and
    schema without asking and lists them in `validation.md`; the approval and
    diff rule applies only to `/sdd:docs` (FR-4, FR-10, FR-22).
18. `flow`/`ux` vs unknown names → recognized separately, with the hand-written
    message (FR-17, FR-34).
19. `lite` confirmation vs schema in `lite` → schema excluded from it (FR-19).
20. "Partial" verdict does not exist → edge case rewritten to NOT fulfilled,
    missing, or outdated.
21. Acceptance of an unfulfilled feature → acceptance is per feature and only
    for closed ones (FR-43, FR-44); answers open question 1.
22. Diff never empty because of the date → date line ignored in the diff;
    only-date change means "up to date" (FR-22, FR-50).
23. Completion criteria infeasible on this repo → schema and changes verified
    on temporary sample projects.
24. Duplicate or commented `Docs profile` lines → commented ignored; several
    active lines invalid (FR-3).
25. Hand-written schema notes → preserved (FR-42).
26. Several data sources → covered by 3 (FR-49).
27. Spec changed after validation → feature not closed until re-validated
    (FR-40, FR-41).
28. No closed features → nothing generated, says so (FR-45).
29. Parallel `CHG-n` duplicates → reported only (FR-12; Out of scope).
30. `/sdd:change` not approved or several FRs → only approved changes recorded;
    `FRs` lists every FR touched (FR-11).
31. Sensitive data in TRD sources → listed in the review list (FR-28).
32. `.gitignore` missing, covering, or declined → create/propose; if declined,
    write and remind once (FR-31).
33. Ambiguous Copilot request → asks which document (FR-48).
34. Constitution principle 3 → the new documents are reference documents or
    derived views, not phase artifacts (NFR). Principles 2 and 5 addressed by
    4, 12, 13, and 16.

Review after clarification:

35. Principle 3 says the roadmap is "maintained by hand", which FR-7
    contradicts → reword that one sentence (FR-51); supersedes the earlier
    "no amendment" decision for that sentence only.
36. Legacy `validation.md` has no date (spec 001's has none) → closed unless
    the spec has a `CHG-n` (FR-41).
37. Same-day change after validation is undetectable → accepted limit
    (Edge cases).

Open questions from the draft: acceptance per feature (21); Reason excluded
from the scope change log and offered in the review list (FR-27, FR-28); the
`lite` warning repeats on every request, no session memory (FR-19).
