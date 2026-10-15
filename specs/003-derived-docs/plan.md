# Technical plan — Spec 003

Same shape as spec 002: everything lives under `plugins/sdd/` (constitution
principle 1), the only code is bash in `tests/validate.sh`, and "implementation"
means writing instructions an agent follows. All document logic stays in the
`sdd-documents` skill; the command only passes the request through.

## Module structure

- `plugins/sdd/skills/sdd-documents/SKILL.md` → the bulk of the change:
  - `description`, name table, and § 1 (routing): eight names; `flow`/`ux`
    are generated, not "by hand" (FR-1–4, 29).
  - § 3 (`lite` gate) and § 6 (client-facing rules): cover `delivery`
    (FR-16, 17).
  - § 4 (closed features): add `delivery` and `flow` to the "closed features
    only" list; `ux` reads the constitution plus closed features (FR-9, 10, 14).
  - § 5 (writing): step 4 gains the **reuse rule** and a **template check**
    (FR-27, 34); a short "internal documents" variant (no `.gitignore`, no
    client rules) shared by `schema`, `flow`, `ux` (FR-21).
  - New § 10 `flow` and `ux` (derivation tables, gaps, kept content, notes
    preservation) (FR-5–13, 23–25, 32).
  - New § 8 entry `delivery` (FR-14–20, 22).
- `plugins/sdd/skills/sdd-documents/templates/delivery.md` → new, MIT, written
  from scratch (FR-31).
- `plugins/sdd/skills/sdd-documents/templates/{app-flow,ux-brief}.md` →
  replace the "Written by hand" banner with the derived-view header, add
  `## Notes (hand-written)`, mark gap-able sections (FR-25).
- `plugins/sdd/commands/docs.md` → `description` and `argument-hint` list the
  eight names; still no rules of its own (FR-29).
- `plugins/sdd/skills/sdd-flow/templates/validation.md` → optional
  `## Known limits` section; `plugins/sdd/commands/validate.md` → writes it,
  restricted to product restrictions (FR-33).
- `plugins/sdd/skills/sdd-flow/SKILL.md`, `docs/artifacts.md`, `README.md`,
  `docs/roadmap.md`, `CHANGELOG.md` → drop the "hand-written / not generated"
  wording for `flow`/`ux`, add `delivery` (FR-29).
- `tests/validate.sh` → `delivery` in the template loop; new template-reference
  check (FR-28, 31).
- Three manifests (`plugins/sdd/.claude-plugin/plugin.json`,
  `plugins/sdd/plugin.json`, `.github/plugin/marketplace.json`) → `0.6.0`
  (FR-30).

Not touched: `NOTICE`, `spec-generator/*`, `AGENTS.md`/`constitution.md`
templates, `install.sh` (it copies the skill folder wholesale, so the new
template travels without edits — verified by the existing smoke test plus the
new loop entry).

## Data model

No storage. Text formats the modules read and write:

**Generated-document header**: unchanged from spec 002 (`Generated:` on its
own line, ignored when comparing). `flow`/`ux` use the same four lines, in
English like `schema`.

**Gap marker**: the literal `TODO: provide <what>` on its own line or list
item, where `<what>` is in the content language. The prefix `TODO: provide` is
a fixed token (like `Done when:`) so the skill, the diff, and humans can find
gaps with a plain search (constitution 2).

**Notes section**: `## Notes (hand-written)` heading at the end of
`app-flow.md` and `ux-brief.md`; everything from it to end of file is copied
verbatim on regeneration (same contract as `schema.md`).

**`delivery.md`** (fixed order, whole file in the content language):
title (project only, no date or version), header block, summary
(counts of delivered features and recorded changes), one chapter per closed
feature (goal; requirements as plain sentences with validated outcome;
known limits), scope changes, features not yet closed (one line each), and a
hand-off block (recipient, date, signature lines).

**`## Known limits`** in `validation.md`: optional bullets, each a product
restriction a client may read ("works only for X"), never a verification gap
("not tested on Y"). Absent heading = no limits recorded.

## Algorithms / non-trivial logic

