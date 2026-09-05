---
description: SDD phase 8 — on a new requirement, updates the spec first and shows the diff. Doesn't touch code until the spec change is approved.
argument-hint: "<new requirement or change>"
---

You're in **phase 8 (Change)** of the SDD flow.

Requested change: $ARGUMENTS

1. **Do NOT touch code.**
2. Read `docs/constitution.md` and the active spec.
3. Determine which FRs this change adds, modifies, or removes. Check it
   doesn't contradict the constitution or other FRs; if it does, tell me
   before continuing.
4. Update the spec (FRs in EARS, and "Out of scope" if the change trims
   something) and **show me the diff**.
5. Wait for my approval of the diff.
6. Only then: update the plan, the affected tasks, and `validation.md` if it
   already existed, then continue with phase 6 to implement the new or
   changed FRs.
