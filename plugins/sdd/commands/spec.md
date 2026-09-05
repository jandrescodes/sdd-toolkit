---
description: SDD phase 2 — requirements interview (one question at a time, max 6) that generates specs/NNN-<slug>/spec.md with FRs in EARS notation.
argument-hint: "<feature to specify>"
---

You're in **phase 2 (Specification)** of the SDD flow. Use the
`spec-generator` skill.

Feature: $ARGUMENTS

Rules for this phase:

- **Do NOT write code.**
- Read `docs/constitution.md`, `docs/roadmap.md`, and prior specs in `specs/`
  before starting.
- Ask questions **one at a time**, six max, waiting for an answer. Focus on
  edge cases, error behavior, and what's out of scope.
- Only the **WHAT** and the **WHY**. If asked "how would you do it?",
  redirect to the what.
- When done, generate `specs/NNN-<slug>/spec.md` using the skill's template:
  `**Status:**` line, FRs numbered in **EARS**, an "Out of scope" section,
  and completion criteria. Flag gaps as `[NEEDS CLARIFICATION: ...]`.
  `NNN` is the next free number in `specs/`'s counter (three digits,
  monotonic, never reusing deleted ones); it is **not** the roadmap's ordinal
  nor a historical FR. A new repo starts at `001`; if the repo continues an
  inherited series, respect it.
- Write the spec's content in whatever language `docs/constitution.md`
  declares, or the user's language if none is declared — but keep FR
  numbering and EARS keywords in English regardless.
- Ask for **explicit approval** before moving to the plan phase.
