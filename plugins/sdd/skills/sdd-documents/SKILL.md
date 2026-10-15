---
name: sdd-documents
description: Use this skill when the user wants a project document built from the SDD artifacts — in any language they ask in ("generate the PRD", "write the technical doc", "acceptance record for this feature", "change log for the client", "update the schema doc", "genera el PRD", "acta de aceptación", "documento de cambios", "paquete de entrega", "documento de entrega", "flujo de la app", "diagrama de flujo", "brief de UX"). Derives PRD, TRD, acceptance record, scope change log, delivery package, schema, app flow, and UX brief from the existing specs, plans, and validations, after the user approves a proposal. Whatever the artifacts do not state is left as a marked gap, never invented.
---

# SDD documents

A documentation layer on top of the SDD artifacts. The documents it produces
are **derived views** of the constitution, specs, plans, and validations —
never a second source of truth. If a document and those artifacts disagree,
the artifacts prevail.

It is a cross-cutting action, **not a ninth phase** of the flow. Apart from
the schema refresh that `/sdd:validate` runs on its own (section 9), it never
writes anything the user hasn't approved.

| Name         | File                                    | Kind                   |
| ------------ | --------------------------------------- | ---------------------- |
| `prd`        | `deliverables/prd.md`                   | client-facing, derived |
| `trd`        | `deliverables/trd.md`                   | client-facing, derived |
| `acceptance` | `deliverables/acceptance-NNN-<slug>.md` | client-facing, derived |
| `changes`    | `deliverables/changes.md`               | client-facing, derived |
| `schema`     | `docs/schema.md`                        | internal, derived      |
| `delivery`   | `deliverables/delivery.md`              | client-facing, derived |
| `flow`       | `docs/app-flow.md`                      | internal, derived      |
| `ux`         | `docs/ux-brief.md`                      | internal, derived      |

Templates live in this skill's `templates/` folder. Depending on how the
toolkit is installed, it is at:

- Plugin: inside the `sdd` plugin (Claude Code resolves it on its own).
- Script (`install.sh`): `~/.claude/skills/sdd-documents/templates/` and/or
  `~/.config/opencode/skills/sdd-documents/templates/`.
- Copilot CLI: wherever the skill was installed.

## 1. Which document?

The request arrives either as an argument of `/sdd:docs <name> [feature]` or
as plain language in any language. Work out the name first:

1. If it is one of `prd`, `trd`, `acceptance`, `changes`, `delivery`,
   `schema`, `flow`, or `ux`, go on.
2. If the request came from the command and the name is missing or is
   anything else, list the eight valid names and stop. Generate nothing.
3. If the request came in natural language, choose the name when exactly one
   is the clear closest match (for example "documento de entrega" is
   `delivery`, "acta de aceptación" is `acceptance`). If two or more fit, or
   none does, **ask which one** and generate nothing yet.
4. **Check the template** (section 5, "Before drafting") now, before the gate
   of section 3 asks anything: if it is missing, name it and stop.

Only `acceptance` reads a second argument: the feature, given as a spec
number or a folder slug.

## 2. Docs profile

The project's `AGENTS.md`, in its SDD section, may carry one line:
`Docs profile: lite` or `Docs profile: formal` (optionally as a list item).
Resolve it before anything is proposed:

1. Ignore lines inside HTML comments or code fences — they are commented.
2. If `AGENTS.md` doesn't exist, has no SDD section, or has no active `Docs
profile` line, the profile is `lite`. Say nothing about it.
3. Take the value after the colon, trim the surrounding whitespace, and
   compare it **case-sensitively** with `lite` and `formal`.
4. If the value is anything else (`Formal`, `full`, empty), or more than one
   active `Docs profile` line exists, tell the user what was wrong in the
   command output and apply `lite`.

## 3. The `lite` gate

Applies to the client-facing documents (`prd`, `trd`, `acceptance`,
`changes`, `delivery`) while the profile is `lite`. It does not apply to the
internal documents (`schema`, `flow`, `ux`).

1. Warn that formal documents are not enabled for this project, and ask for
   confirmation before proposing anything.
2. Ask **on every request**. Don't remember an earlier answer, not even
   within the same conversation.
3. If the user declines, write nothing and stop.
4. If the user confirms, continue exactly as for `formal`.

## 4. Closed features

`prd`, `trd`, `changes`, `delivery`, and `flow` cover **closed features
only**; `acceptance` covers one closed feature. `ux` reads the constitution
plus the closed features, and works from the constitution alone when none is
closed. `schema` doesn't depend on this section. For each
folder `specs/NNN-<slug>/`, decide its state:

1. **Verdict.** Read `validation.md`. If it doesn't exist, the feature is
   **in progress**. Otherwise take the first non-empty line under
   `## Verdict`, drop emphasis marks, and compare case-insensitively: it is
   fulfilled only if it starts with `Spec fulfilled`. `Spec NOT fulfilled`
   or any other text means **in progress**.
