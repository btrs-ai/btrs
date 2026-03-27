---
name: btrs-sanity-check
description: 10-pass paranoid final sweep before branch completion. Catches regressions, leaks, dead code, debug artifacts, dependency issues, type errors, duplication, and performance problems. Required before btrs-finish.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *)
argument-hint: [branch or directory to check]
---

# /btrs-sanity-check

10-pass paranoid final sweep. Required before branch completion. No exceptions.

## The Iron Law

```
NO BRANCH FINISHES WITHOUT A CLEAN SANITY CHECK
```

The `btrs-finish` skill refuses to proceed if `btrs-sanity-check` hasn't run or has unresolved findings.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `skills/shared/discipline-protocol.md` for the verification Iron Law.
4. Read `skills/shared/workflow-protocol.md` for status display requirements.
5. Read all files in `btrs/conventions/` to build the convention set.

### Step 1: Determine scope

All changes since the branch diverged from main:

```bash
git diff --name-only $(git merge-base HEAD main)..HEAD
```

List all changed files. If the argument is a specific directory, narrow scope to that directory but still run all 10 passes.

### Step 2: Create task items for all 10 passes

Per workflow protocol Rule 3, display pass-by-pass status before beginning execution:

```
[ ] Pass 1 — Regression
[ ] Pass 2 — Leak & Resource
[ ] Pass 3 — Dead Code
[ ] Pass 4 — Debug Artifacts
[ ] Pass 5 — Behavioral Regression
[ ] Pass 6 — Dependency Health
[ ] Pass 7 — Dependency Justification
[ ] Pass 8 — Type Safety
[ ] Pass 9 — Duplication
[ ] Pass 10 — Performance
```

Update status as each pass completes.

### Step 3: Execute the 10 passes

#### Pass 1 — Regression

Run the full test suite. Show the command, exit code, and test counts.

1. Detect the test runner from `package.json` scripts or project config.
2. Run the full suite (e.g., `npm test`, `npx jest`, `npx vitest run`).
3. If a worktree baseline exists in `btrs/evidence/`, diff current results against it.
4. New failures = **STOP**. Do not continue to other passes until regressions are addressed.
5. Record: total tests, passed, failed, skipped.

#### Pass 2 — Leak & Resource

Grep all changed files for resource leak patterns:

1. Missing `.close()` / `.dispose()` / `.destroy()` on acquired resources.
2. `addEventListener` without corresponding `removeEventListener`.
3. `setInterval` without corresponding `clearInterval`.
4. `setTimeout` without `clearTimeout` where cleanup matters (e.g., in components).
5. `subscribe` without corresponding `unsubscribe`.
6. Missing `finally` blocks on resource acquisition (streams, connections, file handles).
7. Open database connections or HTTP clients without cleanup.

Report each finding with file:line reference.

#### Pass 3 — Dead Code

Grep changed files for dead code indicators:

1. Unused imports — imported names not referenced elsewhere in the file.
2. Unused variables — declared but never read.
3. Unreachable code after `return`, `throw`, `break`, or `continue`.
4. Commented-out code blocks (more than 2 consecutive lines).
5. Functions or classes defined but never called or referenced anywhere in the codebase.
6. Unused exported symbols — grep the entire codebase for import references.

#### Pass 4 — Debug Artifacts

Grep changed files for artifacts that should not ship:

1. `console.log` and `console.debug` statements (exclude logging utilities).
2. `debugger` statements.
3. TODO/FIXME comments introduced in this branch (compare against base).
4. Hardcoded `localhost`, `127.0.0.1`, or test-specific URLs/ports.
5. `.only` on test cases (`describe.only`, `it.only`, `test.only`).
6. `@ts-ignore` without an explanatory comment on the same or preceding line.
7. Hardcoded credentials, tokens, or API keys (even fake ones).

#### Pass 5 — Behavioral Regression

For every changed file, read the actual diff and analyze:

1. Could this change break existing behavior not covered by tests?
2. Are there callers of modified functions that expect the old behavior?
3. Are there implicit contracts (return types, error shapes, event formats) that changed?
4. Did default values change in a way that affects existing consumers?
5. Were error handling paths altered in a way that could surface different errors?

**Err on the side of flagging.** If uncertain, flag it. Tests do not cover everything.

#### Pass 6 — Dependency Health

If `package.json` was modified in this branch:

1. List every new dependency added (diff `package.json` against base).
2. For each new dependency:
   - Check last publish date (`npm view {pkg} time --json`). Flag if >12 months.
   - Check for known vulnerabilities (`npm audit`).
   - Check if it duplicates functionality of an existing dependency.
   - Check weekly download count for adoption signal.
3. If no `package.json` changes, mark this pass as N/A with reason.

#### Pass 7 — Dependency Justification

For each new dependency identified in Pass 6:

