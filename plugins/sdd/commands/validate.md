---
description: SDD phase 7 — walks the spec FR by FR with its verification and result, writes specs/NNN/validation.md, and issues a compliance verdict.
argument-hint: "[spec path, if there are several]"
allowed-tools: Read, Grep, Glob, Bash, Write, Skill
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
6. Write `specs/NNN-<slug>/validation.md` (same `NNN` as the spec) with: the
   FR-by-FR table from step 2, the list of uncovered FRs, the completion
   criteria checklist, and the verdict. If this phase doesn't leave this
   file behind, it isn't done.
7. Don't change code in this phase. If you find a failure, report it; it
   gets fixed by going back to phase 6.
