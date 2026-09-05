# AGENTS.md — <project>

## Project

<What it is, in 2-3 sentences. Architecture, technologies.>

## Commands

- Run: `<command>`
- Lint/format: `<command>`
- Verification (each task's gate): `<test command | manual skill/checklist —
name it here once>`

## Style and conventions

<Language version, naming conventions, language for code and messages.>

## Rules

- Read `docs/constitution.md` and the active spec in `specs/` before
  touching code.
- <Boundaries: what not to touch, what not to add without asking.>
- Don't modify files inside `specs/` except on explicit request.
- Precedence: `docs/constitution.md` rules over specs and plans. On
  conflict between `docs/`/`specs/` and this file, this file is the
  operational source for code and `docs/`/`specs/` is the planning layer.
- `docs/` and `specs/` are versioned but not deployed.

## When finishing any task

- <Mandatory verification, e.g. run the tests and confirm in the response
  that they pass.>
