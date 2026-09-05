---
description: SDD phase 3 — reviews the active spec like a professional QA and lists ambiguities, contradictions, missing edge cases, and conflicts with the constitution. Does not resolve them.
argument-hint: "[spec path, if there are several]"
allowed-tools: Read, Grep, Glob
---

You're in **phase 3 (Clarification)** of the SDD flow.

Spec to review: $ARGUMENTS (if empty, use the most recent active spec in
`specs/`).

1. Read `docs/constitution.md` and the spec.
2. Review it like a **professional QA**. **Only detect, don't resolve or
   rewrite.** List, numbered, in four blocks:
   1. Ambiguities (sentences with more than one interpretation).
   2. Contradictions between requirements.
   3. Uncovered edge cases (empty inputs, duplicates, corrupt data, limits,
      concurrency).
   4. Conflicts with the constitution.
3. For each point, cite the FR or the specific line.
4. Don't propose solutions until asked. When you are, apply the changes to
   the affected FRs and record each resolved finding as a line in a
   `## Clarifications` section at the end of `spec.md` (what was asked, what
   was decided, which FR it touched). Clarification history lives in
   `spec.md`, not in `plan.md`.
