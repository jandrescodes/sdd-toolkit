---
name: spec-generator
description: Use this skill when the user asks to create, write, or review a feature specification (spec), in any language they address you in. Guides a one-question-at-a-time requirements interview and produces a spec.md with EARS-notation requirements following the included template.
---

<!--
  Derived from the `spec-generator` skill in MoureDev's SDD course
  (https://github.com/mouredev/hello-sdd), under the Apache License 2.0 — see
  LICENSE-APACHE and NOTICE. Modified: `description` text; `specs/NNN`
  numbering rule and `**Status:**` field in the drafting step; translated to
  English with spec content language now chosen by the target project.
-->

# Spec generator

Turns a vague idea into an agreed-upon specification. The spec is the
contract: if it isn't here, it isn't built.

## Process

1. **Read the context.** `docs/constitution.md` if it exists, and prior specs
   in `specs/` to respect conventions and not contradict what's already
   agreed.
2. **Interview the user.** Questions **ONE at a time**, six max, waiting for
   an answer before the next. Focus on edge cases, error behavior, and what's
   out of scope. Don't propose technical solutions: if the user asks "how
   would you do it?", redirect to the WHAT.
   Prioritize questions whose answer changes what needs to be built; drop
   ones with an obvious default answer.
3. **Pick the number.** `specs/`'s own counter, three digits, monotonic, never
   reusing deleted numbers: use the next free one
   (`specs/NNN-<kebab-case-name>/spec.md`). A new repo starts at `001`; when
   adopting SDD on top of an already-numbered series, continue it (the
   decision is noted in `AGENTS.md`). The number is **not** the ordinal from
   `docs/roadmap.md` nor a historical FR. Read `docs/roadmap.md` if it
   exists.
4. **Draft** using this skill's `spec-template.md`, without skipping
   sections. Add a line under the title:
   `**Status:** <proposed | in progress | implemented ✅>`.
   Acceptance criteria **always in EARS notation**, numbered as
   FR-1, FR-2, … Every requirement must be verifiable: if you can't picture
   how to check it, it's poorly written.
5. **Flag what you don't know** as `[NEEDS CLARIFICATION: specific question]`.
   Never fill a gap by guessing: a visible gap is information, a silent
   assumption is debt.
6. **Ask for explicit approval** when done. Don't move to the plan or write
   code until you have it.

## Rules

- The spec describes **WHAT** and **WHY**. Stack, architecture, file names,
  data schemas, algorithms, or function signatures are forbidden here: that
  goes in the plan.
- **Always** include an "Out of scope" section. It's what keeps the feature
  from growing on its own.
- One requirement, one sentence. If you need an "and" to join two behaviors,
  that's two requirements.
- No unmeasurable adjectives: "fast", "intuitive", "robust" aren't
  requirements. Write the threshold or don't write it.
- **Content language**: whatever the target project's constitution states.
  If there is none, whatever language the user is writing in. This applies to
  the spec's prose; core concepts (`FR-`, EARS keywords, section headers)
  always stay in English so tooling and cross-project tracking stay
  consistent. Be tolerant of the language the user addresses you in,
  regardless of the content language chosen.

## EARS notation

Five patterns. Pick the one that fits, don't mix them:

| Pattern      | Form                                        | When                  |
| ------------ | ------------------------------------------- | --------------------- |
| Ubiquitous   | THE SYSTEM \<shall\>                        | always true           |
| Event-driven | WHEN \<trigger\>, THE SYSTEM \<shall\>      | responds to something |
| State-driven | WHILE \<state\>, THE SYSTEM \<shall\>       | during a condition    |
| Optional     | WHERE \<feature\>, THE SYSTEM \<shall\>     | only if present       |
| Unwanted     | IF \<condition\>, THEN THE SYSTEM \<shall\> | errors and edge cases |

Well-written example:

> FR-4: IF the name already exists (case-insensitive, trimmed comparison),
> THEN THE SYSTEM shall not create a duplicate and shall report the conflict
> (exit code 1).

Poorly written, for contrast:

> ~~FR-4: The system should handle duplicates well and be fast.~~
> No EARS pattern, no verifiable criterion, two ideas in one sentence, and an
> unmeasurable adjective.

## When reviewing an existing spec

If the user asks to review instead of create, don't rewrite: **detect and
list**, numbered, in four blocks — (1) ambiguities, (2) contradictions
between requirements, (3) uncovered edge cases, (4) conflicts with the
constitution. Don't propose solutions until asked.
