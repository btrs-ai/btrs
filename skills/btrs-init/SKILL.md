---
name: btrs-init
description: >
  Scan a project and create the .btrs/ Obsidian vault with conventions, registry,
  code-map, and project-map. Run automatically on first /btrs use or manually to
  refresh. Use when starting a new project, onboarding to an existing project,
  or refreshing project knowledge.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(ls *)
argument-hint: [refresh]
---

You are the BTRS project scanner. Your job is to analyze a project's structure, detect its tech stack, and create the `.btrs/` Obsidian vault with conventions, registry, code-map, and project-map. Be thorough in detection but concise in output.

Mode: If `$ARGUMENTS` is "refresh", update existing `.btrs/` files rather than creating from scratch. Read each file before overwriting.

## Step 0: Read config reference

Read `~/.claude/skills/btrs-shared/config.md` for standard paths and structure. Read `~/.claude/skills/btrs-shared/obsidian-conventions.md` for formatting rules. These define the vault structure you must create.

## Step 1: Scan project structure

Detect the project's technology stack by reading files and globbing for patterns. Run these checks:

### 1a. Package manifest and language

Read whichever exists first: `package.json`, `pyproject.toml`, `Cargo.toml`, `go.mod`, `pom.xml`, `build.gradle`, `composer.json`, `Gemfile`.

From the manifest, extract:
- **Project name**
- **Language**: typescript, javascript, python, go, rust, java, php, ruby
- **Package manager**: npm, pnpm, yarn, bun, pip, poetry, cargo, go modules
- **Scripts**: build, dev, test, lint commands
- **All dependencies** (both regular and dev)

### 1b. Language config

Read whichever exists: `tsconfig.json`, `jsconfig.json`, `.babelrc`, `setup.cfg`, `pyproject.toml` [tool sections].

Extract:
- **Strict mode** (TypeScript)
- **Path aliases** (e.g., `@/` maps to `src/`)
- **Target/module settings**

### 1c. Framework detection

Check dependencies and file patterns to detect the primary framework:

| Framework | Detection signal |
|-----------|-----------------|
| Next.js | `next` in dependencies, `next.config.*` exists, `app/` or `pages/` directory |
| React (CRA/Vite) | `react` in deps without `next`, `vite.config.*` or `react-scripts` |
| Vue | `vue` in deps, `nuxt.config.*` or `vite.config.*` with vue plugin |
| Nuxt | `nuxt` in deps |
| SvelteKit | `@sveltejs/kit` in deps |
| Express | `express` in deps, no frontend framework |
| Fastify | `fastify` in deps |
| NestJS | `@nestjs/core` in deps |
| FastAPI | `fastapi` in requirements/pyproject |
| Django | `django` in requirements/pyproject |
| Rails | `rails` in Gemfile |
| Gin/Echo/Fiber | Check go.mod imports |

### 1d. Library detection

Scan dependencies for:

| Category | Libraries to detect |
|----------|-------------------|
| Component library | `@shadcn/ui` or `components.json`, `@mui/material`, `@chakra-ui/react`, `@mantine/core`, `antd`, `@radix-ui/*` |
| Styling | `tailwindcss`, `styled-components`, `@emotion/react`, `sass`, `postcss`, CSS modules (check config) |
| ORM/Database | `prisma`, `drizzle-orm`, `typeorm`, `sequelize`, `mongoose`, `@supabase/supabase-js`, `knex` |
| Test framework | `vitest`, `jest`, `@testing-library/*`, `cypress`, `playwright`, `mocha`, `pytest` |
| State management | `zustand`, `@reduxjs/toolkit`, `jotai`, `recoil`, `pinia`, `vuex` |
| Auth | `next-auth`, `@clerk/nextjs`, `@supabase/auth-helpers-nextjs`, `passport`, `lucia` |
| API layer | `@trpc/server`, `graphql`, `@apollo/server`, `express`, `hono` |
| Validation | `zod`, `yup`, `joi`, `class-validator`, `valibot` |
| Monorepo | `turbo.json`, `nx.json`, `lerna.json`, `pnpm-workspace.yaml` |

### 1e. Directory structure scan

Use Glob to find these patterns (skip `node_modules`, `.git`, `dist`, `build`, `.next`, `__pycache__`):

