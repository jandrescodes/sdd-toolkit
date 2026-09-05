# Tasks — Spec 001

- [x] T1. Skeleton: repo, `.gitignore`, `LICENSE` (MIT), folder structure,
      `tests/validate.sh`. (FR: —)
      Done when: `bash tests/validate.sh` runs (even if it fails on pieces
      still missing, with no bash errors).
- [x] T2. Dogfood docs: `docs/constitution.md` + `specs/001-sdd-toolkit/`
      (spec with clarification applied + plan + these tasks). (FR-20)
      Done when: spec with FRs numbered in EARS and an "Out of scope"
      section.
- [x] T3. Base plugin: `.claude-plugin/marketplace.json` +
      `plugins/sdd/.claude-plugin/plugin.json`. (FR-1, FR-19)
      Done when: `claude plugin validate ./plugins/sdd --strict` passes and
      `validate.sh` validates both JSON files.
- [x] T4. `spec-generator` skill: copied and generalized. (FR-10)
      Done when: valid frontmatter, no references to specific projects.
- [x] T5. `sdd-flow` skill + templates in `templates/`. (FR-9, FR-20)
      Done when: SKILL.md describes the 8 phases and links each template.
- [x] T6. The 8 slash commands. (FR-9, FR-11..FR-17)
      Done when: each with a `description` frontmatter; `validate.sh`
      green.
- [x] T7. `install.sh` with `--target`, `--dry-run`, `--force`.
      (FR-2..FR-8, FR-18)
      Done when: the smoke test against `HOME=$(mktemp -d)` leaves the
      files at the right paths and is idempotent when repeated.
- [x] T8. `README.md` + final FR-by-FR validation. (All)
      Done when: every FR has evidence and the flow demo is documented.

## Later corrections (2026-08-27 review)

- [x] T9. Dual license: `LICENSE-APACHE` + `NOTICE` for material derived
      from hello-sdd (Apache-2.0); mark the derived files; README license
      section rewritten. (FR-18, license)
      Done when: `LICENSE-APACHE` and `NOTICE` exist; the README
      distinguishes MIT vs. Apache-2.0 and lists the 4 Apache files.
- [x] T10. Plugin commands unprefixed (`/sdd:<phase>`); `install.sh`
      prefixes `sdd-` when installing into a flat directory. Docs
      (README, `sdd-flow` skill) updated. (FR-1, FR-2, FR-3)
      Done when: `plugins/sdd/commands/*.md` unprefixed; smoke test
      confirms `sdd-spec.md` at the destinations and no bare `spec.md`.
- [x] T11. `install.sh`: valueless `--target` → usage + exit 1; opencode
      path to `commands/` (plural). (FR-2, FR-8)
      Done when: `./install.sh --target` exits 1 with a message;
      opencode destinations at `~/.config/opencode/commands/`.
- [x] T12. `tests/validate.sh`: real `install.sh` smoke test (paths,
      prefix, idempotence, `--dry-run`, `--force`, error exits).
      (FR-2..FR-8, FR-19)
      Done when: `bash tests/validate.sh` runs the install against a
      temporary `HOME` and every assertion passes.

## Flow improvements (2026-09)

See `spec.md § Later changes` and `CHANGELOG.md`.

- [x] T13. Group A: `validate.md` writes `validation.md` (+
      `Write`/`Skill`); "verification as a gate" in `/sdd:constitution`
      and its template; CI (`.github/workflows/validate.yml`);
      `sdd-flow`'s `description`.
- [x] T14. Group B: `roadmap.md`, `validation.md`, `CLAUDE.md`,
      `AGENTS-sdd-section.md` templates; blanks in `plan.md`
      (`## Risks`), `tasks.md` (`## Feature closeout`), `spec-generator`
      (numbering + `**Status:**`).
- [x] T15. Group C: `SKILL.md` sections (adopting, about `AGENTS.md`,
      precedence, no-deploy); `clarify` → `§ Clarifications`;
      `implement` only `Tn`; `constitution` asks for product scope.
- [x] T16. Group D: `docs/roadmap.md`, `docs/ADOPTING.md`, `README`,
      `specs/001` dogfood, `plugin.json` to `0.2.0`.

## English toolkit, user-chosen spec language (2026-09)

See `spec.md § Later changes` and `CHANGELOG.md`.

- [x] T17. Toolkit prompts, commands, skills, and templates translated to
      English: `RF-` → `FR-`, EARS keywords canonical in English, coupled
      section headers translated together (`Done when:`, `Feature
    closeout`, `PASS/FAIL/NOT COVERED`, `Done ✅`/`Next 🔜`,
      `NEEDS CLARIFICATION`, `Status:`).
- [x] T18. `docs/constitution.md` principle 2 rewritten: toolkit content
      in English, generated artifact content language chosen by the
      target project's constitution; every prompt made tolerant of the
      language it's addressed in.
- [x] T19. `sdd-flow`'s `description` kept bilingual (English + Spanish
      trigger phrases); `implement.md` made tolerant of the
      feature-closeout block's language for pre-existing adopters.
- [x] T20. Docs and manifests: `README`, `docs/ADOPTING.md`,
      `docs/artefactos.md` → `docs/artifacts.md`, `docs/roadmap.md`,
      `NOTICE`, `plugin.json` + `marketplace.json` descriptions,
      `CHANGELOG.md`, and this repo's own dogfood
      (`specs/001-sdd-toolkit/`) translated. `plugin.json` to `0.3.0`.

## Feature closeout

- [x] Verify all FRs (`specs/001-sdd-toolkit/validation.md`).
- [x] Move the feature to `Done ✅` in `docs/roadmap.md`.
- [x] `CHANGELOG.md` up to date (`## [0.3.0]`).
- [ ] Tag version `0.3.0` (no `v` prefix) — done by the maintainer.
- [x] New conventions noted in the `sdd-flow` skill itself.
