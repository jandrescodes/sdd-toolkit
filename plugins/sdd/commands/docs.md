---
description: Cross-cutting action (not a phase) — generates a PRD, TRD, acceptance record, scope change log, or schema document from the SDD artifacts, after you approve a proposal.
argument-hint: "<prd|trd|acceptance|changes|schema> [feature]"
allowed-tools: Read, Grep, Glob, Bash, Write, Edit, Skill
---

This is a cross-cutting action, **not a phase** of the SDD flow.

Request: $ARGUMENTS

Run the `sdd-documents` skill with this request and follow it exactly. It
holds every rule: valid names, profile, closed features, approval, and output
paths. Don't apply any rule from memory or add any of your own.