2. **Staleness.** Find the latest date among the spec's `## Changes` entries
   (`### CHG-n — YYYY-MM-DD — <title>`) and compare it with the
   `**Date:**` line of `validation.md`. If the change date is later — or the
   spec has any `CHG-n` entry and `validation.md` has no date — the state is
   **re-validation required**. A spec without `CHG-n` entries is never stale;
   don't read free-form "Later changes" sections for this.
3. Otherwise the feature is **closed**.

Then:

- **Order** the closed features as `docs/roadmap.md` lists them: by the first
  place each folder is linked there (several entries may share one folder).
  Folders not linked go after them, by `NNN`. If the roadmap doesn't exist,
  order by `NNN`.
- **List every non-closed feature** in one line, as `NNN-<slug> — in
progress` or `NNN-<slug> — re-validation required`. Never include its
  requirements or design.
- If there is **no closed feature**, say so and generate nothing.
- If a source the requested document needs is missing for a closed feature
  (`spec.md` for `prd`, `changes`, and `acceptance`; `plan.md` for `trd`;
  `validation.md` for `acceptance`), name the missing file and generate
  nothing.

## 5. Writing a document

Every document goes through the same path once its content is drafted (the
per-document rules come in later sections). Nothing is written before the
user approves.

**Before drafting,** check that the document's template exists in this
skill's `templates/` folder (section 1 already did, before any gate). If it
doesn't, name the missing template and generate nothing.

1. **Header.** Start the document with this block, in the document's
   language:

   ```
   > Derived view generated by /sdd:docs. Do not edit by hand.
   > Generated: YYYY-MM-DD
   > Sources: <paths of the artifacts it was derived from>
   > If this document disagrees with the specs, plans, or constitution, those prevail.
   ```

   The second line is the **generation-date line**, with today's date.

2. **Path.** Use the fixed path from the table at the top of this skill.
   `acceptance` replaces `NNN-<slug>` with the feature's folder name.
3. **Language.** The client-facing documents are written entirely — headings
   and header block included — in the content language declared by
   `docs/constitution.md`, or in the language the user writes in if it
   declares none. Don't mix two languages in one file: translate fixed words such as the
   change Type (`add`, `modify`, `remove`) and the outcome labels, but keep
   titles of changes as the spec's author wrote them, since they are names.
   The schema document keeps the template's wording.
4. **Existing file.** If the path already exists, first apply the **reuse
   rule** while drafting: for every item whose source text did not change
   since the file was written and whose existing wording still complies with
   the current rules, copy that wording verbatim instead of rephrasing it, and write new wording only for items whose source changed.
   Keep the order fixed: features as in section 4, items by `FR-n` or `CHG-n`
   number, sections as in the template. Then compare the draft with the file
   **ignoring the generation-date line** (the only line left out of the
   comparison):
   - Nothing else differs → report the file as **up to date** and write
     nothing; stop.
   - Otherwise show what changes against the existing file (a diff) and ask
     whether to overwrite it. A file written by hand has no header block, so
     its first conversion always shows a diff and is never "up to date".
5. **Approval.** Show the proposal (or the diff, for an existing file) and
   write only after an explicit yes. If the user declines or doesn't answer,
   write nothing.
6. **`deliverables/` and `.gitignore`.** When the target is under
   `deliverables/`, check the project's `.gitignore`:
   - Covers `deliverables/` → continue.
   - Doesn't cover it, or the file is missing → propose adding the entry
     (creating `.gitignore` if needed) and wait for approval.
   - The user declines → still write the document, and remind once that
     `deliverables/` is not ignored. Don't ask again in the same request.
