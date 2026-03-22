# BTRS Configuration Reference

Skills and agents read this file first to determine where to write outputs and how the project is structured.

## Project Vault

BTRS stores all project knowledge in `.btrs/` at the project root. This directory is an Obsidian vault that can be opened directly in Obsidian for browsing, search, and graph visualization.

The `.btrs/` directory is always relative to the project root (where `.git/` lives).

## Config File

If `.btrs/config.json` exists, read it for project-specific settings:

```json
{
  "version": "2.0.0",
  "projectName": "my-project",
  "framework": "nextjs",
  "language": "typescript",
  "componentLibrary": "shadcn/ui",
  "testFramework": "vitest",
  "packageManager": "pnpm",
  "monorepo": false,
  "srcDir": "src",
  "agents": {
    "defaultModel": "claude-opus-4-6",
    "maxParallelTasks": 3
  }
}
```

If no config exists, `/btrs-init` will create one by scanning the project.

### Config Fields

| Field | Type | Description |
|-------|------|-------------|
| `version` | string | BTRS plugin version |
| `projectName` | string | Human-readable project name |
| `framework` | string | Primary framework (`nextjs`, `react`, `vue`, `express`, `fastapi`, etc.) |
| `language` | string | Primary language (`typescript`, `python`, `go`, `rust`, etc.) |
| `componentLibrary` | string | UI component library if applicable |
| `testFramework` | string | Primary test framework |
| `packageManager` | string | Package manager (`npm`, `pnpm`, `yarn`, `bun`) |
| `monorepo` | boolean | Whether this is a monorepo |
| `srcDir` | string | Source directory relative to root |
| `agents.defaultModel` | string | Default model for agent tasks |
| `agents.maxParallelTasks` | number | Max parallel agent executions |

## Standard Paths

All paths are relative to the project root.

### Core Structure

```
.btrs/
  config.json              # Project configuration
  index.md                 # Vault home page with navigation
  project-map.md           # High-level architecture overview
```

### Knowledge Areas

```
.btrs/
  specs/                   # Feature specifications
    SPEC-001-auth.md
    SPEC-002-dashboard.md
  todos/                   # Work items and tasks
    TODO-001.md
    TODO-002.md
  decisions/               # Architecture Decision Records
    ADR-001-database.md
    ADR-002-auth-strategy.md
  conventions/             # Project conventions
    ui.md
    api.md
    database.md
    testing.md
  code-map/                # Module documentation
    api/
      auth.md
      users.md
    web/
      components.md
      pages.md
  changelog/               # Daily change logs
    2026-03-21.md
  agents/                  # Agent work outputs
    architect/
    api-engineer/
    web-engineer/
    ...
  templates/               # Local template overrides (optional)
```

### ID Conventions

- Specs: `SPEC-NNN` (zero-padded, e.g., `SPEC-001`)
- Todos: `TODO-NNN` (zero-padded, e.g., `TODO-001`)
- ADRs: `ADR-NNN` (zero-padded, e.g., `ADR-001`)
- Changelog: Date-based (`YYYY-MM-DD`)

### Writing Rules

1. **Always check config first.** Read `.btrs/config.json` before writing any output.
2. **Use standard paths.** Do not invent new top-level directories under `.btrs/`.
3. **Include frontmatter.** Every `.md` file in `.btrs/` must have YAML frontmatter.
4. **Use wiki links.** Link between vault files with `[[path/to/file]]` syntax.
5. **Increment IDs.** When creating a new spec/todo/ADR, scan existing files to find the next available ID.
6. **Never overwrite without reading.** Always read an existing file before modifying it.

### Agent Output Paths

Each agent writes its work output to `.btrs/agents/{agent-name}/`. The agent name matches the slug from the agent registry (e.g., `architect`, `api-engineer`, `web-engineer`).

Agent output files should use the format: `{TASK-ID}-{brief-description}.md`

Example: `.btrs/agents/architect/TASK-001-auth-architecture.md`
