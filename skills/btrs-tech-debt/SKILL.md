---
name: btrs-tech-debt
description: >
  Scan for tech debt, capture it with fix details, prioritize the backlog, and
  resolve items. Use when the user says "tech debt", "scan for debt", "what needs
  cleanup", "let's address tech debt", "add tech debt", "fix tech debt",
  "what should we clean up", "code quality", "refactor priorities".
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *)
argument-hint: [scan|add <description>|fix [TD-ID]|triage|report]
---

# Tech Debt Skill

Scan, capture, prioritize, and resolve technical debt. Every item gets a detailed
fix spec so it can be addressed later without re-investigation.

## Step 0: Read config

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` for project context.
3. Ensure `btrs/tech-debt/` directory exists. If not, create it with `_index.md`.
4. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
5. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.

## Step 1: Determine mode

`$ARGUMENTS` determines the mode:

### No arguments → Show backlog
Read `btrs/tech-debt/_index.md` and all item files.
Present a prioritized summary:

```
Tech Debt Backlog (12 items)

Critical (fix now):
  TD-001: SQL injection in search endpoint — src/api/search.ts
  TD-003: Hardcoded API keys in test fixtures — tests/fixtures/

High (next sprint):
  TD-002: Duplicate validation logic across 4 endpoints
  TD-007: No error boundaries in React component tree

Medium (when touching these files):
  TD-004: Legacy callback pattern in email service
  TD-005: Missing indexes on orders.user_id and orders.created_at

Low (nice to have):
  TD-006: Console.log statements in 12 files
  TD-008: Unused dependencies: lodash, moment (replaced by date-fns)

Would you like to:
1. Fix the top priority item (TD-001)
2. Fix a specific item (tell me which)
3. Scan for more tech debt
4. Triage — re-prioritize the backlog
```

### `scan` → Deep scan for tech debt
Go to Step 2.

### `add <description>` → Manual capture
Go to Step 5.

### `fix [TD-ID]` → Resolve an item
Go to Step 6. If no ID given, pick the highest priority item.

### `triage` → Re-prioritize backlog
Go to Step 7.

### `report` → Generate tech debt report
Go to Step 8.

## Step 2: Scan for tech debt

Dispatch specialist agents in parallel to scan their domains. Each agent scans
for problems within their scope from `btrs/project-map.md`.

### Scan categories and what to look for:

**Code quality** (dispatch btrs-code-security or handle directly):
- Duplicated code blocks (similar logic in 3+ places)
- Functions over 50 lines
- Files over 500 lines
- Deeply nested conditionals (4+ levels)
- TODO/FIXME/HACK/XXX comments in code
- Console.log / print statements left in production code
- Commented-out code blocks
- Magic numbers and hardcoded strings

**Dependency health** (check package.json / requirements.txt / etc.):
- Outdated dependencies (major versions behind)
- Unused dependencies (installed but not imported)
- Deprecated packages
- Known vulnerabilities (npm audit / pip audit)
- Duplicate packages (same purpose, different libs — e.g., moment + date-fns)

**Pattern violations** (read btrs/conventions/):
- Files that don't follow established conventions
- Components not using the design system
- API endpoints not following the standard pattern
- Tests not following the test conventions
- Hardcoded values that should use design tokens

**Architecture issues** (structural problems):
- Circular dependencies
- Wrong-layer imports (UI importing from API internals)
- Missing error handling on external calls
- Missing input validation on user-facing endpoints
- State management anti-patterns
- Missing database indexes on frequently queried columns

**Testing gaps**:
- Files with no corresponding test
- Test files that are empty or only have skipped tests
- Critical paths without integration tests

### How to scan:

For each category, use targeted Grep/Glob searches:

```bash
# TODO/FIXME/HACK comments
Grep: pattern="TODO|FIXME|HACK|XXX" across src/

# Console.log left in
Grep: pattern="console\.(log|debug|warn)" in src/ (exclude test files)

# Large files
Find files over 500 lines in src/

# Duplicate code patterns
Look for identical or near-identical code blocks

# Unused imports/dependencies
Cross-reference package.json dependencies with actual imports

# Convention violations
Compare against btrs/conventions/ rules
```

## Step 3: Triage scan results

For each finding, classify it:

**Fix now** (critical) — actively causing problems:
- Security vulnerabilities
- Data loss risks
- Broken functionality
- Performance issues affecting users

**Fix soon** (high) — will cause problems:
- Missing error handling on critical paths
- Outdated dependencies with known CVEs
- Pattern violations in frequently-modified files
- Missing tests on critical business logic

**Fix when touching** (medium) — address when you're already in the file:
- Legacy patterns in stable code
- Missing indexes (not yet causing slowness)
- Code duplication (not yet causing inconsistency)
- Commented-out code

**Nice to have** (low) — no urgency:
- Console.log cleanup
- Unused dependencies
- Minor style inconsistencies
- TODO comments that are really "would be nice"

## Step 4: Create tech debt items

For EACH finding, create a file at `btrs/tech-debt/TD-{NNN}.md`:

```markdown
---
type: tech-debt
id: TD-001
title: SQL injection risk in search endpoint
status: open
priority: critical
effort: small
category: security
found-by: btrs-code-security
found-during: scan
created: 2026-03-21
affects:
  - src/api/search.ts
  - src/api/products.ts
tags: [security, api, input-validation]
---

# TD-001: SQL injection risk in search endpoint