**Request routing (skill § 1).** Name ∈ {prd, trd, acceptance, changes,
schema, flow, ux, delivery}. Command with missing/unknown name → list all
eight, stop (FR-3). Natural language not identifying exactly one → ask, write
nothing (FR-4).

**Per-name pipeline.**

| Name       | Profile gate | Needs closed feature   | Target                     | Write path |
| ---------- | ------------ | ---------------------- | -------------------------- | ---------- |
| `delivery` | yes (`lite`) | yes (else stop)        | `deliverables/delivery.md` | client     |
| `flow`     | no           | yes (else stop)        | `docs/app-flow.md`         | internal   |
| `ux`       | no           | no (constitution only) | `docs/ux-brief.md`         | internal   |

"Client" write path = skill § 5 as today (including `.gitignore`).
"Internal" = § 5 steps 1, 2, 4–7 without the `.gitignore` check, plus notes
preservation, like `schema` interactive.

**`flow` derivation.**

1. Closed features, roadmap order (§ 4). For each `spec.md`:
   - Actors ← "Users / actors" (deduplicated by name across features).
   - Journeys: one per user story `Un`. Steps ← the FRs whose text mentions
     the story's actor or its main verb/object (match on the story's words;
     case-insensitive). FRs matching no story go to a final "General
     journey" so none is lost. Each journey gets the template's step table
     (actor / action / result) and a text diagram block (`start → … → end`).
   - Alternative paths ← `IF … THEN` FRs; error and empty states ← edge
     cases (spec section) plus those same FRs when they describe a message or
     refusal.
   - Screens or views ← only if an FR or plan names one; otherwise a gap.
2. Anything the template asks for with no source → gap marker (FR-7).
3. Features lacking "User stories" → their journey section is one gap.
4. Proposal ends with the **gap list** (section + what is missing) (FR-13).

**`ux` derivation.** Sources: constitution, closed features' specs and plans.

- Language(s) ← the constitution's content-language declaration and any
  requirement naming a language.
- Accessibility ← requirements (any section) containing accessibility /
  usability / contrast / keyboard / screen reader terms (in any language the
  spec uses).
- Audience ← "Users / actors" entries, listed as named, with context left as
  a gap.
- Platforms ← plan or NFR statements naming a platform.
- Experience goals, tone, visual direction ← gap unless an artifact states
  them.

**Kept content (FR-32).** When the target exists: parse it by `##` section.
For each section, if the new draft is a gap and the existing section holds
text that is not a gap marker, keep the existing text in the proposal (shown
unchanged in the diff). If the draft has content, the draft wins and the diff
shows the replacement for approval. Sections absent from the old file are
added.

**`delivery` assembly.**

1. Closed features in roadmap order (§ 4); none → say so, stop (FR-19).
2. Per feature: goal (spec), requirements as plain sentences with outcome
   (as `acceptance` does, reusing § 8's rules), `## Known limits` bullets
   from `validation.md` or "No limits recorded." (FR-15).
3. Scope changes ← the `changes` derivation (§ 8) over the same features.
4. Non-closed features, one line each (FR-18).
5. Client rules (§ 6) applied; known-limit candidates that read as
   verification gaps are removed and listed in the **review list** (FR-16).
6. Hand-off block (FR-20).

**Stable regeneration (FR-26, 27).** The model cannot guarantee identical
prose, so the contract is made mechanical by anchoring on the file itself:

1. If the target exists, read it first and build an item map: item key
   (feature folder + FR number, CHG number, or section heading) → current
   text.
2. For every item whose source text is unchanged since the existing file was
   written, emit the existing text verbatim. How to know it is unchanged:
   the new draft is derived from the same source text; if the item's
   meaning is the same, reuse (do not rephrase). Only items whose source
   differs get new wording.
3. Order is fixed: features by § 4, items by FR/CHG number, sections by the
   template.
4. Compare ignoring only the `Generated:` line; equal → "up to date", write
   nothing.

Known residual risk: judging "same source" is still the model's call (see
Risks). The rule minimizes churn but is not a byte-level guarantee, and the
validation records the observed limit honestly.

