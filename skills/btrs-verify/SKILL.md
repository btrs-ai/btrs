---
name: btrs-verify
description: Automated pattern and convention compliance check. Catches hardcoded values, duplicate components, and anti-pattern violations. Use after implementation or as a quality gate.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *)
argument-hint: <files or directories to verify>
---

# /btrs-verify

Automated pattern compliance check. Greps for anti-patterns (hardcoded colors, inline styles, duplicate components, arbitrary values), checks convention adherence, and reports violations with file:line references.

## The Iron Law

```
NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE
```

**The 5-Step Gate (skip any step = lying, not verifying):**
1. **IDENTIFY** — What command proves this claim?
2. **RUN** — Execute the full command. Fresh. In this session. Not recalled from earlier.
3. **READ** — Read the full output. Check the exit code. Count failures.
4. **VERIFY** — Does the output actually confirm the claim?
5. **CLAIM** — Only now may you state it.

**Forbidden words in success claims:** "should", "probably", "seems to", "I believe", "likely".

**Forbidden behavior:** Expressing satisfaction before verification. "Great!", "Done!", "All good!" before running the actual command means you are claiming without evidence.

### Red Flags — STOP and Verify

If you catch yourself:
- Using "should" or "probably" about test results
- Saying "Done!" before running verification
- Trusting a previous run instead of running fresh
- Trusting an agent's success report without independent verification
- Saying "tests pass" without showing the actual output
- Skipping verification because "the change is trivial"

**ALL of these mean: STOP. Run the verification command. Show the evidence.**

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `skills/shared/verification-protocol.md` for the five-check verification process.
4. Read all files in `btrs/conventions/` to build the rule set.
5. Read `skills/shared/discipline-protocol.md` for the verification Iron Law.
6. Read `skills/shared/workflow-protocol.md` for status display requirements.

### Step 1: Determine verification scope

1. If the argument is a file or directory: verify those files.
2. If no argument: verify all recently changed files (`git diff --name-only HEAD~1`).
3. List all files in scope.

### Step 2: Build the rule set

From `btrs/conventions/` files, extract verifiable rules. Common checks include:

**UI conventions** (if ui.md exists):
- Hardcoded color values (hex, rgb, hsl outside of theme/token files)
- Inline styles in components
- Arbitrary Tailwind values (e.g., `w-[347px]` instead of design tokens)
- Components not using the design system
- Missing accessibility attributes (alt, aria-label, role)

**API conventions** (if api.md exists):
- Inconsistent error response formats
- Missing input validation
- Non-RESTful naming
- Missing rate limiting or auth middleware

**Database conventions** (if database.md exists):
- Raw SQL outside of designated query files
- Missing indexes on foreign keys
- N+1 query patterns

**General conventions**:
- Console.log statements left in production code
- Hardcoded URLs or environment-specific values
- Unused imports
- Files exceeding convention-specified line limits

### Step 3: Run the checks

For each rule, Grep the files in scope:

1. Search for the anti-pattern.
2. Record every match with file path and line number.
3. Classify each violation by severity:
   - **Error**: Must fix. Breaks conventions or introduces risk.
   - **Warning**: Should fix. Deviates from conventions but not dangerous.
   - **Info**: Consider fixing. Minor style issue.

### Step 4: Check for duplicate components

1. Glob for component files in scope.
2. Compare component names and purposes against the code-map and existing components.
3. Flag any new component that duplicates an existing one's functionality.

### Step 5: Run the five-check protocol

If verifying a specific implementation (not a general scan), run the full protocol from `skills/shared/verification-protocol.md`:

1. File existence verification
2. Pattern compliance (already done in step 3)
3. Functional claim verification
4. Integration point verification
5. Completeness check against spec

### Step 6: Produce the report

```markdown
# Verification Report: {scope}

## Summary
- Files scanned: N
- Errors: N
- Warnings: N
- Info: N
- **Overall status**: PASS | PARTIAL | FAIL

### Verification Evidence

For each claim verified by running a command, show:

```
Command: <exact command run>
Exit code: <code>
Output: <relevant output lines>
✓ or ✗ Claim: "<the claim being verified>"
```

## Errors
- `src/components/Card.tsx:14` -- Hardcoded color `#ff0000`, use theme token `destructive`
- `src/api/users.ts:42` -- Missing input validation on `req.body.email`

## Warnings
- `src/utils/format.ts:8` -- Console.log left in production code
- `src/pages/Dashboard.tsx:67` -- Inline style, use className

## Info
- `src/lib/auth.ts:23` -- Consider extracting magic number `86400` to named constant

## Duplicate Components
- None found (or list)

## Convention Coverage
| Convention File | Rules Checked | Violations |
|----------------|---------------|------------|
| ui.md | N | N |
| api.md | N | N |
```

### Step 7: Write output

1. Present the report to the user.
2. If run as part of a larger workflow, write to `btrs/agents/{agent-slug}/verify-{slug}.md`.
3. Update `btrs/changelog/{today}.md` if writing to vault.

## Anti-patterns

- **Do not report violations for files outside the scope.** Scope discipline prevents overwhelming reports.
- **Do not flag patterns that have no backing convention.** If no convention prohibits it, it is not a violation.
- **Do not auto-fix violations.** This skill reports only. Use `/btrs-implement` to fix.
- **Do not treat warnings as errors.** Severity levels exist for a reason. Only errors block a PASS status.
- **Do not skip the convention read step.** Running checks without reading conventions produces irrelevant noise.
- **Do not ignore test files.** Test code should also follow conventions, though some rules may be relaxed (e.g., console.log in tests may be acceptable).
