---
name: review
description: >
  Code review, security audit, and tech debt scanning. Use for reviewing changes,
  PRs, auditing code quality, or scanning for technical debt. Auto-detects mode
  from context.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *)
argument-hint: <file, directory, PR number, or "tech debt">
---

# Code Review, Audit & Tech Debt

Auto-detects the review mode based on your request:
- **Code review**: "review this PR", "review src/auth/"
- **Security audit**: "audit security", "scan for vulnerabilities"
- **Tech debt scan**: "scan for tech debt", "find tech debt"

The user's request is: $ARGUMENTS

## Step 0: Load context

1. Read `btrs/config.json` if it exists.
2. Read `skills/shared/rigor-protocol.md`.
3. Read `btrs/conventions/patterns.md` and `btrs/conventions/anti-patterns.md` if they exist.

## Step 1: Detect mode and determine scope

**Mode detection:**
- Keywords "security", "audit", "vulnerability", "OWASP" → **Security audit**
- Keywords "tech debt", "debt", "cleanup", "refactor scan" → **Tech debt scan**
- Everything else → **Code review**

**Scope detection:**
- File or directory argument → review those files
- PR number → `git diff` to identify changed files
- Scope keyword ("api", "auth") → Glob to find relevant files
- If scope is large (>20 files), confirm with user

## Step 2: Read the code

1. Read every file in scope.
2. For modified files, use `git diff` to focus on changes.
3. Read relevant spec if the code implements a tracked feature (check `btrs/specs/`).
4. Read existing tests for the code under review.

## Step 3: Execute review

### Code Review Mode

Check against these dimensions:

1. **Convention compliance** — Compare against `btrs/conventions/` rules for naming, structure, imports, error handling.
2. **Security basics** — Hardcoded secrets, SQL injection, XSS, missing auth checks, overly permissive CORS.
3. **Test coverage** — New code paths lacking tests, stale assertions.
4. **Pattern consistency** — Does it match existing patterns in the same module?
5. **Performance** — N+1 queries, await in loops, unnecessary re-renders.

### Security Audit Mode

Deeper security-focused review:

1. **OWASP Top 10** — Injection, broken auth, sensitive data exposure, XXE, broken access control, misconfig, XSS, deserialization, vulnerable components, logging gaps.
2. **Secrets** — Hardcoded credentials, API keys, tokens.
3. **Dependencies** — Known vulnerabilities in packages.
4. **Input validation** — All external inputs sanitized and validated.
5. **Auth/authz** — Proper authentication and authorization on all sensitive paths.

### Tech Debt Scan Mode

1. **Code smells** — Large files, complex functions, deep nesting, duplicate code.
2. **Missing tests** — Untested critical paths.
3. **Deprecated usage** — Outdated APIs, deprecated dependencies.
4. **TODO/FIXME/HACK** — Existing markers indicating known problems.
5. **Convention violations** — Existing code that doesn't follow current conventions.

## Step 4: Produce the review

```markdown
# {Review Type}: {scope}

## Summary
{1-3 sentence overview}

## Findings

### Critical
{Must fix. Security vulnerabilities, data loss risks, broken functionality.}

### Major
{Should fix. Convention violations, missing error handling, missing tests.}

### Minor
{Nice to fix. Style inconsistencies, verbose code.}

### Positive
{Things done well. Good patterns, thorough tests, clean abstractions.}

## Recommendations
1. {Actionable recommendation with file:line reference}
```

## Step 5: Write output

1. Write review to `btrs/decisions/` if it results in a convention change, otherwise present inline.
2. Present findings to the user.

## Anti-Patterns

- Do not review without reading conventions first.
- Do not produce only negative findings — always include positives.
- Do not give vague feedback. Include file, line, what's wrong, what to do instead.
- Do not suggest rewrites for working code unless conventions demand it.
- Do not review files outside stated scope (note out-of-scope observations separately).