**Template-reference check (`validate.sh`, FR-28).**

1. For each `plugins/sdd/skills/*/SKILL.md` and `plugins/sdd/commands/*.md`,
   strip HTML comments (same awk pattern as the `Docs profile` check).
2. Extract `([a-z0-9-]+/)?templates/[A-Za-z0-9._-]+\.md`. A `<` in a path
   ends the match, so `templates/<name>.md` placeholders never match.
3. Resolve: with a `<skill>/` prefix → `skills/<skill>/templates/<file>`;
   without → relative to the file's own skill folder; a command file with an
   unprefixed reference has no skill context and is reported as a failure
   (references must name their skill).
4. Missing file → `fail "<file>: references <path>, which does not exist"`.

**Template missing at runtime (FR-34).** § 5 step 0: before drafting, check
the document's template exists in the skill's `templates/`; if not, name it
and stop.

## Technical decisions

1. **Gaps instead of questions** (spec choice): derive what exists, mark the
   rest `TODO: provide …`. Alternative: interview the user for tone/audience.
   Discarded — it makes the command interactive and non-repeatable, and the
   method already has `spec` for interviews.
2. **Anchor regeneration on the existing file** (reuse wording for unchanged
   items). Alternative: add a per-item source hash to the header and compare.
   Discarded — needs hashing (a script or a model-computed hash is not
   reliable) and clutters the header; constitution 4 forbids extra tooling.
3. **`## Known limits` in `validation.md`** as the only source for delivery
   limits. Alternative: mine the `Notes` section. Discarded — notes mix
   caveats, debt, and test gaps, so client-readable limits cannot be told
   apart reliably.
4. **`delivery` is project-level** (spec choice), not per feature. Alternative:
   `delivery-NNN-<slug>.md`. Discarded — `acceptance` already covers one
   feature; the new document's value is the aggregate.
5. **Internal write path for `flow`/`ux`**, same as `schema`. Alternative:
   client-facing path with the `lite` gate. Discarded — they are team
   documents; gating them would make `lite` projects unable to draft them.
6. **Keep hand-written content that has no source** (FR-32). Alternative: always
   overwrite with gaps after approval. Discarded — 0.5.0 users have hand-written
   files and approval would silently destroy work.
7. **One reference regex with prefix support** for the template check.
   Alternative: hard-code the expected template list. Discarded — it is what
   `validate.sh` already does for `sdd-documents`; the new check guards the
   cases nobody remembered to list.
8. **No new files in `install.sh`**. It copies the skill folder wholesale.

## Interface contract

- `/sdd:docs <prd|trd|acceptance|changes|schema|flow|ux|delivery> [feature]`
  — `feature` is read only by `acceptance`; ignored elsewhere.
- Outputs: `deliverables/delivery.md`, `docs/app-flow.md`, `docs/ux-brief.md`.
- Messages (exact where tests may grep): `up to date`, `no closed feature`
  (stop, nothing written), `TODO: provide <what>` (gap marker),
  `schema: skipped, no schema source found` (unchanged).
- `validate.sh` check output: `ok  <skill-file>: templates referenced exist`
  / `fail <file>: references <path>, which does not exist`.
- `validation.md`: optional `## Known limits` heading.

## Verification strategy

The project has a bash suite (`tests/validate.sh`) for structure, not for
agent behavior. As in 002, behavior is verified by scenarios run by hand in
throwaway project dirs, evidence recorded in `validation.md`.

**Automated (`bash tests/validate.sh` + `claude plugin validate ./plugins/sdd
--strict`)**

- `delivery.md` template exists; `app-flow`/`ux-brief` templates keep a notes
  heading.
- Template-reference check passes on the repo, and **fails** on a fixture: a
  temp copy of the plugin with a SKILL.md pointing at a missing template
  (negative test, run inline in the verification, not committed as a
  fixture).
- Versions consistent at 0.6.0; CHANGELOG has `[0.6.0]`.
- Smoke install copies `templates/delivery.md` to both destinations.