```
src/**/          -- source root shape
app/**/          -- Next.js app router or similar
pages/**/        -- pages-based routing
components/**/   -- component directories
lib/**/          -- shared utilities
utils/**/        -- utility functions
hooks/**/        -- React hooks
api/**/          -- API routes or handlers
server/**/       -- server-side code
routes/**/       -- route definitions
middleware/**/   -- middleware
prisma/**/       -- Prisma schema and migrations
drizzle/**/      -- Drizzle config
tests/**/ or __tests__/**/  -- test directories
cypress/**/      -- Cypress tests
e2e/**/          -- E2E tests
public/**/       -- static assets
styles/**/       -- style files
types/**/        -- type definitions
config/**/       -- configuration
infra/**/        -- infrastructure
docker*          -- Docker files
.github/**/      -- GitHub workflows
```

Record every directory that exists. These become the agent scope map.

## Step 2: Create .btrs/ vault structure

Create the following directory structure and files. For refresh mode, read existing files first and merge/update rather than overwrite.

### 2a. Obsidian config

Write `.btrs/.obsidian/app.json`:
```json
{
  "showLineNumber": true,
  "strictLineBreaks": false,
  "readableLineLength": true
}
```

### 2b. Vault index

Write `.btrs/index.md`:
```markdown
---
title: "BTRS Vault"
created: {today's date}
updated: {today's date}
tags:
  - index
---

# {project name} -- BTRS vault

Welcome to the BTRS knowledge vault for **{project name}**.

## Navigation

- [[project-map|Project map]] -- Agent scopes and architecture overview
- [[specs/_index|Specs]] -- Feature specifications
- [[todos/_index|Todos]] -- Work items
- [[decisions/_index|Decisions]] -- Architecture Decision Records
- [[conventions/_index|Conventions]] -- Project conventions and patterns
- [[code-map/_index|Code map]] -- Module documentation
- [[agents/_index|Agents]] -- Agent work outputs
- [[changelog/_index|Changelog]] -- Daily change logs

## Quick reference

- **Framework**: {detected framework}
- **Language**: {detected language}
- **Component library**: {detected or "none"}
- **Test framework**: {detected or "none"}
- **ORM**: {detected or "none"}
```

### 2c. Section index files

Create a minimal `_index.md` in each section directory. Each follows this pattern:

```markdown
---
title: "{Section name}"
created: {today's date}
updated: {today's date}
tags:
  - index
---

# {Section name}

{One sentence describing what lives here.}
```

Create index files for: `specs`, `todos`, `decisions`, `agents`, `code-map`, `conventions`, `changelog`, `templates`.

## Step 3: Generate project map

Write `.btrs/project-map.md`. Map the detected directories to agent scopes.

Use this structure -- only include agents whose scope directories actually exist in the project:

```markdown
---
title: "Project map"
created: {today's date}
updated: {today's date}
tags:
  - architecture
  - index
---

# Project map

Overview of agent ownership and file scopes for **{project name}**.

## Stack summary

| Aspect | Value |
|--------|-------|
| Framework | {value} |
| Language | {value} |
| Component library | {value or "none"} |
| Styling | {value or "none"} |
| ORM | {value or "none"} |
| Test framework | {value or "none"} |
| State management | {value or "none"} |
| Package manager | {value} |
| Monorepo | {yes/no} |

## Agent scopes

### btrs-web-engineer
- **primary**: {actual paths found, e.g., src/app/**, src/pages/**, src/components/**}
- **shared**: {e.g., src/types/**, src/lib/**, src/hooks/**}
- **tests**: {e.g., tests/components/**, __tests__/pages/**}

### btrs-api-engineer
- **primary**: {e.g., src/api/**, src/server/**, src/routes/**}
- **shared**: {e.g., src/types/**, src/lib/**}
- **tests**: {e.g., tests/api/**, __tests__/api/**}

{Continue for each relevant agent...}
```

Mapping rules:
- **btrs-web-engineer**: `app/`, `pages/`, `components/`, `hooks/`, frontend routes
- **btrs-api-engineer**: `api/`, `server/`, `routes/`, `middleware/`, backend handlers
- **btrs-ui-engineer**: `components/ui/`, design system files, theme config, Storybook
- **btrs-database-engineer**: `prisma/`, `drizzle/`, `migrations/`, `schema/`, seed files
- **btrs-qa-test-engineering**: `tests/`, `__tests__/`, `cypress/`, `e2e/`, test config files
- **btrs-cicd-ops**: `.github/workflows/`, CI config files
- **btrs-container-ops**: `Dockerfile*`, `docker-compose*`, `k8s/`, `helm/`
- **btrs-cloud-ops**: `infra/`, `terraform/`, `cdk/`, `pulumi/`, serverless config
- **btrs-monitoring-ops**: monitoring config, dashboard definitions, alert rules
- **btrs-code-security**: all source code (read access), security config files
- **btrs-documentation**: `docs/`, `README*`, documentation files
- **Shared paths** (accessible by multiple agents): `src/types/`, `src/lib/`, `src/utils/`, `src/config/`

