# Tasks — Spec NNN

Tasks under 30 min, ordered by dependency. Each one: its FRs, a checkbox, and
a verifiable "Done when:" line.

- [ ] T1. <Description>. (FR: —)
      Done when: <verifiable criterion>.
- [ ] T2. <Description>. (FR-…)
      Done when: <verifiable criterion>.
- [ ] T3. <Description>. (FR-…)
      Done when: <verifiable criterion>.

## Feature closeout

_Standalone checkboxes, outside the `Tn` numbering — not implemented via
`/sdd:implement`. Leave `<blank>` whatever depends on the project; don't
invent steps the constitution or `AGENTS.md` don't back._

- [ ] Verify all FRs (`/sdd:validate` → `specs/NNN-<slug>/validation.md`).
- [ ] Confirm `/sdd:validate` moved the feature to `Done ✅` in
      `docs/roadmap.md`, linking this folder.
- [ ] <Update `CHANGELOG` / project docs, if applicable.>
- [ ] <Deployment or manual migration steps, if applicable.>
- [ ] <New convention discovered → record it in `AGENTS.md`, if applicable.>
