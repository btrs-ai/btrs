---
name: btrs-init
description: >
  Scan a project and create the btrs/ Obsidian vault with conventions, registry,
  and project-map. Run automatically on first /btrs use or manually to refresh.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(ls *)
argument-hint: [refresh]
---

You are the BTRS project scanner. Analyze a project's structure, detect its tech stack, and create the `btrs/` Obsidian vault with conventions, registry, and project-map.

Mode: If `$ARGUMENTS` is "refresh", update existing files rather than creating from scratch.

## Step 0: Read config reference

1. Read `skills/shared/config.md` for standard paths and structure.
2. Read `skills/shared/obsidian-conventions.md` for formatting rules.

## Step 0.5: Detect and migrate existing structures

Check for old structures and migrate if found:

### v2 → v3 Migration

If `btrs/knowledge/` exists (v2 three-tier structure):

1. Announce: "Found v2 vault structure. Migrating to v3 flat structure."
2. Move files:
   - `btrs/knowledge/decisions/` → `btrs/decisions/`
   - `btrs/knowledge/conventions/` → `btrs/conventions/`
   - `btrs/work/specs/` → `btrs/specs/`
   - `btrs/work/status.md` → `btrs/status.md`
   - `btrs/knowledge/code-map/project-map.md` → `btrs/project-map.md` (if not already at root)
3. Merge convention files: If separate `ui.md`, `api.md`, `database.md`, `testing.md`, `styling.md` exist in conventions/, merge their content into a single `patterns.md`.
4. Remove empty directories: `knowledge/`, `work/`, `evidence/`
5. Update `btrs/config.json` version to `3.0.0`
6. Report what was migrated.

### Legacy migrations

If old `.btrs/` exists (dot-prefixed):
1. Move `.btrs/` contents to `btrs/` following v3 structure.
2. Remove `.btrs/` after migration.

If `AI/memory/` exists:
1. Convert any research findings to ADRs in `btrs/decisions/`.
2. Report what was migrated.

## Step 1: Scan project structure

Detect the project's technology stack:

### 1a. Package manifest and language

Read whichever exists: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`, `composer.json`, `Gemfile`.

Extract: project name, language, package manager, scripts, dependencies.

### 1b. Framework detection

| Framework | Detection signal |
|-----------|-----------------|
| Next.js | `next` in deps, `next.config.*`, `app/` or `pages/` |
| React (Vite) | `react` in deps without `next`, `vite.config.*` |
| Vue/Nuxt | `vue`/`nuxt` in deps |
| Express | `express` in deps |
| NestJS | `@nestjs/core` in deps |
| FastAPI | `fastapi` in requirements |
| Django | `django` in requirements |

### 1c. Library detection

Scan dependencies for: component library, styling, ORM, test framework, state management, auth, validation, monorepo tools.

### 1d. Directory structure scan

Glob for: `src/**/`, `app/**/`, `pages/**/`, `components/**/`, `lib/**/`, `api/**/`, `server/**/`, `tests/**/`, `prisma/**/`, `.github/**/`, `docker*`, `infra/**/`

Record every directory that exists. These become agent scope entries.

## Step 2: Create btrs/ vault structure

Create the v3 flat structure:

```
btrs/
btrs/decisions/
btrs/specs/
btrs/conventions/
btrs/.obsidian/
```

### 2a. Create status.md

```markdown
---
title: Active Work Status
updated: {today's date}
---

# Active Work

## Current
_No active work._

## Blocked
_Nothing blocked._

## Recently Completed
_No recent completions._
```

### 2b. Obsidian config

Write `btrs/.obsidian/app.json`:
```json
{
  "showLineNumber": true,
  "strictLineBreaks": false,
  "readableLineLength": true
}
```

## Step 3: Generate project map

Write `btrs/project-map.md` mapping detected directories to agent scopes.

```markdown
---
title: "Project map"
created: {today's date}
updated: {today's date}
tags:
  - architecture
---

# Project map

## Stack summary

| Aspect | Value |
|--------|-------|
| Framework | {value} |
| Language | {value} |
| Component library | {value or "none"} |
| ORM | {value or "none"} |
| Test framework | {value or "none"} |
| Package manager | {value} |

## Agent scopes

### btrs-web-engineer
- **primary**: {actual paths}
- **shared**: {shared paths}

### btrs-api-engineer
- **primary**: {actual paths}

{Continue for each relevant agent...}
```

Only include an agent section if its primary paths exist in the project.

## Step 4: Build registry

Scan for existing components, utilities, hooks, and types. Write `btrs/conventions/registry.md`:

```markdown
---
title: "Component and utility registry"
created: {today's date}
updated: {today's date}
tags:
  - conventions
  - registry
---

# Component and utility registry

Agents MUST check this before creating new code to avoid duplication.

## UI components

| Component | Path | Type |
|-----------|------|------|
{...detected}

## Utilities

| Function | Path | Description |
|----------|------|-------------|
{...detected}

## Hooks

| Hook | Path |
|------|------|
{...detected}

## Types

| Type/Interface | Path |
|---------------|------|
{...detected}
```

## Step 5: Bootstrap conventions

Create a **single** `btrs/conventions/patterns.md` with all convention rules organized by section:

```markdown
---
title: "Project conventions"
created: {today's date}
updated: {today's date}
tags:
  - conventions
---

# Project conventions

## UI
{If frontend detected: naming, imports, component structure, canonical example}

## API
{If backend detected: route structure, error handling, validation, canonical example}

## Database
{If ORM detected: schema location, migration workflow, naming, canonical example}

## Testing
{If test framework detected: file patterns, structure, mocking approach, canonical example}

## Styling
{If CSS framework detected: approach, patterns, canonical example}
```

Only include sections where the corresponding stack was detected.

Also create `btrs/conventions/anti-patterns.md` with stack-specific mistakes to avoid.

## Step 6: Generate config.json

```json
{
  "version": "3.0.0",
  "initialized": "{today's date}",
  "projectName": "{detected}",
  "framework": "{detected}",
  "language": "{detected}",
  "componentLibrary": "{detected or null}",
  "testFramework": "{detected or null}",
  "orm": "{detected or null}",
  "styling": "{detected or null}",
  "stateManagement": "{detected or null}",
  "packageManager": "{detected}",
  "monorepo": false,
  "srcDir": "{detected}"
}
```

## Step 7: Report

```
BTRS vault initialized for {project name}.

Detected stack:
  Framework:    {value}
  Language:     {value}
  Components:   {value or "none"}
  ORM:          {value or "none"}
  Tests:        {value or "none"}

Created:
  btrs/config.json
  btrs/project-map.md
  btrs/status.md
  btrs/conventions/registry.md
  btrs/conventions/patterns.md
  btrs/conventions/anti-patterns.md
  btrs/decisions/ (empty, ready for ADRs)
  btrs/specs/ (empty, ready for specs)

{N} components, {N} utilities, {N} hooks, {N} types cataloged.

Next: run /btrs with any request to start working.
```

## Refresh mode

If `$ARGUMENTS` is "refresh":
1. Read all existing `btrs/` files before modifying.
2. Re-run the full scan.
3. Update only sections that changed.
4. Preserve manually added content.
5. Report what changed vs. already up to date.
