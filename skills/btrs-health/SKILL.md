---
name: btrs-health
description: Project-wide health check for drift, stale docs, convention violations, and inconsistencies. Use to check project consistency or before major releases.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *)
argument-hint: [full|conventions|docs|todos]
---

# /btrs-health

Project-wide drift detection skill. Checks registry freshness, convention violations across the codebase, documentation staleness, todo coherence, and spec-code alignment.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read all files in `btrs/conventions/` to establish the baseline.
4. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
5. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

### Step 1: Determine check scope

Parse the argument to determine which checks to run:

| Argument | Checks |
|----------|--------|
| `full` (default) | All checks below |
| `conventions` | Convention violations only |
| `docs` | Documentation staleness only |
| `todos` | Todo coherence only |

### Step 2: Convention drift check

1. Read all `btrs/conventions/` files.
2. For each convention, Grep the codebase for violations (same approach as `/btrs-verify` but project-wide).
3. Compare violation counts against previous health check if one exists in `btrs/agents/`.
4. Report whether violations are increasing, stable, or decreasing.

### Step 3: Documentation staleness check

1. Read `btrs/code-map/` entries and compare against actual source files.
   - Files referenced in code-map that no longer exist.
   - Source files with no code-map entry.
   - Code-map descriptions that do not match current file contents (check key exports/functions).
2. Read `btrs/specs/` files with status `in-progress` or `review`.
   - Check if acceptance criteria are still relevant.
   - Check if affected files list matches actual changes.
3. Check `btrs/decisions/` for ADRs that reference deprecated technologies or patterns.

### Step 4: Todo coherence check

1. Read all `btrs/todos/TODO-*.md` files.
2. Check for:
   - TODOs with status `in-progress` but no recent changelog activity (stale work).
   - TODOs with status `pending` that have all dependencies completed.
   - TODOs that reference specs which have been cancelled.
   - TODOs with missing or broken wiki links.
   - Duplicate TODOs (same description assigned to the same agent).
3. Check for orphaned inline TODOs in source code that have no matching `btrs/todos/` entry.

### Step 5: Spec-code alignment check

1. Read all `btrs/specs/` files with status `complete`.
2. For each completed spec:
   - Verify the affected files listed in the spec actually exist.
   - Spot-check that acceptance criteria are reflected in the code.
3. Read all `btrs/specs/` files with status `in-progress`.
4. For each in-progress spec:
   - Check which acceptance criteria have been implemented vs. remaining.
   - Report progress percentage.

### Step 6: Registry and index freshness

1. Read `btrs/index.md` and check that links resolve to existing files.
2. Read `btrs/project-map.md` and verify it reflects the current high-level structure.
3. Check that `btrs/agents/` directories match the agents that have produced output.

### Step 7: Produce the health report

```markdown
# Project Health Report

**Date**: {today}
**Scope**: {full|conventions|docs|todos}
**Overall health**: HEALTHY | DRIFTING | UNHEALTHY

## Summary
- Convention violations: N (trend: up/down/stable)
- Stale documentation: N files
- Stale TODOs: N items
- Spec alignment issues: N specs
- Broken links: N

## Convention Health
| Convention | Violations | Trend |
|-----------|-----------|-------|
| ui.md | N | {up/down/stable} |
| api.md | N | {up/down/stable} |

## Documentation Health
- Stale code-map entries: {list}
- Missing code-map entries: {list}
- Outdated ADRs: {list}

## Todo Health
- Stale in-progress: {list with age}
- Ready to start: {list}
- Orphaned: {list}

## Spec Alignment
| Spec | Status | Completion | Issues |
|------|--------|-----------|--------|

## Recommendations
1. {Prioritized action items}
```

### Step 8: Write output to vault

1. Write the health report to `btrs/agents/boss/health-{today}.md` with proper frontmatter.
2. Create TODOs for any critical issues found (stale work, broken specs).
3. Update `btrs/changelog/{today}.md` with health check summary.

## Anti-patterns

- **Do not run a full health check on every small change.** Reserve full checks for milestones or release prep.
- **Do not create TODOs for every minor issue found.** Only create TODOs for actionable items. Report minor issues in the report only.
- **Do not modify files during a health check.** This is a read-only diagnostic. Use other skills to fix issues.
- **Do not compare against imagined conventions.** Only flag violations for rules that exist in `btrs/conventions/`.
- **Do not skip the trend comparison.** Knowing whether things are getting better or worse is more valuable than absolute counts.
