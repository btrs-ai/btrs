---
name: btrs-review
description: Review code, architecture, or pull requests for quality, conventions, and security. Use when reviewing changes, auditing code quality, or validating implementations.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob, Bash(git *)
argument-hint: <file, directory, PR number, or scope>
---

# /btrs-review

Code and architecture review skill. Checks convention compliance, pattern consistency, security basics, test coverage, and documentation accuracy. Produces a structured review with actionable findings.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `.btrs/conventions/` files relevant to the code under review.
4. Read `skills/shared/verification-protocol.md` for the verification checklist.

### Step 1: Determine review scope

1. If the argument is a file or directory: review those files.
2. If the argument is a PR number: use `git diff` to identify changed files and review them.
3. If the argument is a scope keyword (e.g., "api", "auth"): Glob to find all relevant files.
4. List all files in scope and confirm with the user if the set is large (>20 files).

### Step 2: Read the code

1. Read every file in the review scope.
2. For modified files, use `git diff` to focus on the changes.
3. Read the relevant spec if the code implements a tracked feature (check `.btrs/specs/`).
4. Read existing tests for the code under review.

### Step 3: Check convention compliance

1. Compare code against `.btrs/conventions/` rules for:
   - Naming conventions (files, variables, functions, components)
   - File structure and organization
   - Import patterns and dependency rules
   - Error handling patterns
   - Logging and observability patterns
2. Compare against existing patterns in the same module (consistency within module).

### Step 4: Check security basics

1. Scan for common security issues:
   - Hardcoded secrets, API keys, or credentials
   - SQL injection vectors (raw queries without parameterization)
   - XSS vectors (unescaped user input in templates)
   - Missing input validation
   - Missing authentication or authorization checks
   - Overly permissive CORS or CSP
2. Check dependency versions for known vulnerabilities if package files changed.

### Step 5: Check test coverage

1. Identify which functions, endpoints, or components have corresponding tests.
2. Note any new code paths that lack tests.
3. Check that existing tests still pass conceptually (do the assertions match the current behavior?).

### Step 6: Check documentation accuracy

1. If code-map entries exist for the reviewed modules, verify they are still accurate.
2. Check that JSDoc, docstrings, or type annotations match actual behavior.
3. Note stale or misleading comments.

### Step 7: Produce the review

Format the output as:

```markdown
# Code Review: {scope}

## Summary
{1-3 sentence overview of the review}

## Findings

### Critical
{Issues that must be fixed before merge. Security vulnerabilities, data loss risks, broken functionality.}

### Major
{Issues that should be fixed. Convention violations, missing error handling, missing tests.}

### Minor
{Issues that would be nice to fix. Style inconsistencies, verbose code, missing docs.}

### Positive
{Things done well. Good patterns, thorough tests, clean abstractions.}

## Convention Compliance
- [PASS/FAIL] {specific convention check with file:line reference}

## Security
- [PASS/FAIL] {specific security check}

## Test Coverage
- {module}: {covered/not covered}

## Recommendations
1. {Actionable recommendation}
2. {Actionable recommendation}
```

### Step 8: Write output to vault

1. Write the review to `.btrs/agents/{reviewer-slug}/review-{slug}.md` with proper frontmatter.
2. If critical or major findings exist, create TODO items in `.btrs/todos/` for each.
3. Update `.btrs/changelog/{today}.md` with a line item about this review.

## Anti-patterns

- **Do not review without reading conventions first.** Your review must be grounded in the project's actual rules, not generic opinions.
- **Do not produce only negative findings.** Always include a "Positive" section. Reinforcing good patterns is as valuable as catching bad ones.
- **Do not give vague feedback.** "This could be better" is not actionable. Include file, line, what is wrong, and what to do instead.
- **Do not suggest rewrites for working code unless conventions demand it.** Stability has value.
- **Do not review files outside the stated scope.** If you spot issues elsewhere, note them as out-of-scope observations.
- **Do not invent conventions.** If no convention exists for a pattern, say so rather than asserting one.
