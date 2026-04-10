# Obsidian Conventions

All files in the `btrs/` vault must follow these conventions.

## Frontmatter

Every markdown file must begin with YAML frontmatter:

```yaml
---
title: "User Authentication"
status: draft
created: 2026-03-21
updated: 2026-03-21
tags:
  - feature
  - auth
---
```

### Rules

- Use lowercase keys.
- Dates use `YYYY-MM-DD` format.
- Strings with special characters must be quoted.
- Arrays use the indented list format.
- The `title` field must always be present.
- The `status` field must be present on specs and ADRs.
- The `created` and `updated` fields must always be present.

### Standard Fields

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `id` | Yes (for specs/ADRs) | string | Unique identifier (SPEC-NNN, ADR-NNN) |
| `title` | Yes | string | Human-readable title |
| `status` | Yes (for specs/ADRs) | string | Current status |
| `created` | Yes | date | Creation date |
| `updated` | Yes | date | Last modification date |
| `tags` | No | list | Classification tags |
| `priority` | No | string | `low`, `medium`, `high`, `critical` |

### Standard Status Values

- `draft` — Initial state
- `in-progress` — Active work
- `review` — Awaiting review
- `complete` — Done
- `cancelled` — No longer needed

## Links

Use standard markdown links with relative paths:

```markdown
See [ADR-002](decisions/ADR-002-auth-strategy.md)
This implements [SPEC-003](specs/SPEC-003-user-authentication.md)
```

## File Naming

- Use `kebab-case` for all filenames.
- Prefix with ID where applicable: `SPEC-001-auth.md`, `ADR-002-database.md`.
- No spaces in filenames.

## Vault Structure (v3)

```
btrs/
  config.json
  project-map.md
  status.md
  decisions/           # ADRs only
  specs/               # Feature specs + plans
  conventions/
    registry.md        # Component/utility registry
    patterns.md        # Convention rules
    anti-patterns.md   # What NOT to do
  .obsidian/
```
