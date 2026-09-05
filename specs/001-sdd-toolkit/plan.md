# Technical plan — Spec 001

## Module structure

- `.claude-plugin/marketplace.json` → marketplace with one `sdd` plugin (FR-1).
- `plugins/sdd/.claude-plugin/plugin.json` → plugin manifest (FR-1).
- `plugins/sdd/skills/spec-generator/` → interview skill (FR-10).
- `plugins/sdd/skills/sdd-flow/` → flow skill + `templates/` (FR-9, FR-20).
- `plugins/sdd/commands/*.md` → 8 slash commands (FR-9..FR-17).
- `install.sh` → distribution for opencode and Claude Code without the
  plugin (FR-2..FR-8).
- `tests/validate.sh` → quality gate (FR-19).
- `docs/`, `specs/001-sdd-toolkit/` → dogfood, living example (FR-20).

## `install.sh` contract

```
install.sh --target claude|opencode|both [--dry-run] [--force]
```

- Source: `plugins/sdd/skills/` and `plugins/sdd/commands/` (FR-18).
- Destinations:
  - claude → `~/.claude/skills/` + `~/.claude/commands/`
  - opencode → `~/.config/opencode/skills/` + `~/.config/opencode/commands/`
- Commands (files at the root of the source tree) are copied with the
  filename prefixed `sdd-` to avoid collisions in a flat directory; files
  nested inside a skill are copied as-is (FR-2, FR-3).
- Copies file by file. If the destination exists and is identical →
  nothing (FR-5). If it exists and differs → skip + warn, unless
  `--force` (FR-6).
- `--dry-run` → prints actions, writes nothing (FR-7).
- Invalid, missing, or valueless `--target` → usage + exit 1 (FR-8).
- `mkdir -p` for each destination path (edge case).

## Technical decisions

- **Plugin + script, not just a skills dir.** The plugin provides
  `/plugin update` and namespacing (`sdd:...`); the script covers opencode
  and anyone who doesn't want the plugin. Discarded: publishing only as a
  folder under `~/.claude/skills/` — no namespaced commands or updates.
- **Commands unprefixed in the plugin, prefixed in the script.** Inside
  the plugin, `constitution.md` → `/sdd:constitution` (the plugin already
  namespaces it); adding `sdd-` would give `/sdd:sdd-constitution`. The
  script installs into a shared flat directory, where `/constitution`
  would be too generic, so there it does prefix `sdd-`. Discarded: a
  single name for both destinations — forces a choice between ugly in the
  plugin or a collision in the script.
- **opencode's commands path: `commands/` (plural).** That's what
  opencode documents. Tested on 1.17.13: `command/` (singular) also
  resolves, but there's no reason to depend on an undocumented alias.
- **Skills/ and commands/ autodiscovery** in `plugin.json` (not listed
  explicitly) → less surface to maintain.
- **`spec-generator` kept separate from the `sdd-flow` skill.** It's the
  only phase with real interaction (the interview); merging it would make
  `sdd-flow` huge and trigger it at the wrong moment.
- **JSON validation with `python3` or `node`**, whichever is available.
  Discarded adding `jq` — a dependency many don't have.
- **File comparison in `install.sh` with `cmp -s`** (POSIX), not a hash.
- **Commands reference paths in the target project** (`docs/constitution.md`,
  `specs/`), not toolkit paths — they run inside the user's repo.

## "Data" model (no state)

The toolkit persists no state. The only "data" are text files: templates
(source) and their copies (destination). The contract is: source rules.

## Risks

- **Drift between the plugin and `install.sh`'s copies** → `plugins/sdd/`
  is the only editable source (FR-18) and `tests/validate.sh` runs a real
  install smoke test.
- **`AGENTS.md` and `constitution.md` are Apache-2.0** → any content
  change requires updating `NOTICE`; checked on every batch of
  improvements.
- **Fuzzy license boundary if `spec-template.md` is moved** → left where
  it is (in `spec-generator/`), documented in the README and `SKILL.md`.

## Verification strategy

- `tests/validate.sh` (FR-19): parses both JSON files; checks
  `name`+`description` frontmatter in every `SKILL.md` and `description`
  in every command; `name` == folder; `bash -n install.sh`; `install.sh`
  is executable.
- `install.sh` smoke test **inside `tests/validate.sh`** (FR-2..FR-8):
  installs with `HOME=$(mktemp -d)`, checks the 4 destinations, the
  `sdd-` prefix on commands, idempotence on a second pass, `--dry-run`
  with no writes, `--force` restoring a modified destination, and exit 1
  with a missing / invalid / valueless target.
- `claude plugin validate ./plugins/sdd --strict` (FR-1).
- Manual end-to-end demo on a scratch project (completion criteria).

## Which FR each part covers

| Part                                      | FR                 |
| ----------------------------------------- | ------------------ |
| `marketplace.json` + `plugin.json`        | FR-1, FR-19        |
| `install.sh`                              | FR-2..FR-8, FR-18  |
| `spec-generator` skill + `spec` command   | FR-10              |
| `sdd-flow` skill + `templates/`           | FR-9, FR-20        |
| remaining commands (`clarify`, `plan`, …) | FR-9, FR-11..FR-17 |
| `tests/validate.sh`                       | FR-19              |
| `docs/` + `specs/001-sdd-toolkit/`        | FR-20              |
