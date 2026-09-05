# Roadmap — sdd-toolkit

Cross-feature view of the toolkit itself. Project-level artifact (alongside
`docs/constitution.md`). Maintained by hand.

Each Done / Next entry links the feature's folder.

## Done ✅

1. **SDD toolkit packaged** — the 8 phases as a Claude Code plugin +
   `install.sh` for opencode / Claude without the plugin; `sdd-flow` and
   `spec-generator` skills; `tests/validate.sh` as the quality gate.
   → `specs/001-sdd-toolkit/`
2. **0.2.0 flow improvements** — roadmap as an artifact, `AGENTS.md` rule,
   `CLAUDE.md` / `validation.md` / `roadmap.md` / `AGENTS-sdd-section.md`
   templates, `validation.md` as phase 7's output, verification as a gate
   for projects without a suite, `docs/ADOPTING.md`, `docs/artifacts.md`, CI.
   → `specs/001-sdd-toolkit/spec.md § Later changes` + `CHANGELOG.md`
3. **English toolkit, user-chosen spec language** — the toolkit's own
   prompts, commands, skills, and docs translated to English (the ecosystem
   convention for Claude Code plugins); `FR-` replaces `RF-`, EARS keywords
   canonical in English; spec/plan/tasks/validation **content** language now
   follows the target project's constitution (or the user's language if
   unset) instead of being hardcoded to Spanish; every prompt made tolerant
   of whatever language it's addressed in.
   → `specs/001-sdd-toolkit/spec.md § Later changes` + `CHANGELOG.md`

## Next 🔜

_No feature in progress — maintenance on top of the current release._

## Backlog · ideas 💡

_Every idea must respect `docs/constitution.md`._

- **Support for Cursor or other agents** — today only Claude Code and
  opencode.
- **Automated semantic versioning** (release-please or similar).
- **Optional check in `validate.sh`** that every template referenced in
  `SKILL.md` exists.