**Manual scenarios** (throwaway dirs seeded with 2 closed features, 1 open,
a constitution in English and one in Spanish)

- A. `flow` and `ux` on a project with specs: journeys per story, gaps
  listed, nothing invented; no gate under `lite`.
- B. `ux` with no closed feature: constitution only.
- C. `flow` with no closed feature: "no closed feature", nothing written.
- D. Existing hand-written `app-flow.md`/`ux-brief.md` (0.5.0 style): kept
  content survives, notes survive, diff shown, no write without yes.
- E. `delivery` under `lite`: gate asks every time; declined → nothing
  written; confirmed → client write path with `.gitignore` proposal; no
  risks / reasons / open questions / `FR-` ids; review list present; known
  limits only from the heading; a verification-gap bullet is excluded and
  listed.
- F. Second run of `flow`, `ux`, `delivery` unchanged, in English and Spanish:
  "up to date" expected; observed result recorded either way (FR-26 is
  verified as "observed", limit documented if it fails).
- G. Natural-language request in Spanish without a name: asks which one.
- H. Missing template: delete `templates/delivery.md` in a temp copy → names
  it, stops.

Evidence: transcripts/outputs summarized in `validation.md` per FR. Not
covered by design: real Copilot CLI / opencode sessions (as in 002), noted as
a known limit again.

## Risks

1. **Regeneration still not byte-stable** (FR-26/27). Mitigation: reuse rule,
   fixed order, scenario F measures it. Accepted as residual: prose is model
   output; the limit is recorded honestly rather than claimed solved.
2. **Journey matching by words is fuzzy** (FR-6): an FR attached to the wrong
   story. Mitigation: unmatched go to a general journey, the proposal is
   reviewed before writing, and the artifacts prevail over the document.
   Accepted.
3. **Invented UX content** in `ux`/`flow` (FR-7, 11). Mitigation: gaps are
   mandatory when no source exists, and the gap list is part of the
   proposal. Accepted; scenario A checks it.
4. **Leaking internals into `delivery`** (FR-16). Mitigation: same § 6 rules
   and review list as the other client documents; limits restricted to the
   `## Known limits` heading. Residual: wording inside that heading is the
   user's/validate's responsibility; the review list shows it.
5. **`/sdd:validate` writes verification gaps under `Known limits`**
   (FR-33). Mitigation: explicit instruction + the skill drops them and lists
   them. Accepted.
6. **Reference check false positives** (FR-28), e.g. an example path in
   prose. Mitigation: skip comments and `<…>` placeholders; examples that
   would trip it must use placeholders. Fix is a doc edit, not code.
7. **Overwriting a user's hand-written file** (FR-23, 32). Mitigation: diff +
   explicit approval + kept content + notes preserved; the old file is
   recoverable from version control (reported when notes heading is absent).
8. **Scope growth**: 8 touchpoints in docs. Mitigation: tasks split by area;
   no behavior outside the spec.

## Which FR each part covers

| Part                                                              | FRs              |
| ----------------------------------------------------------------- | ---------------- |
| `SKILL.md` § 1 routing, `commands/docs.md`                        | FR-1–4, 29       |
| `SKILL.md` § 10 `flow`                                            | FR-5–9, 13       |
| `SKILL.md` § 10 `ux`                                              | FR-10–13         |
| `SKILL.md` `delivery` + § 3/§ 6 changes, `templates/delivery.md`  | FR-14–20, 22, 31 |
| `SKILL.md` § 5 internal path, kept content, notes                 | FR-21, 23–25, 32 |
| `SKILL.md` § 5 reuse rule                                         | FR-26, 27        |
| `SKILL.md` § 5 template check                                     | FR-34            |
| `templates/{app-flow,ux-brief}.md`                                | FR-25            |
| `templates/validation.md`, `commands/validate.md`                 | FR-33            |
| `tests/validate.sh`                                               | FR-28, 31        |
| `sdd-flow` skill, `artifacts.md`, `README.md`, roadmap, CHANGELOG | FR-29            |
| Manifests, CHANGELOG `[0.6.0]`                                    | FR-30            |