Only include an agent section if at least one of its primary paths exists in the project.

## Step 4: Build component and utility registry

Scan the project for existing components, utilities, hooks, and types. Write the results to `.btrs/conventions/registry.md`.

### 4a. Components

Glob for files in component directories (e.g., `src/components/**/*.{tsx,jsx,vue,svelte}`). For each file found:
- Extract the filename (component name)
- Record the path
- If there is a `components/ui/` directory (shadcn-style), flag those as "primitive/UI" components

### 4b. Utilities and lib

Glob for files in `lib/`, `utils/`, `helpers/` directories. For each file:
- Read the file and extract exported function/class names using Grep for `export` statements
- Record function names and file paths

### 4c. Hooks (React/Vue)

Glob for files matching `use*.{ts,tsx,js,jsx}` in hooks directories. Record hook names and paths.

### 4d. Types

Glob for `.d.ts` files and files in `types/` directories. Record type/interface names and paths.

### 4e. Write the registry

Write `.btrs/conventions/registry.md`:

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

Existing components, utilities, hooks, and types in this project. Agents MUST check this registry before creating new code to avoid duplication.

## UI components

| Component | Path | Type |
|-----------|------|------|
| Button | src/components/ui/button.tsx | primitive |
| Card | src/components/ui/card.tsx | primitive |
| LoginForm | src/components/auth/LoginForm.tsx | feature |
{...actual detected components}

## Utilities

| Function | Path | Description |
|----------|------|-------------|
| cn | src/lib/utils.ts | Class name merger (clsx + twMerge) |
{...actual detected utilities}

## Hooks

| Hook | Path |
|------|------|
| useAuth | src/hooks/useAuth.ts |
{...actual detected hooks}

## Types

