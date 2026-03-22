# Verification Protocol

Every agent must follow this protocol before reporting a task as complete. No exceptions. The purpose is to ensure that claims made in agent output are backed by evidence, and that delivered work actually functions as described.

## When to Verify

Run verification:
- Before marking any task as `complete`
- Before writing a final agent output file
- When the `/btrs-verify` skill is invoked directly

## The Five Checks

### 1. File Existence Verification

Every file claimed to be created or modified must exist on disk.

**Process:**
- List all files mentioned in your output as created or modified
- Verify each file exists using file read or glob
- For new files: confirm they exist and are non-empty
- For modified files: confirm the described changes are present

**Evidence format:**
```markdown
### File Existence
- [PASS] `src/api/auth/login.ts` -- exists, 47 lines
- [PASS] `src/api/auth/register.ts` -- exists, 62 lines
- [FAIL] `src/middleware/auth.ts` -- file not found
```

### 2. Pattern Compliance

All code must follow the project's established conventions.

**Process:**
- Read `.btrs/conventions/` for relevant convention files (ui.md, api.md, database.md, etc.)
- Read `.btrs/config.json` for framework and tool settings
- Check that new code matches existing patterns in the codebase
- Verify naming conventions, file structure, import patterns

**Evidence format:**
```markdown
### Pattern Compliance
- [PASS] API route follows RESTful conventions per `.btrs/conventions/api.md`
- [PASS] Component uses project's naming convention (PascalCase)
- [WARN] No convention file found for this area -- matched existing patterns in `src/api/`
- [FAIL] Uses `axios` but project convention specifies `fetch` wrapper
```

### 3. Functional Claim Verification

Every functional claim in the output must be testable and tested.

**Process:**
- List every claim made in the output (e.g., "endpoint returns 401 for invalid credentials")
- For each claim, describe how it was verified
- Run tests if a test framework is configured
- For claims that cannot be automatically verified, note them as `MANUAL`

**Evidence format:**
```markdown
### Functional Claims
- [PASS] "POST /api/auth/login returns JWT on valid credentials" -- verified by reading handler logic, JWT signing present at line 34
- [PASS] "Passwords hashed with bcrypt" -- verified bcrypt.hash call at line 18 with cost factor 12
- [MANUAL] "Rate limiting at 10 req/min" -- requires runtime test, middleware configured at line 8
- [FAIL] "Error messages are user-friendly" -- handler returns raw error objects, not formatted messages
```

### 4. Integration Point Verification

All connections between components must be checked.

**Process:**
- Verify imports resolve to existing files
- Verify API calls match actual endpoint signatures
- Verify database queries match the actual schema
- Verify environment variables are documented
- Verify types are consistent across boundaries

**Evidence format:**
```markdown
### Integration Points
- [PASS] `import { hashPassword } from '@/lib/auth'` -- function exists and is exported
- [PASS] Frontend calls `POST /api/auth/login` with `{ email, password }` -- matches handler signature
- [FAIL] `import { UserRole } from '@/types'` -- UserRole type not found in types file
- [WARN] Uses `DATABASE_URL` env var -- not documented in `.env.example`
```

### 5. Completeness Check

All requirements from the spec or task description must be addressed.

**Process:**
- Read the original spec or task description
- Check each requirement and acceptance criterion
- Mark each as addressed or not addressed
- Note any requirements that were intentionally deferred (with reason)

**Evidence format:**
```markdown
### Completeness
- [PASS] "Users can register with email and password" -- implemented in register.ts
- [PASS] "Invalid credentials return 401" -- implemented in login.ts line 28
- [SKIP] "Rate limiting on auth endpoints" -- deferred to TASK-008 per boss agent decision
- [FAIL] "All endpoints have integration tests" -- tests not written
```

## Verification Report Format

The complete verification report is included in the agent output file:

```markdown
## Verification Report

**Verified by**: {agent-slug}
**Date**: YYYY-MM-DD
**Overall status**: PASS | PARTIAL | FAIL

### Summary
- Total checks: N
- Passed: N
- Failed: N
- Warnings: N
- Manual: N
- Skipped: N

### File Existence
[results]

### Pattern Compliance
[results]

### Functional Claims
[results]

### Integration Points
[results]

### Completeness
[results]

### Failures and Remediation
[For each FAIL, describe what went wrong and what needs to happen to fix it]
```

## What To Do When Checks Fail

### During Self-Verification (before reporting complete)

1. **Fix the issue** if it is within your scope and you can fix it correctly.
2. **Re-verify** after fixing -- do not assume the fix worked.
3. **If you cannot fix it**, report the task as `partial` with the verification report attached. Clearly describe what failed and what is needed.

### During External Verification (/btrs-verify)

1. **Document all failures** in the verification report.
2. **Create TODO items** for each failure that needs follow-up work.
3. **Assign the TODOs** to the appropriate agent.
4. **Do not mark the spec as complete** if there are any FAIL results (WARN and MANUAL are acceptable).

## Verification Levels

| Level | When to use | Checks required |
|-------|-------------|-----------------|
| `quick` | Small changes, single file | File existence + functional claims |
| `standard` | Normal tasks | All five checks |
| `thorough` | Critical paths, security, data | All five checks + run test suite + manual review recommendations |

## Proactive Tech Debt Capture (MANDATORY)

During ANY task — not just scans or reviews — if you encounter tech debt, capture it.

### What counts as tech debt:
- Code that works but is fragile, duplicated, or hard to maintain
- Missing error handling, validation, or tests on important paths
- Outdated dependencies or deprecated API usage
- Convention violations in existing code (not code you just wrote)
- TODO/FIXME/HACK comments indicating known problems
- Performance issues visible from code structure (N+1 queries, missing indexes)
- Security weaknesses that aren't critical enough to block your current task

### What to do when you find it:
1. **Don't stop your current task** — note it and keep going
2. After completing your task, write tech debt items to `.btrs/tech-debt/TD-{NNN}.md`
3. Use the template from `.btrs/templates/tech-debt.md`
4. Include specific fix instructions (not just "refactor this")
5. Set `found-during: {your-current-task-type}` in the frontmatter
6. Update `.btrs/tech-debt/_index.md` with the new item(s)
7. Mention captured tech debt in your agent output: "Found N tech debt items — see [[tech-debt/TD-NNN]]"

### Triage during capture:
- **Critical**: Fix now — blocks or actively harms (flag to orchestrator)
- **High**: Fix soon — will cause problems in near future
- **Medium**: Fix when touching — address when someone's already in this file
- **Low**: Nice to have — no urgency

If you find something **critical** during your work, flag it immediately to the
orchestrator in your output rather than silently capturing it.

## Rules

1. **Never skip verification.** Even for "obvious" changes.
2. **Evidence is required.** Do not write `[PASS]` without describing how you verified it.
3. **Be honest about failures.** A `PARTIAL` report with known issues is far more valuable than a false `PASS`.
4. **Verify your own work.** Do not rely on another agent to catch your mistakes.
5. **Re-verify after fixes.** A fix that is not re-verified is not verified.
6. **Include the report.** The verification report must be in the agent output file, not just mentioned.
7. **Capture tech debt proactively.** If you see it, log it — even if it's not part of your task.
