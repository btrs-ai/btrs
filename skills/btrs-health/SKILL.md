---
name: btrs-health
description: Project-wide health check for drift, convention violations, and stale specs/decisions. Use to check project consistency or before major releases.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), TaskCreate, TaskList
argument-hint: [full|conventions|specs]
---

# /btrs-health

Project-wide drift detection skill. Checks convention violations across the codebase, registry freshness, and spec-code alignment.

## Workflow

### Step 0: Read configuration

1. Read `~/.claude/btrs/skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read all files in `btrs/conventions/` to establish the baseline.
4. Read `~/.claude/btrs/skills/shared/discipline-reference.md` for TDD, verification, and debugging mandates.
5. Read `~/.claude/btrs/skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Determine check scope

Parse the argument to determine which checks to run:

| Argument | Checks |
|----------|--------|
| `full` (default) | All checks below |
| `conventions` | Convention violations only |
| `specs` | Spec-code alignment only |

### Step 2: Convention drift check

1. Read `btrs/conventions/patterns.md` and `btrs/conventions/registry.md`.
2. For each convention, Grep the codebase for violations project-wide.
3. Report the current violation count per convention. There is no historical
   baseline to trend against — git history is the changelog, so compare
   against the previous commit's state via `git log`/`git diff` if a trend is
   needed, rather than a stored health-check artifact.

### Step 3: Registry and convention staleness check

1. Read `btrs/conventions/registry.md` and compare against actual source files.
   - Components/utilities/hooks/types listed that no longer exist.
   - Source files with no registry entry.
2. Read `btrs/decisions/` for ADRs that reference deprecated technologies or patterns.

### Step 4: Spec-code alignment check

1. Read all `btrs/specs/` files with status `complete`.
2. For each completed spec:
   - Verify the affected files listed in the spec actually exist.
   - Spot-check that acceptance criteria are reflected in the code.
3. Read all `btrs/specs/` files with status `in-progress`.
4. For each in-progress spec:
   - Check which acceptance criteria have been implemented vs. remaining.
   - Report progress percentage.

### Step 5: Task coherence check

1. Use TaskList to review open tasks tracked for this project (v3 tracks work
   via Claude's TaskCreate/TaskList, not a `btrs/todos/` directory).
2. Flag tasks that reference specs which have been cancelled or completed.

### Step 6: Produce the health report

```markdown
# Project Health Report

**Date**: {today}
**Scope**: {full|conventions|specs}
**Overall health**: HEALTHY | DRIFTING | UNHEALTHY

## Summary
- Convention violations: N
- Stale registry entries: N
- Spec alignment issues: N specs

## Convention Health
| Convention | Violations |
|-----------|-----------|
| patterns.md | N |

## Registry Health
- Stale entries: {list}
- Missing entries: {list}
- Outdated ADRs: {list}

## Spec Alignment
| Spec | Status | Completion | Issues |
|------|--------|-----------|--------|

## Recommendations
1. {Prioritized action items}
```

Present this report directly to the user — it is not written to `btrs/`. Only
`btrs/decisions/`, `btrs/specs/`, and `btrs/conventions/` are persistent vault
paths in v3; a health check is a point-in-time diagnostic, not a tracked
artifact.

### Step 7: File follow-up tasks

For critical issues found (broken specs, ADRs referencing removed
dependencies), use TaskCreate to track the fix. Do not create a task for
every minor issue — report those in the health report only.

## Anti-patterns

- **Do not run a full health check on every small change.** Reserve full checks for milestones or release prep.
- **Do not create a task for every minor issue found.** Only create tasks for actionable items. Report minor issues in the report only.
- **Do not modify files during a health check.** This is a read-only diagnostic. Use other skills to fix issues.
- **Do not compare against imagined conventions.** Only flag violations for rules that exist in `btrs/conventions/`.
- **Do not write the health report to `btrs/`.** There is no `btrs/agents/` path in v3 — present it directly in the conversation.
