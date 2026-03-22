---
title: "{{domain}} conventions"
domain: "{{domain}}"
created: {{date}}
updated: {{date}}
author: "{{author}}"
tags:
  - convention
  - "{{domain}}"
---

# {{domain}} conventions

## Overview

<!-- What area does this convention cover? Why do these conventions exist? -->

## File structure

<!-- Where do files for this domain live? What is the directory layout? -->

```
src/{{domain}}/
  index.ts
  types.ts
  ...
```

## Naming conventions

### Files

<!-- How are files named? kebab-case, PascalCase, etc. -->

| Pattern | Example | When to use |
|---------|---------|-------------|
| | | |

### Functions and variables

| Pattern | Example | When to use |
|---------|---------|-------------|
| | | |

### Types and interfaces

| Pattern | Example | When to use |
|---------|---------|-------------|
| | | |

## Code patterns

### Pattern 1: {{name}}

<!-- Describe the pattern and when to use it. Include a code example. -->

**When to use**:

```typescript
// Example
```

### Pattern 2: {{name}}

**When to use**:

```typescript
// Example
```

## Error handling

<!-- How should errors be handled in this domain? -->

```typescript
// Example
```

## Testing conventions

<!-- How should code in this domain be tested? -->

- Test file location:
- Naming:
- Required coverage:

```typescript
// Example test structure
```

## Imports

<!-- Import ordering and grouping rules for this domain. -->

```typescript
// 1. External packages
// 2. Internal shared utilities
// 3. Local module imports
// 4. Type imports
```

## Do and do not

### Do

-

### Do not

-

## Examples

### Good example

```typescript
// Explain why this is correct
```

### Bad example

```typescript
// Explain why this is wrong
```

## Related

- ADR: [[decisions/{{adr}}]]
- Code map: [[code-map/{{module}}]]
- Spec: [[specs/{{spec}}]]

## Changelog

| Date | Change | Author |
|------|--------|--------|
| {{date}} | Initial conventions | {{author}} |
