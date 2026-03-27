# BTRS Configuration Reference

Skills and agents read this file first to determine where to write outputs and how the project is structured.

## Project Vault

BTRS stores all project knowledge in `btrs/` at the project root. This directory is an Obsidian vault that can be opened directly in Obsidian for browsing, search, and graph visualization.

The `btrs/` directory is always relative to the project root (where `.git/` lives).

## Config File

If `btrs/config.json` exists, read it for project-specific settings:

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

### Directory Structure

```
btrs/
  config.json              # Project configuration
  index.md                 # Vault home page with navigation

  knowledge/               # Long-lived project truth
    conventions/           # Detected patterns, coding standards
    decisions/             # Architecture Decision Records
    code-map/              # Component/utility/hook/constant/type/API registry
      components.md
      utilities.md
      hooks.md
      constants.md
      types.md
      api.md
    tech-debt/             # Tracked debt items

  work/                    # Active work artifacts (lifecycle-managed)
    specs/                 # Feature specifications
    plans/                 # Implementation plans
    todos/                 # Work items and tasks
    changelog/             # Release notes, change records
    status.md              # Active work, blocked items, recent completions

  evidence/                # Audit trail (append-only, prunable)
    reviews/               # Code review reports
    verification/          # Verification evidence logs
    debug/                 # Root cause investigations
    sessions/              # Agent activity summaries

  .obsidian/               # Obsidian config
```

### ID Conventions

- Specs: `SPEC-NNN` (zero-padded, e.g., `SPEC-001`)
- Todos: `TODO-NNN` (zero-padded, e.g., `TODO-001`)
- ADRs: `ADR-NNN` (zero-padded, e.g., `ADR-001`)
- Changelog: Date-based (`YYYY-MM-DD`)

### Writing Rules

1. **Always check config first.** Read `btrs/config.json` before writing any output.
2. **Use standard paths.** Do not invent new top-level directories under `btrs/`.
3. **Include frontmatter.** Every `.md` file in `btrs/` must have YAML frontmatter.
4. **Use standard markdown links.** Use standard markdown links with relative paths for source code references (works in both GitHub and Obsidian).
5. **Increment IDs.** When creating a new spec/todo/ADR, scan existing files to find the next available ID.
6. **Never overwrite without reading.** Always read an existing file before modifying it.

### Agent Output Paths

Agents write to the artifact tier that matches what they produce, not to a personal folder:

| Output Type | Path | Example Agents |
|-------------|------|----------------|
| Architecture decisions | `btrs/knowledge/decisions/` | architect, research |
| Conventions & patterns | `btrs/knowledge/conventions/` | architect, container-ops |
| Code registry updates | `btrs/knowledge/code-map/` | web-engineer, api-engineer |
| Tech debt items | `btrs/knowledge/tech-debt/` | any agent during verification |
| Feature specs | `btrs/work/specs/` | product, architect |
| Implementation plans | `btrs/work/plans/` | boss, architect |
| Task breakdowns | `btrs/work/todos/` | boss |
| Changelog entries | `btrs/work/changelog/` | any agent after implementation |
| Code reviews | `btrs/evidence/reviews/` | qa-test-engineering, code-security |
| Verification reports | `btrs/evidence/verification/` | any agent during self-verification |
| Debug investigations | `btrs/evidence/debug/` | any agent during debugging |
| Session summaries | `btrs/evidence/sessions/` | any agent |
