---
description: SDD phase 6 — implements ONLY the given task Tn, verification first (tests or checklist), runs it, marks the task, and stops.
argument-hint: "<task number, e.g. 3>"
---

You're in **phase 6 (Implementation)** of the SDD flow.

Task to implement: T$ARGUMENTS

1. If the argument is empty or not a number, **ask me which task** — don't
   assume T1.
2. Read `docs/constitution.md`, the active spec, the plan, and `tasks.md`.
3. Verify previous tasks are marked `[x]`. If not, warn me.
4. Implement **only** T$ARGUMENTS. No other tasks, no unrequested
   improvements. This phase implements `Tn` tasks; items in `tasks.md`'s
   feature-closeout block (whatever it's labeled — `## Feature closeout`,
   `## Cierre de la feature`, or otherwise, in whatever language) are not
   implemented here.
5. **Verification first.** Write the tests covering the task's FRs, then the
   code until they pass. If the project has no automated suite, run the
   verification the constitution / `AGENTS.md` specifies.
6. Run the full verification (suite or checklist) and **show me the
   result / evidence**. If anything is red or has no evidence, don't close
   the task.
7. Mark T$ARGUMENTS as `[x]` in `tasks.md` and **stop**. Don't continue to
   the next task.
