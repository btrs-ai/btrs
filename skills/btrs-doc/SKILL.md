---
name: btrs-doc
description: Refresh project documentation from current code state. Updates component registry, code-map, and Obsidian vault. Use when docs are stale or after major changes.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *)
argument-hint: [full|registry|code-map|conventions]
---

# /btrs-doc

Documentation refresh skill. Re-scans the codebase to update the component registry, code-map, convention files, and Obsidian vault index. Ensures documentation reflects the current state of the code.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for framework, language, source directory, and tooling context.
3. Read `skills/shared/obsidian-conventions.md` for frontmatter and formatting rules.

### Step 1: Determine refresh scope

Parse the argument to determine which documentation areas to refresh:

| Argument | Scope |
|----------|-------|
| `full` (default) | All documentation areas below |
| `registry` | Component/module registry only |
| `code-map` | Code-map entries only |
| `conventions` | Convention files only |

### Step 2: Scan the codebase

1. Glob the source directory (from config `srcDir`) to inventory all source files.
2. Categorize files by module/domain:
   - API routes and handlers
   - Components (UI)
   - Pages/views
   - Utilities and helpers
   - Types and interfaces
   - Configuration files
   - Test files
3. For each file, extract key exports (functions, classes, components, types) using Grep.

### Step 3: Update code-map (if in scope)

1. Read existing `.btrs/code-map/` entries.
2. For each module directory in the source:
   - If a code-map entry exists: compare against current files and exports. Update if stale.
   - If no entry exists: create one following the code-map format.
3. For each code-map entry:
   - If the corresponding source directory no longer exists: mark as deprecated or remove.
4. Each code-map entry should contain:
   - Module purpose (1-2 sentences)
   - Key files with brief descriptions
   - Exported functions, components, or types
   - Dependencies (what this module imports from other modules)
   - Wiki links to related specs and conventions

Format:
```markdown
---
title: "{Module Name}"
updated: {today}
tags:
  - code-map
  - {domain}
---

# {Module Name}

{Purpose description}

## Files

| File | Description | Key Exports |
|------|-------------|-------------|
| `file.ts` | {desc} | `exportA`, `exportB` |

## Dependencies
- Imports from `src/lib/utils` -- [[code-map/lib/utils]]
- Imports from `src/types` -- [[code-map/types]]
```

### Step 4: Update registry (if in scope)

1. Scan for UI components if the project has a component library.
2. For each component, document:
   - Name, file path, props/API
   - Usage examples (Grep for import statements to find usage)
   - Related components
3. Write or update the registry file in `.btrs/code-map/` or a dedicated registry location.

### Step 5: Update conventions (if in scope)

1. Read existing `.btrs/conventions/` files.
2. Scan the codebase for actual patterns:
   - File naming conventions in use
   - Import patterns in use
   - Error handling patterns in use
   - Code style patterns in use
3. Compare documented conventions against actual practice.
4. Flag discrepancies:
   - Convention documented but not followed: note as a drift issue.
   - Pattern in use but not documented: suggest adding to conventions.
5. Update convention files to reflect current best practices, but do not remove rules without user confirmation.

### Step 6: Update vault index

1. Read `.btrs/index.md`.
2. Verify all navigation links point to existing files.
3. Add links for new code-map entries, specs, or decisions created since the last refresh.
4. Update `.btrs/project-map.md` if the high-level structure has changed.

### Step 7: Produce the refresh report

```markdown
# Documentation Refresh Report

**Date**: {today}
**Scope**: {full|registry|code-map|conventions}

## Changes Made
- **Code-Map**: Updated N, Created N, Removed N
- **Registry**: Documented N components, N new, N removed
- **Conventions**: N drift issues, N undocumented patterns
- **Index**: N links added, N broken links fixed

## Staleness Summary
- Source files: N | Documented: N | Coverage: {percentage}
```

### Step 8: Write output and changelog

1. Write the refresh report to `.btrs/agents/documentation/doc-refresh-{today}.md` with proper frontmatter.
2. Update `.btrs/changelog/{today}.md` with a summary of the documentation refresh.

## Anti-patterns

- **Do not delete documentation without user confirmation.** Mark as deprecated instead.
- **Do not document implementation details that change frequently.** Focus on purpose, API, and relationships.
- **Do not overwrite convention files without flagging the changes.** Convention changes affect the entire team.
- **Do not skip the scan step.** Documentation must be driven by current code, not assumptions.
- **Do not document test files in the code-map.** Test documentation belongs in test plans, not the code-map.
- **Do not create code-map entries for generated files.** Only document authored source code.
