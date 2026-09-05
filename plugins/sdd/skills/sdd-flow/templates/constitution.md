# Constitution — <project>

Non-negotiable principles. Every spec, plan, and task must comply with them.
Max ~15 lines. Each principle short and verifiable.

1. **Product scope**: <what it is in one sentence>. It is NOT: <2-3 limits>.
   (If the repo has a public README, the long version goes there and this
   summarizes it.)
2. **<Simplicity / stack>**: <language and version, allowed and forbidden
   dependencies>.
3. **The spec rules**: no behavior is implemented unless it's in the active
   spec. If a decision is missing, work stops and the question is asked.
4. **<Layer separation>**: <e.g. the core neither prints nor reads from the
   console; the interface is a thin, testable layer without it>.
5. **Verification as a gate**: every task ends verified —
   <automated suite green | documented manual checklist with evidence
   attached>. Never proceed without it.
6. **<Data / persistence>**: <format, where, what's forbidden>.
7. **Content language**: <the language specs, plans, and other generated
   artifact content are written in — code and identifiers stay in English
   regardless>.
