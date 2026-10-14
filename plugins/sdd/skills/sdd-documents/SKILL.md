---
name: sdd-documents
description: Use this skill when the user wants a project document built from the SDD artifacts — in any language they ask in ("generate the PRD", "write the technical doc", "acceptance record for this feature", "change log for the client", "update the schema doc", "genera el PRD", "acta de aceptación", "documento de cambios"). Derives PRD, TRD, acceptance record, scope change log, and schema from the existing specs, plans, and validations, after the user approves a proposal. Also brings the templates for the hand-written app-flow and UX-brief documents.
---

# SDD documents

A documentation layer on top of the SDD artifacts. The documents it produces
are **derived views** of the constitution, specs, plans, and validations —
never a second source of truth. If a document and those artifacts disagree,
the artifacts prevail.

It is a cross-cutting action, **not a ninth phase** of the flow. Apart from
the schema refresh that `/sdd:validate` runs on its own (section 9), it never
writes anything the user hasn't approved.

| Name         | File                                    | Kind                          |
| ------------ | --------------------------------------- | ----------------------------- |
| `prd`        | `deliverables/prd.md`                   | client-facing, derived        |
| `trd`        | `deliverables/trd.md`                   | client-facing, derived        |
| `acceptance` | `deliverables/acceptance-NNN-<slug>.md` | client-facing, derived        |
| `changes`    | `deliverables/changes.md`               | client-facing, derived        |
| `schema`     | `docs/schema.md`                        | internal, derived             |
| `flow`, `ux` | `docs/app-flow.md`, `docs/ux-brief.md`  | hand-written, from a template |

Templates live in this skill's `templates/` folder. Depending on how the
toolkit is installed, it is at:

- Plugin: inside the `sdd` plugin (Claude Code resolves it on its own).
- Script (`install.sh`): `~/.claude/skills/sdd-documents/templates/` and/or
  `~/.config/opencode/skills/sdd-documents/templates/`.
- Copilot CLI: wherever the skill was installed.

## 1. Which document?

The request arrives either as an argument of `/sdd:docs <name> [feature]` or
as plain language in any language. Work out the name first:

1. If it is one of `prd`, `trd`, `acceptance`, `changes`, or `schema`, go on.
2. If it is `flow` or `ux` (or a request for an app-flow / UX document), say
   that these two are **written by hand** from `templates/app-flow.md` and
   `templates/ux-brief.md` and are not generated, point to the template, and
   stop.
3. If the request came from the command and the name is missing or is
   anything else, list the five valid names (and mention `flow`/`ux`) and
   stop. Generate nothing.
4. If the request came in natural language and does not identify **exactly
   one** of the five, **ask which one**. Generate nothing yet.

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
`changes`) while the profile is `lite`. It does not apply to `schema`.

1. Warn that formal documents are not enabled for this project, and ask for
   confirmation before proposing anything.
2. Ask **on every request**. Don't remember an earlier answer, not even
   within the same conversation.
3. If the user declines, write nothing and stop.
4. If the user confirms, continue exactly as for `formal`.

## 4. Closed features

`prd`, `trd`, and `changes` cover **closed features only**; `acceptance`
covers one closed feature. `schema` doesn't depend on this section. For each
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
   declares none. Don't mix two languages in one file. The schema document
   keeps the template's wording.
4. **Existing file.** If the path already exists, compare the draft with it
   **ignoring the generation-date line**:
   - Nothing else differs → report the file as **up to date** and write
     nothing; stop.
   - Otherwise show what changes against the existing file (a diff) and ask
     whether to overwrite it.
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

## 6. Rules for client-facing documents

These rules apply to `prd`, `trd`, `acceptance`, and `changes` — the reader is
a client or stakeholder, not the team. They do **not** apply to `schema`,
which is an internal document.

**Always leave out**, whatever the source says:

- Risks, in any form.
- The verification strategy.
- Open questions, and any `[NEEDS CLARIFICATION: …]` item that is still
  unresolved.
- In the scope change log, each entry's **Reason**.

**Plain sentences.** In the PRD and in the acceptance record, write each
requirement as one plain sentence that says who benefits and what they get.
No EARS keywords (`WHEN`, `THE SYSTEM shall`, …), no `FR-` identifiers, and
no technical identifiers such as file names, table names, or commands.

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

## 8. `acceptance` and `changes`

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
     outcome in plain words (verified, or not verified) as `validation.md`
     records it.
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
