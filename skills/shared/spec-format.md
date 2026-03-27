# Spec Format Reference

Specs are the primary way work flows through the BTRS system. They describe what needs to be built, why, and how success is measured. Agents read specs to understand their assignments; the boss agent creates specs to coordinate work.

## File Location

Specs live in `btrs/specs/` and follow the naming convention: `SPEC-NNN-brief-slug.md`

Example: `btrs/specs/SPEC-003-user-authentication.md`

## ID Assignment

Scan `btrs/specs/` to find the highest existing SPEC number, then increment by 1. Always zero-pad to 3 digits.

## Full Spec Template

```markdown
---
id: SPEC-NNN
title: "Feature Title"
status: draft | in-progress | review | complete | cancelled
priority: low | medium | high | critical
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: agent-slug | user
agents:
  - architect
  - api-engineer
  - web-engineer
tags:
  - feature
  - auth
depends_on:
  - "[[specs/SPEC-001-project-setup]]"
blocks:
  - "[[specs/SPEC-005-admin-dashboard]]"
---

# SPEC-NNN: Feature Title

## Summary

One to three sentences describing what this spec covers and why it matters. This should be understandable by any agent or human reader without additional context.

## Background

Why does this need to exist? What problem does it solve? Link to relevant decisions or prior work.

- Related ADR: [[decisions/ADR-002-auth-strategy]]
- Prior spec: [[specs/SPEC-001-project-setup]]

## Requirements

### Functional Requirements

1. **FR-1**: The system must [specific behavior]
2. **FR-2**: Users can [specific capability]
3. **FR-3**: When [condition], the system [response]

### Non-Functional Requirements

1. **NFR-1**: Response time under [N]ms for [operation]
2. **NFR-2**: Support [N] concurrent users
3. **NFR-3**: Data must be encrypted at rest and in transit

## User Stories

- As a [role], I want to [action] so that [benefit]
- As a [role], I want to [action] so that [benefit]

## Technical Design

### Architecture

High-level approach. Reference the architect's output if available.

See: [[agents/architect/TASK-NNN-design]]

### API Changes

| Method | Path | Description |
|--------|------|-------------|
| POST | /api/auth/login | Authenticate user |
| POST | /api/auth/register | Create account |

### Data Model Changes

Describe schema additions or modifications. Reference the database engineer's output if available.

See: [[agents/database-engineer/TASK-NNN-schema]]

### UI Changes

Describe new pages, components, or modifications. Reference the UI/web engineer's output if available.

## Affected Files

List files that will be created or modified. This helps agents scope their work.

### New Files
- `src/api/auth/login.ts`
- `src/api/auth/register.ts`
- `src/components/LoginForm.tsx`

### Modified Files
- `src/lib/middleware.ts` -- Add auth middleware
- `prisma/schema.prisma` -- Add User model

## Agent Assignments

| Task | Agent | Dependencies | Priority |
|------|-------|-------------|----------|
| Design architecture | architect | None | high |
| Create schema | database-engineer | Architecture design | high |
| Build API endpoints | api-engineer | Schema | high |
| Build login UI | web-engineer | API endpoints | medium |
| Security review | code-security | API + UI complete | high |
| Write tests | qa-test-engineering | API + UI complete | medium |
| Write documentation | documentation | All above | low |

## Acceptance Criteria

These must all pass for the spec to be marked `complete`:

- [ ] Users can register with email and password
- [ ] Users can log in and receive a JWT
- [ ] Invalid credentials return a 401 with error message
- [ ] Passwords are hashed with bcrypt (cost factor 12+)
- [ ] Rate limiting is applied to auth endpoints (10 req/min)
- [ ] All endpoints have integration tests
- [ ] API documentation is complete

## Out of Scope

Explicitly list what this spec does NOT cover to prevent scope creep:

- OAuth/social login (will be a separate spec)
- Two-factor authentication (future enhancement)
- Account recovery flow (SPEC-NNN)

## Open Questions

- [ ] Should we support username-based login in addition to email?
- [ ] What is the token expiry policy? (Proposed: 15min access, 7d refresh)

## References

- External docs, design files, or research links
- [[agents/research/topic-research]] if applicable
```

## Spec Statuses

| Status | Meaning |
|--------|---------|
| `draft` | Being written, not ready for work |
| `in-progress` | Actively being implemented |
| `review` | Implementation complete, under review |
| `complete` | All acceptance criteria met, verified |
| `cancelled` | Abandoned, with reason noted |

## Lightweight Spec (for small changes)

For small features or bug fixes, a lightweight spec is acceptable:

```markdown
---
id: SPEC-NNN
title: "Brief Title"
status: draft
priority: medium
created: YYYY-MM-DD
updated: YYYY-MM-DD
author: user
agents:
  - api-engineer
tags:
  - bugfix
---

# SPEC-NNN: Brief Title

## Summary

What and why in 1-2 sentences.

## Requirements

1. [Requirement]
2. [Requirement]

## Affected Files

- `src/path/to/file.ts` -- Description of change

## Acceptance Criteria

- [ ] [Criterion]
- [ ] [Criterion]
```

## Writing Guidelines

1. **Be specific.** "The API should be fast" is not a requirement. "Response time under 200ms at p95" is.
2. **Link aggressively.** Use wiki links to connect specs to decisions, agent outputs, and other specs.
3. **Scope tightly.** A spec should be completable in 1-5 working sessions. Split larger work.
4. **Include acceptance criteria.** Every spec must have measurable, verifiable acceptance criteria.
5. **List affected files.** This is the most useful section for implementation agents.
6. **Name agents explicitly.** Do not leave agent assignments ambiguous.
