---
name: build
description: >
  Build features, implement specs, create new functionality. The primary skill for
  all construction work — from ad-hoc tasks to spec-driven implementation. Follows
  project conventions, reuses existing code, and self-verifies before reporting done.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *), Bash(node *)
argument-hint: <what to build — spec-id, description, or feature request>
---

# /btrs-build

Build skill. Creates features, implements specs, writes new code. Reads conventions,
follows canonical examples, reuses existing components, and self-verifies.

The user's request is: $ARGUMENTS

## Step 0: Load context

1. Read `btrs/config.json` if it exists.
2. Read `skills/shared/rigor-protocol.md` to determine rigor level.
3. State: "Rigor: {adaptive|standard|strict} — {reason}"

## Step 1: Understand the task

1. If the argument is a **spec-id**: read `btrs/specs/SPEC-NNN-*.md`.
2. If the argument is a **description**: treat it as an ad-hoc task — still read conventions.
3. Extract: requirements, acceptance criteria, affected areas.

## Step 2: Read conventions and existing patterns

1. Read `btrs/conventions/` files relevant to the domain.
2. Read `btrs/code-map/` entries for modules being modified.
3. Grep and Glob the source tree for canonical examples of similar patterns.
4. Identify existing components, utilities, and helpers to reuse. Do not reinvent.

## Step 3: Plan

1. List every file to create or modify.
2. For each file, describe changes at a high level.
3. Identify dependencies between files (write in dependency order).
4. If the plan deviates from the spec, note why.
5. **Present the plan to the user and wait for approval before writing code.**

## Step 4: Build

1. Follow conventions exactly — naming, structure, imports, error handling.
2. Match the style of existing code in the same module.
3. Reuse existing utilities. Grep before creating anything new.
4. Write clean, readable code. Prefer explicit over clever.
5. Do not introduce new dependencies without checking conventions and discussing.

## Step 5: Self-verify

1. **File existence** — Every file created or modified exists and is non-empty.
2. **Pattern compliance** — Code follows conventions from `btrs/conventions/`.
3. **Functional claims** — For each behavior claimed, point to the implementing code.
4. **Integration points** — Imports resolve, types match, API contracts hold.
5. **Completeness** — All acceptance criteria met.

If any check fails, fix and re-verify. Do not report done with known failures.

## Step 6: Update tracking

1. Update spec/todo status if working from one.
2. Update `btrs/code-map/` if new modules or significant changes.
3. Append to `btrs/changelog/{today}.md`.

## Step 7: Report completion

1. Summary of what was built.
2. Verification report (pass/fail/warn).
3. Deferred items or known limitations.
4. Suggested next steps.

## Anti-Patterns

- Do not skip conventions. Read `btrs/conventions/` before writing code.
- Do not duplicate existing utilities. Grep first.
- Do not skip self-verification.
- Do not write code without understanding the task first.
- Do not modify files outside scope — create a TODO instead.
