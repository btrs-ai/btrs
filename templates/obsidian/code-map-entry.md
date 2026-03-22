---
title: "{{module-name}}"
module_path: "{{path}}"
created: {{date}}
updated: {{date}}
owner: "{{agent}}"
tags: []
---

# {{module-name}}

## Overview

<!-- What does this module do? One to three sentences. -->

## Location

```
{{path}}/
```

## Public API

<!-- List exported functions, classes, components, or endpoints that other modules depend on. -->

### Functions

| Export | Signature | Description |
|--------|-----------|-------------|
| `functionName` | `(arg: Type) => ReturnType` | What it does |

### Components

<!-- For UI modules. -->

| Component | Props | Description |
|-----------|-------|-------------|
| `ComponentName` | `{ prop: Type }` | What it renders |

### Types

<!-- Key types exported by this module. -->

| Type | Description |
|------|-------------|
| `TypeName` | What it represents |

## Internal structure

```
{{path}}/
  index.ts          -- Public exports
  types.ts          -- Type definitions
  utils.ts          -- Internal helpers
  __tests__/        -- Test files
```

## Dependencies

### Depends on

<!-- Other modules this module imports from. -->

- `src/lib/database` -- Database connection
- `src/lib/auth` -- Authentication utilities

### Depended on by

<!-- Other modules that import from this module. -->

- `src/api/routes/users` -- Uses user service functions
- `src/web/pages/dashboard` -- Uses dashboard components

## Key patterns

<!-- Conventions or patterns specific to this module. -->

-

## Configuration

<!-- Environment variables, config keys, or feature flags this module reads. -->

| Key | Type | Description |
|-----|------|-------------|
| `DATABASE_URL` | env | Database connection string |

## Related documentation

- Spec: [[specs/{{spec}}]]
- Convention: [[conventions/{{convention}}]]
- ADR: [[decisions/{{adr}}]]