1. **Usage ratio** — How many of the package's exports are actually used? Flag if <20%.
2. **Native alternative** — Could this be done with built-in Node/browser APIs?
3. **Trivial implementation** — Could the needed functionality be implemented in <20 lines?
4. **Transitive dependency count** — How many transitive deps does it pull in? Flag if >20.
5. **License compatibility** — Is the license compatible with the project?

Each failure is a finding. If no new dependencies, mark as N/A.

#### Pass 8 — Type Safety

If the project uses TypeScript:

1. Run the type checker: `npx tsc --noEmit`.
2. Grep changed files for new `any` type annotations.
3. Grep for new type assertions (`as SomeType`, `<SomeType>`).
4. Grep for new `@ts-ignore` or `@ts-expect-error` directives.
5. Grep for new non-null assertions (`!.` operator).
6. Report type checker errors and new type-safety escapes with file:line.

If not a TypeScript project, mark as N/A with reason.

#### Pass 9 — Duplication

For every new function, constant, type, or component introduced in this branch:

1. Grep the codebase for similar names and signatures.
2. Check `btrs/knowledge/code-map/` if it exists for documented components.
3. Check for functions with identical or near-identical logic.
4. Check for constants that duplicate existing named values.
5. Check for types that overlap significantly with existing type definitions.

Flag potential duplicates with the existing location for comparison.

#### Pass 10 — Performance

Grep changed files for performance anti-patterns:

1. Nested loops iterating over the same collection.
2. `await` inside `for` or `while` loops (should use `Promise.all` or batching).
3. Database queries or API calls inside loops (N+1 pattern).
4. Missing pagination on queries that could return unbounded results.
5. Passing large objects when a subset of fields would suffice.
6. Expensive computations without memoization (`useMemo`, `useCallback`, caching).
7. Synchronous file I/O in request handlers.
8. Unbounded array growth (`.push()` in loops without size limits).

### Step 4: Produce the report

```markdown
# Sanity Check Report

## Summary
- Branch: {branch-name}
- Files scanned: N
- Passes: 10
- Findings: N (X critical, Y warning, Z info)
- **Overall status**: CLEAN | HAS_FINDINGS | BLOCKED

## Pass Results
| # | Pass | Status | Findings |
|---|------|--------|----------|
| 1 | Regression | CLEAN | 47 tests passed, 0 failures |
| 2 | Leak & Resource | CLEAN | No issues |
| 3 | Dead Code | WARNING | 2 unused imports |
| 4 | Debug Artifacts | CLEAN | No issues |
| 5 | Behavioral Regression | WARNING | 1 potential contract change |
| 6 | Dependency Health | N/A | No package.json changes |
| 7 | Dependency Justification | N/A | No new dependencies |
| 8 | Type Safety | CLEAN | 0 type errors, 0 new escapes |
| 9 | Duplication | CLEAN | No duplicates found |
| 10 | Performance | CLEAN | No issues |

## Findings Detail

### [CRITICAL] {finding title}
- **Pass**: {pass number and name}
- **Location**: `file:line`
- **Description**: {what was found}
- **Impact**: {why it matters}

### [WARNING] {finding title}
- **Pass**: {pass number and name}
- **Location**: `file:line`
- **Description**: {what was found}

### [INFO] {finding title}
- **Pass**: {pass number and name}
- **Location**: `file:line`
- **Description**: {what was found}

## Recommendation
{PROCEED / FIX_REQUIRED / BLOCKED}

{If FIX_REQUIRED or BLOCKED, list the specific findings that must be resolved.}
```

**Status definitions:**
- **CLEAN** — All passes green, no findings. Proceed to btrs-finish.
- **HAS_FINDINGS** — Warnings or info-level findings exist. Review recommended but not blocking.
- **BLOCKED** — Critical findings or test failures. btrs-finish cannot proceed.

### Step 5: Write output

1. Present the full report to the user.
2. Write the report to `btrs/evidence/verification/sanity-check-{branch}-{date}.md`.
3. If status is BLOCKED, btrs-finish cannot proceed until findings are resolved and sanity check re-run.

## Anti-patterns

- **Do not skip passes because "the change is small."** Small changes cause regressions too. All 10 passes, every time.
- **Do not mark CLEAN without running actual checks.** Each pass must execute its grep/command and show evidence.
- **Do not auto-fix findings.** This skill reports only. Use `/btrs-implement` to fix issues, then re-run sanity check.
- **Do not ignore Pass 5 because "tests pass."** Tests do not cover everything. Behavioral regression analysis is a human-judgment pass and must not be skipped.
- **Do not run only the passes you think are relevant.** All 10, every time. No exceptions.
- **Do not treat N/A passes as skipped.** Mark them N/A with a reason (e.g., "no TypeScript" or "no new dependencies") so the report is complete.
- **Do not suppress findings to get a CLEAN status.** The purpose of this skill is to catch problems. Suppressing findings defeats the purpose.
