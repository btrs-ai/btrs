# BTRS Configuration Reference

Skills and agents read this file first to determine where to write outputs and how the project is structured.

## Project Vault

BTRS stores project knowledge in `btrs/` at the project root. This directory is an Obsidian vault that can be opened directly in Obsidian for browsing, search, and graph visualization.

The `btrs/` directory is always relative to the project root (where `.git/` lives).

## Config File

If `btrs/config.json` exists, read it for project-specific settings:

```json
{
  "version": "3.0.0",
  "projectName": "my-project",
  "framework": "nextjs",
  "language": "typescript",
  "componentLibrary": "shadcn/ui",
  "testFramework": "vitest",
  "packageManager": "pnpm",
  "monorepo": false,
  "srcDir": "src"
}
```

If no config exists, `/btrs` will run init automatically on first use.

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

## Standard Paths (v3)

All paths are relative to the project root.

### Directory Structure

```
btrs/
  config.json              # Project configuration
  project-map.md           # Agent scopes and architecture overview
  status.md                # Current work state
  decisions/               # Architecture Decision Records (ADRs)
  specs/                   # Feature specifications + plans (merged)
  conventions/
    registry.md            # Component/utility/hook/type registry
    patterns.md            # ALL convention rules in one file
    anti-patterns.md       # What NOT to do
  .obsidian/               # Obsidian config
```

### What was removed in v3

The following v2 directories are no longer used:
- `knowledge/code-map/` — Registry in `conventions/` is sufficient
- `knowledge/tech-debt/` — Track inline or as decision records
- `work/plans/` — Merged into `specs/`
- `work/todos/` — Use Claude TaskCreate instead
- `work/changelog/` — Git history is the changelog
- `evidence/` (all subdirs) — Verification is inline, debug is session-scoped, reviews go in PRs

### ID Conventions

- Specs: `SPEC-NNN` (zero-padded, e.g., `SPEC-001`)
- ADRs: `ADR-NNN` (zero-padded, e.g., `ADR-001`)

### Writing Rules

1. **Always check config first.** Read `btrs/config.json` before writing output.
2. **Use standard paths.** Do not invent new top-level directories under `btrs/`.
3. **Include frontmatter.** Every `.md` file in `btrs/` must have YAML frontmatter.
4. **Use standard markdown links.** Relative paths for source code references.
5. **Increment IDs.** Scan existing files to find the next available ID.
6. **Never overwrite without reading.** Always read an existing file before modifying it.

### Agent Output Paths

| Output Type | Path |
|-------------|------|
| Architecture decisions | `btrs/decisions/` |
| Feature specs & plans | `btrs/specs/` |
| Conventions & patterns | `btrs/conventions/` |
| Active work status | `btrs/status.md` |
