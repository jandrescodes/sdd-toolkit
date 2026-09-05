# Constitution — sdd-toolkit

The SDD method this repo packages comes from MoureDev's course
(<https://github.com/mouredev/hello-sdd>). This repo only packages and
distributes it.

Non-negotiable principles. Every spec, plan, and task in this repo must
comply with them.

1. **Single source of truth**: all editable content lives in `plugins/sdd/`.
   Any other copy (`install.sh` destinations, symlinks) is derived and never
   edited by hand.
2. **Stack-agnostic, English toolkit, user-chosen spec language**: the toolkit
   assumes no language or framework. Templates have blanks, never examples
   tied to a technology. The toolkit's own prompts, commands, and docs are in
   English; identifiers and file names are in English. The **content** of
   specs, plans, and other generated artifacts is written in the language the
   target project's constitution declares — default to the language the user
   writes in if the constitution doesn't state one. Core concepts (`FR-`,
   EARS keywords, section headers like `Done when:`) stay in English
   regardless of the content language, so tooling and cross-project tracking
   stay consistent. Every prompt must remain tolerant of whatever language
   the user addresses it in.
3. **One versioned artifact per phase**: constitution (`docs/constitution.md`),
   spec, plan, tasks, and validation (`specs/NNN-<slug>/{spec,plan,tasks,validation}.md`)
   each produce a Markdown file that stays in the project's repo. The roadmap
   (`docs/roadmap.md`) is the other project-level artifact, maintained by hand.
   If a step leaves no trace, it isn't done.
4. **No runtime dependencies**: only `bash` and what Claude Code and opencode
   already ship with. `python3` or `node` are accepted for JSON validation,
   both common. No package managers or extra binaries.
5. **EARS is mandatory**: acceptance criteria in every spec are written in
   EARS notation, numbered FR-1, FR-2, …, and each one must be verifiable.
6. **Verification as a gate**: `bash tests/validate.sh` **and**
   `claude plugin validate ./plugins/sdd --strict` must pass before any task
   is considered closed. Never proceed with a red gate.
7. **The spec rules**: no behavior is implemented unless it's in the active
   `specs/` entry. If a decision is missing, work stops and the question is
   asked.
8. **Releases tagged with SemVer, no `v` prefix**: every published version
   bumps `plugin.json`, gets its section in `CHANGELOG.md`, and an annotated
   git tag (`0.1.0`, `0.2.0`, …) on the `main` commit that contains it.
