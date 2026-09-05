---
description: SDD phase 1 — proposes the project's constitution (short, verifiable principles) and waits for approval before writing docs/constitution.md.
argument-hint: "[number of principles | notes]"
---

Don't write code or specs. You're in **phase 1 (Constitution)** of the SDD
flow.

Context: $ARGUMENTS

1. If `docs/constitution.md` already exists, read it and propose improvements
   instead of starting from scratch.
2. Propose the project's constitution: short, **verifiable** principles on
   stack, quality, verification, scope limits, and data/persistence. Include
   a **product scope** principle (what it is in one sentence; 2-3 limits on
   what it's NOT). Max ~15 lines. No unmeasurable adjectives. The
   constitution and `docs/roadmap.md` are the two project-level artifacts.
3. Number them. Always include one on "the spec rules" and one on
   "verification as a gate": every task ends with its automated suite green
   or — if the project has none — the documented manual verification
   checklist with its evidence attached. Never proceed without green/
   evidence.
4. Show me the proposal and **wait for my explicit approval**. Don't write
   the file until I approve it.
5. Once approved: write `docs/constitution.md`.