7. **Write** the file (creating `deliverables/` if needed).

### Internal documents

`schema`, `flow`, and `ux` use the same path with these differences:

- **No `.gitignore` check** (step 6): they live in `docs/`, and sections 3 and
  6 don't apply.
- **Wording.** The header block, the headings, and the notes heading keep the
  template's English wording; for `flow` and `ux` the body is written in the
  content language of step 3.
- **Hand-written notes.** Copy everything from the existing
  `## Notes (hand-written)` heading to the end of the file unchanged. If the
  existing file has no such heading, write an empty notes section and report
  that the previous content was replaced (it stays recoverable from version
  control).
- **Kept content** (`flow` and `ux`). When the target exists, compare it
  item by item inside each `##` section (an item is a bullet, a table row,
  or a paragraph, identified by its label or first words). If the draft
  leaves an item as a gap (`TODO: provide …`) and the existing item holds
  text that is not a gap, keep the existing text: the artifacts give no
  source for it, so replacing it would only destroy work. If the draft has
  content for the item, the draft wins and the diff shows the replacement
  for approval. Existing items the draft has no counterpart for are kept,
  except journeys in `flow`, which are replaced as a whole (their steps
  depend on each other's order). A section the existing file lacks is
  added.

## 6. Rules for client-facing documents

These rules apply to `prd`, `trd`, `acceptance`, `changes`, and `delivery` —
the reader is a client or stakeholder, not the team. They do **not** apply to
the internal documents (`schema`, `flow`, `ux`).

**Always leave out**, whatever the source says:

- Risks, in any form.
- The verification strategy.
- Open questions, and any `[NEEDS CLARIFICATION: …]` item that is still
  unresolved.
- In the scope change log, each entry's **Reason**.

**Plain sentences.** In the PRD, in the acceptance record, and in the
delivery package, write each requirement as one plain sentence that says who
benefits and what they get. No EARS keywords (`WHEN`, `THE SYSTEM shall`, …),
no `FR-` identifiers inside the sentence, and no technical identifiers such
as file names, table names, or commands. The only place an `FR-n` reference
may appear is the requirements column of a scope change table, as in
`changes`.

**Review list.** Every proposal ends with a "Review before approving" list,
so the user can check what the rules can't guarantee. Re-read the draft **and
the text you left out**, and list each of these with where it was found (file
and section), whether it stayed in the draft or was removed:

- queries,
- numeric thresholds,
- internal identifiers,
- hostnames,
- credentials.

Also list the omitted Reason of each change entry, so the user can ask to
include any of them. Present the list as a review aid made by reading the
text, not as a guarantee that nothing sensitive remains. If nothing was
found, say so.

## 7. `prd` and `trd`

Both cover the **closed features** from section 4, in that order, one
chapter per feature, and list the non-closed ones in one line each. Fill the
matching template (`templates/prd.md`, `templates/trd.md`), then follow
sections 5 and 6.

### `prd` — product requirements

Source: each closed feature's `spec.md`. Name the paths in the header.

| Keep, from the spec     | Written as                      |
| ----------------------- | ------------------------------- |
| Context and goal        | what the feature is for         |
| Users / actors          | who it is for                   |
| User stories            | what each person can do and why |
| Functional requirements | plain sentences (section 6)     |
| Out of scope            | "What is not included"          |

Leave out non-functional requirements, edge cases, clarifications, and open
questions: they describe how the team works, not what the client receives.

### `trd` — technical requirements

Source: each closed feature's `plan.md`. Name the paths in the header.

| Keep, from the plan                    |
| -------------------------------------- |
| Module structure                       |
| Data model                             |
| Algorithms / non-trivial logic         |
| Technical decisions, with their reason |
| Interface contract                     |

Leave out **Risks**, **Verification strategy**, and the table of which FR each
part covers. Keep technical identifiers: unlike the PRD, this reader is
technical. Anything sensitive that stays in the kept text goes to the review
list (section 6).

## 8. `acceptance`, `changes`, and `delivery`

### `acceptance [feature]` — acceptance record

One record for **one closed feature**. Fill `templates/acceptance.md`, then
follow sections 5 and 6.

1. **Pick the feature.** With an argument (a spec number or a folder slug),
   use the matching `specs/NNN-<slug>/`; if none matches, say so and stop.
   Without one, use the most recently closed feature: the closed feature
   whose `validation.md` has the latest `**Date:**` (the higher `NNN` on a
   tie). If no feature is closed, say so and stop.
2. **Check it is closed** (section 4). If it isn't, state why — no
   `validation.md`, a verdict that is not "Spec fulfilled", or "re-validation
   required" with the two dates — and generate nothing.
3. **Content**, from `spec.md` and `validation.md`:
   - The feature's goal.
   - Each requirement as a plain sentence (section 6), with its validated
     outcome in plain words as `validation.md` records it: verified, verified
     with limits (the result carries a qualifier such as "see limits"), or
     not verified.
   - The validation date.
   - The spec's completion criteria, as a checklist.
   - Blank sign-off lines for the client's name, date, and signature.
4. Leave out the evidence column, test names, and the validation notes.

### `changes` — scope change log

Covers the **closed features** from section 4, in that order. Fill
`templates/changes.md`, then follow sections 5 and 6.

1. Read only the entries under each spec's `## Changes` heading
   (`### CHG-n — YYYY-MM-DD — <title>`). Don't read free-form "Later changes"
   sections or reconstruct changes from git history.
2. For each entry, write its date, title, Type (`add`, `modify`, or
   `remove`), and the `FR-n` references it lists, in the order of the spec.
   **Leave out Reason** (section 6).
3. A closed feature with no `## Changes` section, or with none of these
   entries, gets one line saying it has no recorded changes. Say so too when
   no closed feature has any.
4. List non-closed features in one line each, as in section 4.

### `delivery` — delivery package

One project-level document for the **closed features** from section 4, in
that order. Fill `templates/delivery.md`, then follow sections 5 and 6. It
has no version field: the title carries only the project (the date lives in
the header's generation-date line, so a repeat run can be "up to date").

1. If no feature is closed, say so and generate nothing.
2. For each closed feature, from `spec.md` and `validation.md`:
   - What was delivered: the feature's goal, in plain words.
   - What people get: each requirement as a plain sentence (section 6) with
     its validated outcome, exactly as `acceptance` writes it (including
     "verified with limits", so a qualified result is never shown as plain
     verified).
   - Known limits: take **only** the bullets under the `## Known limits`
     heading of `validation.md`, in plain language. If the heading is missing
     or empty, write the line "No limits are recorded for this feature."
     Don't mine `## Notes` or any other section for limits.
3. **Drop what is not a product restriction.** A bullet under `## Known
   limits` that says something was not tested or could not be checked (for
   example "not tested on …", "pending load test"), or that is bookkeeping
   about the SDD artifacts themselves (an undated validation, a spec status),
   is not a limit a client can use: leave it out of the draft and list it in
   the review list (section 6) with its file and section. When unsure, leave
   it out and list it. Write the bullets that stay without file names or other
   technical identifiers.
4. Scope changes: the entries of the `changes` derivation above, over the
   same features, with the same rules (the `FR-n` references stay in this
   table; the **Reason** never does).
5. List non-closed features in one line each, as in section 4.
6. Add the hand-off block with blank lines for the recipient's name, the
   date, and the signature.
7. Summary: one short paragraph with the number of delivered features and of
   recorded changes.

## 9. `schema` — persistent data structures

`docs/schema.md` describes the data the project stores, in one place. It is
an internal document: sections 3 and 6 don't apply, and it needs no closed
feature. Fill `templates/schema.md` the first time.

It runs in one of two modes:

- **Interactive** — the user runs `/sdd:docs schema`. Follow the write path
  of section 5 (steps 1, 2, and 4–7, no `.gitignore` check): show the diff
  and write only after approval.
- **Automatic** — `/sdd:validate` calls this procedure when it issues a
  "fulfilled" verdict. Write without asking, and give `/sdd:validate` the
  result to list in `validation.md`. Never run it for any other verdict.

Procedure:

1. **Find the source.** Use the project's **applied migrations**. If it has
   none, use its declared models or schema definitions, whatever form its
   stack gives them. Don't assume a storage technology.
2. **No source found?** Skip the update: write nothing, leave the verdict
   unchanged, and report exactly `schema: skipped, no schema source found`
   (interactive: to the user; automatic: for `validation.md`).
3. **Sources disagree?** If the migrations and the declared models or
   definitions describe different structures, follow the migrations and
   report the discrepancy (interactive: to the user; automatic: for
   `validation.md`).
4. **Build the document** from the template: one block per persistent
   structure, with its fields, types, constraints, keys, and relationships,
   in storage-neutral wording. List the sources in the header.
5. **Keep the hand-written notes.** Copy everything from the existing
   `## Notes (hand-written)` heading to the end of the file unchanged. If
   the existing file has no such heading, write an empty notes section and
   report that the previous content was replaced (it stays recoverable from
   version control).
6. **Compare, ignoring the generation-date line.** If nothing else differs,
   write nothing (interactive: report it as up to date). In automatic mode,
   a changed file is written and reported as updated.

## 10. `flow` and `ux` — app flow and UX brief

Internal documents, like `schema`: sections 3 and 6 don't apply, so there is
no `lite` gate and no client-facing rule.

**Gaps.** The artifacts don't state everything these templates ask for. Where
a section has no source, write the line `TODO: provide <what>` (the prefix is
a fixed English token; `<what>` is in the content language) instead of
inventing content. Never fill a gap from general knowledge or from what a
typical product would do.

**Gap list.** End every proposal with the list of gaps: one line per section
left as a gap, saying what is missing, so the user knows what to complete by
hand. If there are none, say so.

### `flow` — app flow

Fill `templates/app-flow.md` into `docs/app-flow.md`. It needs at least one
closed feature (section 4): if none is closed, say so and generate nothing.
Read the `spec.md` of every closed feature, in the order of section 4.

1. **Actors** ← each spec's "Users / actors", deduplicated by name across
   features.
2. **Main journeys**: one per user story. Take its steps from the FRs whose
   wording shares the story's actor and action; a table row per step (actor,
   action, result) and the text diagram block of the template. An FR that
   matches no story goes to a final **General journey**, so none is lost.
   A feature with no user stories gets one gap for its journey. The General
   journey is a single final one for the whole project: FRs with an actor and
   an action become its rows; FRs that state a quality (keyboard use, status
   text, readability) or only describe what the system does with no person
   involved are listed under it as "Applies to every journey" bullets, with
   no actor or action invented.
3. **Alternative paths** ← the `IF … THEN` FRs, saying where the journey
   diverges and how it ends.
4. **Error and empty states** ← the spec's edge cases, plus the `IF … THEN`
   FRs that describe a message or a refusal. Write the situation and, if an
   FR states it, what the user sees; when only the situation is sourced, add
   `TODO: provide what the user sees` on the same line.
5. **Screens or views** ← only the ones an FR names (a page, view, screen,
   or view of the product, by name; a section of a document does not count).
   If none is named, one gap.
6. Anything else the template asks for that has no source is a gap.
7. Write it through the internal write path (section 5), and end the
   proposal with the gap list.

### `ux` — UX brief

Fill `templates/ux-brief.md` into `docs/ux-brief.md`. It doesn't need a closed
feature: read `docs/constitution.md` and the `spec.md` and `plan.md` of the
closed features (section 4). With no closed feature, use the constitution
alone.

Derive only what those artifacts state:

1. **Language(s)** ← the content language the constitution declares, and any
   requirement that names a language.
2. **Accessibility** ← the requirements, in any section, that mention
   accessibility or usability (contrast, keyboard, screen readers, and the
   like, in whatever language the spec uses), each with where it applies.
3. **Audience** ← the entries of "Users / actors", listed as named. Their
   context of use, experience level, and constraints are a gap unless an
   artifact states them.
4. **Platforms and constraints** ← statements in the plans or the
   non-functional requirements that name a platform or device.
5. **Principles** ← only the constitution principles that concern the user
   experience; none → a gap. **Content rules** ← requirements that fix the
   wording, terms, or format of what the user reads. **Out of scope** ← the
   "Out of scope" lists of the closed features that concern the interface.
6. **Experience goals, tone of voice, and visual direction** are always a
   gap unless an artifact states them. Never infer them from the kind of
   product.
7. Any other section of the template with no source is a gap.
8. Write it through the internal write path (section 5), and end the
   proposal with the gap list.
