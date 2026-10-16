# Roadmap — sdd-toolkit

Cross-feature view of the toolkit itself. Project-level artifact (alongside
`docs/constitution.md`). Maintained by hand or by `/sdd:validate`.

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
4. **GitHub Copilot CLI distribution** — Agent Plugins 1.0 manifests
   (`plugins/sdd/plugin.json`, `.github/plugin/marketplace.json`); Copilot
   exposes the skills only (no slash commands).
   → `specs/001-sdd-toolkit/spec.md § Later changes` + `CHANGELOG.md`
5. **Documentation profiles (0.5.0)** — `Docs profile: lite | formal`;
   `/sdd:docs` and the `sdd-documents` skill generate PRD, TRD, acceptance
   record, and scope change log into `deliverables/`; `/sdd:validate` now
   moves the feature to Done and refreshes `docs/schema.md`; `/sdd:change`
   records `CHG-n` entries.
   → `specs/002-docs-profiles/`
6. **Derived app-flow, UX brief, and delivery (0.6.0)** — `/sdd:docs` now
   generates `flow` (`docs/app-flow.md`), `ux` (`docs/ux-brief.md`), and
   `delivery` (`deliverables/delivery.md`); `Known limits` section in
   `validation.md`; template-reference check in `tests/validate.sh`.
   → `specs/003-derived-docs/`
7. **Hardening and quality (0.6.1)** — CI with `contents: read` and a pinned
   checkout, Dependabot, `install.sh --prune`, `tests/lint-docs.sh` with
   fixtures, signature tables, and a real-session test of `/sdd:docs`.
   → `CHANGELOG.md`

## Next 🔜

_No feature in progress — maintenance on top of the current release._

## Backlog · ideas 💡

_Every idea must respect `docs/constitution.md`._

- **Support for Cursor or other agents** — today Claude Code, opencode, and
  GitHub Copilot CLI (skills only).
- **Automated semantic versioning** (release-please or similar).