## Problem
The search endpoint at `src/api/search.ts:47` constructs a SQL query by
string concatenation with user input. The `q` parameter is passed directly
into the WHERE clause without sanitization.

```typescript
// Current (VULNERABLE):
const results = await db.query(`SELECT * FROM products WHERE name LIKE '%${q}%'`);
```

## Impact
- **Severity**: Critical — allows arbitrary SQL execution
- **Blast radius**: Products table, potentially full database
- **User-facing**: Yes — search is a public endpoint

## How to Fix

### Step 1: Use parameterized query
Replace string concatenation with parameterized query:
```typescript
// Fixed:
const results = await db.query(
  'SELECT * FROM products WHERE name LIKE $1',
  [`%${q}%`]
);
```

### Step 2: Add input validation
Add zod validation for the `q` parameter:
```typescript
const searchSchema = z.object({
  q: z.string().min(1).max(200).trim()
});
```

### Step 3: Check other endpoints
Grep for similar patterns: `db.query(\`.*\$\{` across all API files.

## Affected Files
- `src/api/search.ts` — primary fix
- `src/api/products.ts` — similar pattern found

## Related
- [[conventions/api]] — input validation rules
- [[code-map/api-layer#search]] — endpoint documentation

## Effort Estimate
**Small** — 30 minutes. Parameterize the query, add validation, verify.
```

### ID assignment:
- Read `btrs/tech-debt/_index.md` for the last used ID
- Increment: TD-001, TD-002, etc.
- Update `_index.md` with the new item

### Update the index:
`btrs/tech-debt/_index.md` is the master list:

```markdown
---
type: index
scope: tech-debt
updated: 2026-03-21
---

# Tech Debt Backlog

## Summary
- **Total**: 12 items
- **Critical**: 2 | **High**: 3 | **Medium**: 5 | **Low**: 2
- **Estimated total effort**: ~18 hours

## Items

| ID | Title | Priority | Effort | Status | Category |
|----|-------|----------|--------|--------|----------|
| [[tech-debt/TD-001]] | SQL injection in search | critical | small | open | security |
| [[tech-debt/TD-002]] | Duplicate validation logic | high | medium | open | code-quality |
| ...
```

## Step 5: Manual capture (add mode)

When the user says `/btrs-tech-debt add <description>`:

1. Ask clarifying questions if the description is vague:
   - What file(s) are affected?
   - What's the impact?
   - Do you know how to fix it?
2. Scan the mentioned files to understand the problem
3. Create the tech debt item file with full fix instructions
4. Assign priority based on the description and code analysis
5. Update `_index.md`
6. Confirm: "Created TD-{NNN}: {title} (priority: {level})"

## Step 6: Fix mode

When the user says `/btrs-tech-debt fix [TD-ID]`:

1. If no ID: pick the highest priority open item
2. Read the tech debt item file for fix instructions
3. Read `btrs/conventions/` for relevant conventions
4. Follow the "How to Fix" steps in the item
5. Run the self-verification protocol
6. Update the tech debt item:
   - Set status: `resolved`
   - Add resolution date
   - Add resolution summary
   - Add verification evidence
7. Update `_index.md`
8. Update `btrs/changelog/`
9. Report what was fixed

If the fix reveals NEW tech debt, capture it as a new item.

## Step 7: Triage mode

When the user says `/btrs-tech-debt triage`:

1. Read all open items from `btrs/tech-debt/`
2. For each item, re-evaluate:
   - Has the affected code changed?
   - Is the item still relevant?
   - Has priority shifted? (e.g., that endpoint now gets 10x traffic)
   - Should any medium items be promoted to high?
3. Present the re-prioritized list
4. Ask user to confirm or adjust
5. Update item files and index

## Step 8: Report mode

Generate a tech debt report for stakeholders:

```markdown
# Tech Debt Report — 2026-03-21

## Health Score: 7.2/10

## Trend
- Last scan: 15 items → This scan: 12 items (3 resolved)
- New items found: 2
- Net change: -1 (improving)

## Critical Items (requires immediate attention)
- TD-001: SQL injection in search — SECURITY RISK
- TD-003: Hardcoded API keys in test fixtures

## Debt by Category
- Security: 2 items (1 critical, 1 high)
- Code quality: 4 items (1 high, 3 medium)
- Dependencies: 3 items (1 high, 2 low)
- Testing: 2 items (2 medium)
- Architecture: 1 item (1 medium)

## Recommended Actions
1. Fix TD-001 immediately (SQL injection)
2. Fix TD-003 before next deploy (exposed keys)
3. Address TD-002 during next API sprint (validation duplication)
```

Write to `btrs/tech-debt/reports/{date}-report.md`

## Proactive Integration

This skill doesn't just run when called. Other agents should capture tech debt
during their normal work:

- **During /btrs-review**: Flag tech debt items found during code review
- **During /btrs-audit**: Create tech debt items for security findings
- **During /btrs-implement**: If you encounter tech debt while building, capture it
- **During /btrs-health**: Include tech debt metrics in health report
- **During /btrs-init scan**: Flag obvious tech debt during project scan

Agents capture tech debt by writing to `btrs/tech-debt/TD-{NNN}.md` and updating
the index. They should note `found-during: {what they were doing}` in the frontmatter.

## Anti-Patterns

- Do NOT create vague items like "refactor the API" — be specific about WHAT and HOW
- Do NOT mark everything as critical — use the triage criteria honestly
- Do NOT create items for style preferences — only for real problems
- Do NOT skip the "How to Fix" section — that's the whole point
- Do NOT create duplicate items — search existing items first
