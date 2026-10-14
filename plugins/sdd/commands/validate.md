---
description: SDD phase 7 — walks the spec FR by FR with its verification and result, writes specs/NNN/validation.md, and issues a compliance verdict.
argument-hint: "[spec path, if there are several]"
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Skill
---

You're in **phase 7 (Validation)** of the SDD flow.

Spec: $ARGUMENTS (if empty, use the most recent active spec in `specs/`).

1. Read the spec and verify the project: run the test suite, or — if the
   project has no automated suite — the verification its constitution /
   `AGENTS.md` specifies (a command, or a manual skill/checklist). If none is
   declared, **stop and ask**; don't invent a command.
2. Walk through **each FR in order**. For each one, a row:
   `FR-n | <summary> | <test(s) or evidence covering it> | <PASS / FAIL / NOT COVERED>`.
3. List separately the FRs with no associated verification.
4. Check the spec's completion criteria one by one.
5. **Final verdict**: is the spec fulfilled? If not, exactly what's missing.
6. **Update the roadmap** (`docs/roadmap.md`) for this spec's folder. Do it
   without asking, and carry the outcome into `validation.md` (step 8):
   - Verdict not fulfilled → leave the roadmap untouched.
   - File missing → skip, and note in `validation.md` that the roadmap was
     skipped because the file doesn't exist.
   - No `## Done` heading → skip, and note it; don't invent a heading in the
     file.
   - Folder already listed under `## Done` → leave it unchanged.
   - Listed under `## Next` → move that entry to `## Done`, keeping its text
     and folder link.
   - Not listed → append an entry to `## Done`: feature name, one line, and
     the `specs/NNN-<slug>/` link, numbered after the last Done item.
7. **Refresh the schema document** — only if the verdict is fulfilled; any
   other verdict leaves `docs/schema.md` untouched. Run the `sdd-documents`
   skill's schema procedure in its **automatic** mode (section 9): it writes
   without asking when the content changed, keeps the hand-written notes, and
   returns what it did — updated, unchanged, skipped (`schema: skipped, no
schema source found`), or a discrepancy between migrations and models.
   Carry that result into `validation.md`; it never changes the verdict.
8. Write `specs/NNN-<slug>/validation.md` (same `NNN` as the spec) with: the
   FR-by-FR table from step 2, the list of uncovered FRs, the completion
   criteria checklist, the verdict, today's date as `**Date:** YYYY-MM-DD`
   under the title, and an `## Updated files` section listing each file
   steps 6 and 7 changed (`docs/roadmap.md`, `docs/schema.md`), or `none`;
   a skipped update goes there too, with its reason. If this phase doesn't
   leave this file behind, it isn't done.
9. Don't change code in this phase. If you find a failure, report it; it
   gets fixed by going back to phase 6.
