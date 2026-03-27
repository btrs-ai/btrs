# Obsidian Conventions

All files in the `btrs/` vault must follow these conventions to ensure compatibility with Obsidian and consistency across agents.

## Frontmatter

Every markdown file in `btrs/` must begin with YAML frontmatter delimited by `---`:

```yaml
---
id: SPEC-001
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
- Arrays use the indented list format (not inline `[a, b]`).
- Do not include blank lines within the frontmatter block.
- The `title` field must always be present.
- The `status` field must be present on specs, todos, and ADRs.
- The `created` and `updated` fields must always be present.

### Standard Frontmatter Fields

| Field | Required | Type | Description |
|-------|----------|------|-------------|
| `id` | Yes (for indexed types) | string | Unique identifier (SPEC-NNN, TODO-NNN, ADR-NNN) |
| `title` | Yes | string | Human-readable title |
| `status` | Yes (for tracked types) | string | Current status |
| `created` | Yes | date | Creation date |
| `updated` | Yes | date | Last modification date |
| `tags` | No | list | Classification tags |
| `author` | No | string | Agent slug or `user` |
| `priority` | No | string | `low`, `medium`, `high`, `critical` |

## Wiki Links

Use Obsidian wiki link syntax to connect files within the vault:

```markdown
See the architecture decision: [[decisions/ADR-002-auth-strategy]]
This implements [[specs/SPEC-003-user-authentication]]
Built by [[agents/api-engineer/TASK-005-auth-endpoints]]
```

### Rules

- Paths are relative to the `btrs/` vault root.
- Do not include the `.md` extension in wiki links.
- Use the full path from vault root, not just the filename.
- For display text, use the pipe syntax: `[[specs/SPEC-001-setup|Project Setup Spec]]`

### Common Link Patterns

```markdown
# Linking to a spec
[[specs/SPEC-001-user-auth]]

# Linking to a decision
[[decisions/ADR-003-database-choice]]

# Linking to an agent output
[[agents/architect/TASK-001-system-design]]

# Linking to a todo
[[todos/TODO-012]]

# Linking to a convention
[[conventions/api]]

# Linking to a code map entry
[[code-map/api/auth]]

# Display text override
[[specs/SPEC-001-user-auth|the auth spec]]
```

## Tags

Tags provide cross-cutting categorization. Use them in frontmatter and inline.

### Frontmatter Tags

```yaml
tags:
  - feature
  - auth
  - api
```

### Inline Tags

Use sparingly for callouts within body text:

```markdown
This is a #breaking-change that affects the public API.
```

### Standard Tags

| Category | Tags |
|----------|------|
| Type | `feature`, `bugfix`, `refactor`, `chore`, `research`, `spike` |
| Domain | `auth`, `api`, `ui`, `database`, `infra`, `security`, `monitoring` |
| Priority | `critical`, `high-priority` |
| Status | `blocked`, `breaking-change`, `needs-review` |
| Agent | `architect`, `api-engineer`, `web-engineer`, etc. |

### Rules

- Use kebab-case for multi-word tags: `#breaking-change`, not `#breakingChange`.
- Prefer existing tags over inventing new ones.
- Keep the tag count under 8 per file.

## Status Indicators

Use consistent status values across all tracked file types.

### Spec Statuses

| Status | Meaning |
|--------|---------|
| `draft` | Being written, not actionable |
| `in-progress` | Actively being implemented |
| `review` | Implementation done, needs review |
| `complete` | All criteria met and verified |
| `cancelled` | Abandoned with reason documented |

### Todo Statuses

| Status | Meaning |
|--------|---------|
| `pending` | Not started |
| `in-progress` | Currently being worked on |
| `blocked` | Cannot proceed, blocker noted |
| `complete` | Done and verified |
| `cancelled` | No longer needed |

### ADR Statuses

| Status | Meaning |
|--------|---------|
| `proposed` | Under discussion |
| `accepted` | Decision made and active |
| `deprecated` | Superseded by a newer decision |
| `rejected` | Considered and rejected with reason |

## Referencing Code Files

When referring to source code files (outside the vault), use code-formatted paths:

```markdown
The auth middleware is at `src/middleware/auth.ts`.
Modified files: `src/api/routes/users.ts`, `src/lib/db.ts`.
```

Do not use wiki links for files outside `btrs/`. Wiki links are only for vault-internal navigation.

For linking code to vault documentation, use the code-map:

```markdown
See [[code-map/api/auth]] for documentation of `src/api/auth/`.
```

## Headings

- Use ATX-style headings (`#`, `##`, `###`).
- The first heading after frontmatter should be `# Title` (H1).
- Only one H1 per file.
- Do not skip heading levels (no H1 then H3).
- Use sentence case for headings: "User authentication flow", not "User Authentication Flow".

## Callouts

Use Obsidian callout syntax for important notes:

```markdown
> [!warning]
> This endpoint has no rate limiting. See TODO-015.

> [!info]
> This decision supersedes [[decisions/ADR-001-old-approach]].

> [!todo]
> Need to add input validation. Tracked in [[todos/TODO-023]].
```

Standard callout types: `info`, `warning`, `todo`, `tip`, `danger`, `note`, `example`, `question`.

## Checklists

Use standard markdown checklists for acceptance criteria and task lists:

```markdown
- [ ] Incomplete item
- [x] Completed item
```

## Tables

Use standard markdown tables. Align columns for readability:

```markdown
| Column A | Column B | Column C |
|----------|----------|----------|
| Value 1  | Value 2  | Value 3  |
```

## File Naming

- Use kebab-case for filenames: `user-authentication.md`, not `UserAuthentication.md`.
- Prefix indexed files with their ID: `SPEC-001-user-auth.md`, `ADR-003-database.md`.
- Agent output files use task IDs: `TASK-001-auth-design.md`.
- Changelog files use dates: `2026-03-21.md`.
- Convention files use the domain name: `api.md`, `ui.md`, `database.md`.

## Template Usage

Templates are stored in the plugin at `templates/obsidian/`. When creating new vault files, agents should follow the structure defined in the appropriate template. Projects can override templates by placing files in `btrs/templates/`.

Template resolution order:
1. `btrs/templates/{template-name}.md` (project override)
2. Plugin `templates/obsidian/{template-name}.md` (default)
