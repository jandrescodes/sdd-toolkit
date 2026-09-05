---
description: SDD phase 5 — breaks the plan into <30 min tasks ordered by dependency, each with its FRs, a checkbox, and a verifiable "Done when:" line.
argument-hint: "[plan path, if there are several]"
---

You're in **phase 5 (Tasks)** of the SDD flow.

Plan: $ARGUMENTS (if empty, use the `plan.md` of the most recent active spec).

1. Read `docs/constitution.md`, the spec, and the plan.
2. Generate `specs/NNN-<slug>/tasks.md` (same NNN):
   - Tasks of **under 30 minutes** each.
   - **Ordered by dependency** (T1 depends on nothing, etc.).
   - Each task: `- [ ] Tn. <description>. (FR-…)` followed by a line
     `Done when: <verifiable criterion>`.
   - The "Done when" criterion must be checkable (a test, a command, a file
     that exists), not "when it works".
3. Cover every FR from the spec across the tasks.
4. Always append the `## Feature closeout` block from the template at the
   end (checkboxes outside the `Tn` numbering: validation, roadmap, and
   whatever applies for CHANGELOG / deployment / a new convention). Leave
   `<blank>` whatever depends on the project; don't invent steps the
   constitution or `AGENTS.md` don't back.
5. Don't implement anything yet. Show me the list and wait for approval.