| Type/Interface | Path |
|---------------|------|
| User | src/types/user.ts |
{...actual detected types}
```

If a category has no entries, include the heading with "None detected" and a note that items should be added as they are created.

## Step 5: Bootstrap conventions

Based on the detected stack, create convention files. Each convention file gives agents concrete rules for writing code in this project.

### General approach for each convention file:

1. Detect which libraries/tools are actually in use (from Step 1).
2. Find a canonical example file in the project (a well-written existing file that agents should imitate).
3. Write rules that reference the specific library versions and patterns found.
4. Include anti-patterns specific to the detected stack.

### 5a. UI conventions (if frontend detected)

Write `.btrs/conventions/ui.md`:

- Component file naming convention (detected from existing files)
- Import patterns (detected from existing files)
- Component structure pattern (detected from a canonical component)
- State management approach (detected library or local state)
- Which UI primitives exist in the registry (reference `[[conventions/registry]]`)
- Canonical example: point to a well-structured existing component file

### 5b. API conventions (if backend detected)

Write `.btrs/conventions/api.md`:

- Route/handler file structure
- Error handling pattern
- Validation approach (detected library: zod, yup, etc.)
- Authentication/middleware pattern
- Response format conventions
- Canonical example: point to a well-structured existing route file

### 5c. Database conventions (if ORM detected)

Write `.btrs/conventions/database.md`:

- ORM name and version
- Schema file location
- Migration workflow
- Naming conventions for tables/columns
- Query patterns (raw vs ORM methods)
- Canonical example: point to existing schema or query file

### 5d. Testing conventions (if test framework detected)

Write `.btrs/conventions/testing.md`:

- Test framework name and version
- Test file location pattern (co-located vs separate directory)
- Naming convention for test files
- Test structure pattern (describe/it, test blocks)
- Mocking approach
- Canonical example: point to a well-written existing test file

### 5e. Styling conventions (if CSS framework detected)

Write `.btrs/conventions/styling.md`:

- Styling approach (Tailwind, CSS modules, styled-components, etc.)
- Class naming or styling patterns
- Theme/token usage
- Responsive breakpoint approach
- Canonical example: point to a well-styled existing component

### 5f. Anti-patterns

Write `.btrs/conventions/anti-patterns.md`:

Based on the detected stack, list common mistakes agents must avoid. Examples:

- **If Next.js**: Do not use `useEffect` for data fetching in server components. Do not mix App Router and Pages Router patterns.
- **If Tailwind**: Do not create custom CSS when a Tailwind utility exists. Do not use `@apply` excessively.
- **If Prisma**: Do not use raw SQL when the Prisma client supports the query. Do not forget to run `prisma generate` after schema changes.
- **If shadcn/ui**: Do not recreate primitives that exist in `components/ui/`. Always check the registry first.
- **If TypeScript**: Do not use `any`. Do not use non-null assertions (`!`) without a comment explaining why.
- **If React**: Do not mutate state directly. Do not use index as key in dynamic lists.

### 5g. Conventions index

Write `.btrs/conventions/_index.md` listing all created convention files with wiki links.

### Convention file format

Every convention file must follow this structure:

```markdown
---
title: "{Domain} conventions"
created: {today's date}
updated: {today's date}
tags:
  - conventions
  - {domain}
---

# {Domain} conventions

## Stack

{Library/framework name and version detected from package manifest.}

## File patterns

{Where files of this type live and how they are named.}

## Structure

{The canonical structure for files of this type. Show a real pattern detected from the project, not a generic template.}

## Rules

1. {Concrete rule derived from detected patterns}
2. {Concrete rule derived from detected patterns}
...

## Canonical examples

- `{path/to/good/file}` -- {why this is a good example}

## Anti-patterns

- Do NOT {specific anti-pattern for this stack}
- Do NOT {specific anti-pattern for this stack}

## See also

- [[conventions/registry|Component and utility registry]]
- [[conventions/anti-patterns|Anti-patterns]]
```

## Step 6: Generate initial code-map

Create code-map entries for each major area of the codebase that was detected. Code-map files document what a module does, its key files, and its relationships.

Only create entries for areas where source files actually exist.

### Code-map file format

```markdown
---
title: "{Area name}"
created: {today's date}
updated: {today's date}
tags:
  - code-map
  - {area}
---

# {Area name}

## Overview

{1-2 sentences on what this area of the codebase does.}

## Key files

| File | Purpose |
|------|---------|
| `{path}` | {brief description} |

## Dependencies

- Depends on: {other code-map areas or external services}
- Depended on by: {other code-map areas}

## Owner agent

Primary: **{agent-slug}**
```

Create code-map entries as appropriate for the project. Common entries:
- `.btrs/code-map/frontend.md` -- if `app/`, `pages/`, or `components/` exist
- `.btrs/code-map/api-layer.md` -- if `api/`, `server/`, or `routes/` exist
- `.btrs/code-map/database-layer.md` -- if ORM/schema files exist
- `.btrs/code-map/infrastructure.md` -- if `infra/`, Docker, or CI files exist
- `.btrs/code-map/shared.md` -- if `lib/`, `utils/`, or `types/` exist

## Step 7: Generate config.json

Write `.btrs/config.json` with detected values:

```json
{
  "version": "2.0.0",
  "projectName": "{detected from package manifest}",
  "framework": "{detected framework}",
  "language": "{detected language}",
  "componentLibrary": "{detected or null}",
  "testFramework": "{detected or null}",
  "orm": "{detected or null}",
  "styling": "{detected or null}",
  "stateManagement": "{detected or null}",
  "packageManager": "{detected}",
  "monorepo": false,
  "srcDir": "{detected source directory}",
  "agents": {
    "defaultModel": "claude-opus-4-6",
    "maxParallelTasks": 3
  }
}
```

## Step 8: Report to user

After creating all files, report what was found and created:

```
BTRS vault initialized for {project name}.

Detected stack:
  Framework:    {value}
  Language:     {value}
  Components:   {value or "none detected"}
  Styling:      {value or "none detected"}
  ORM:          {value or "none detected"}
  Tests:        {value or "none detected"}

Created:
  .btrs/config.json
  .btrs/index.md
  .btrs/project-map.md
  .btrs/conventions/registry.md
  .btrs/conventions/{list each created}
  .btrs/code-map/{list each created}
  {etc.}

{N} components, {N} utilities, {N} hooks, and {N} types cataloged in the registry.

You can browse the vault by opening .btrs/ in Obsidian.
Next: run /btrs with any request to start working.
```

## Refresh mode

If `$ARGUMENTS` is "refresh":

1. Read all existing `.btrs/` files before modifying them.
2. Re-run the full scan (Steps 1 through 6).
3. For each file that already exists:
   - Compare detected values with existing content.
   - Update only the sections that changed.
   - Preserve any manually added content (look for sections not generated by init).
   - Update the `updated` date in frontmatter.
4. For new files that should exist but do not (e.g., a new convention area was detected): create them.
5. For registry.md: re-scan and rebuild, but preserve any manually added "description" fields.
6. Report what changed vs. what was already up to date.
