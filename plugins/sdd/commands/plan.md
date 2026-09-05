---
description: SDD phase 4 — generates specs/NNN-<slug>/plan.md with modules, data model, justified decisions, risks, and a verification strategy. No code.
argument-hint: "[spec path, if there are several]"
---

You're in **phase 4 (Planning)** of the SDD flow.

Spec: $ARGUMENTS (if empty, use the most recent active spec in `specs/`).

1. **Check prerequisites.** If `docs/constitution.md` doesn't exist or there's
   no active spec in `specs/`, **warn and stop** — planning can't happen
   without them.
2. Read the full constitution and spec.
3. **Do NOT write code.** Generate `specs/NNN-<slug>/plan.md` (same NNN as
   the spec) with:
   - Module structure and each one's responsibility.
   - Data model / schema (or "stateless" if it applies).
   - Non-trivial algorithms with their edge cases.
   - Technical decisions, **each with the alternative that was discarded**
     and why.
   - Interface contract (signatures, inputs/outputs, error codes).
   - Risks, each with its mitigation or why it's accepted.
   - Verification strategy: automated suite, or — if the project doesn't
     have one — a manual checklist by role/flow and what evidence gets
     attached.
   - A table of which FR each part covers.
4. The whole plan must respect the constitution. If anything in the spec
   contradicts it, flag it instead of planning around it.
5. Ask for **explicit approval** before moving to tasks.
