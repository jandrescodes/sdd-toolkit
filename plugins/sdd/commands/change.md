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
5. Wait for my approval of the diff. If I don't approve it, record nothing.
6. Once approved, **record the change** at the end of the spec's `## Changes`
   section (create the section at the end of the spec if it's missing):

   ```
   ### CHG-n — YYYY-MM-DD — <title>

   - Type: add | modify | remove
   - FRs: FR-a, FR-b
   - Reason: <why>
   ```

   - `n` is one more than the highest `CHG-n` already in the spec, starting
     at 1. If two entries share a number, tell me; don't renumber or merge
     them.
   - The date is the approval date.
   - The title is plain business language: no `FR-` ids, file names, or
     commands. Clients read it in the change log.
   - `FRs` lists every requirement the change adds, modifies, or removes.
   - Leave any free-form "Later changes" section as it is.

7. Then: update the plan, the affected tasks, and `validation.md` if it
   already existed, then continue with phase 6 to implement the new or
   changed FRs.
