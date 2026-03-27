---
name: btrs-request-review
description: Dispatch a structured code review with precisely crafted context. Use after completing implementation, before merging, or when you want an independent quality assessment.
disable-model-invocation: true
allowed-tools: Agent, Read, Grep, Glob, Bash(git *)
argument-hint: [branch name or commit range]
---

# /btrs-request-review

Dispatch `btrs-qa-test-engineering` subagent to catch issues before they cascade. The reviewer gets precisely crafted context for evaluation -- never your session's history. This keeps the reviewer focused on the work product, not your thought process, and preserves your own context for continued work.

**Core principle:** Review early, review often. Never self-review when you can dispatch an independent reviewer.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
3. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.
4. Read `btrs/config.json` if it exists for framework, language, and tooling context.

### Step 1: When to request review

**Mandatory:**
- After each task in btrs-execute
- After completing major features
- Before merge to main

**Optional but valuable:**
- When stuck (fresh perspective)
- Before refactoring (baseline check)
- After fixing a complex bug

### Step 2: Get git SHAs

Determine the commit range to review.

```bash
# Get the merge-base with main (where this branch diverged)
BASE_SHA=$(git merge-base main HEAD)
# Current HEAD
HEAD_SHA=$(git rev-parse HEAD)
```

If a branch name or commit range was provided as an argument, use that instead:
- Branch name: `BASE_SHA=$(git merge-base main {branch})`, `HEAD_SHA=$(git rev-parse {branch})`
- Commit range (e.g., `abc123..def456`): parse directly

### Step 3: Gather context

Before dispatching the reviewer, assemble everything they need:

1. **What was implemented** -- summarize the work in 2-5 sentences. What feature, fix, or change was made? Why?
2. **Requirements/spec** -- read the relevant spec from `btrs/specs/` or plan from `btrs/plans/`. Extract the acceptance criteria or task requirements.
3. **Git diff range** -- the BASE_SHA..HEAD_SHA range for the reviewer to inspect.
4. **Changed files** -- run `git diff --stat {BASE_SHA}..{HEAD_SHA}` to list affected files.
5. **Related conventions** -- note which `btrs/conventions/` files apply to the changed code.

### Step 4: Dispatch the review agent

Use the Agent tool with `btrs-qa-test-engineering` type. Construct a structured prompt containing:

```markdown
# Code Review Request

## What Was Implemented
{2-5 sentence summary of the work}

## Requirements
{Acceptance criteria or task requirements from the spec/plan}

## Git Range
**Base:** {BASE_SHA}
**Head:** {HEAD_SHA}

```bash
git diff --stat {BASE_SHA}..{HEAD_SHA}
git diff {BASE_SHA}..{HEAD_SHA}
```

## Review Checklist

### Plan Alignment
- Does the implementation match the spec/plan requirements?
- Are all acceptance criteria satisfied?
- Is there scope creep beyond what was planned?

### Code Quality
- Clean separation of concerns?
- Proper error handling?
- Type safety (if applicable)?
- DRY principle followed?
- Edge cases handled?

### Architecture
- Sound design decisions?
- Scalability considerations?
- Performance implications?
- Security concerns?

### Testing
- Tests actually test logic (not just mocks)?
- Edge cases covered?
- Integration tests where needed?
- All tests passing?

### Documentation
- Code-map entries still accurate?
- JSDoc/docstrings match behavior?
- Breaking changes documented?
- No stale or misleading comments?

## Output Format

### Strengths
[What is well done? Be specific with file:line references.]

### Issues

#### Critical (Must Fix)
[Bugs, security issues, data loss risks, broken functionality]

#### Important (Should Fix)
[Architecture problems, missing features, poor error handling, test gaps]

#### Minor (Nice to Have)
[Code style, optimization opportunities, documentation improvements]

**For each issue:**
- File:line reference
- What is wrong
- Why it matters
- How to fix (if not obvious)

### Assessment
**Ready to merge?** [Yes / No / With fixes]
**Reasoning:** [1-2 sentence technical assessment]
```

### Step 5: Act on findings by severity

**Critical** -- fix immediately before proceeding. These are blockers.

**Important** -- fix before merging. If running btrs-execute, fix before moving to the next task. If running btrs-finish, fix before completing the branch.

**Minor/Suggestions** -- note for later. Do not let these block progress. If the suggestion reveals a pattern worth addressing, write it to `btrs/knowledge/tech-debt/` for future cleanup.

**If the reviewer is wrong:**
- Push back with technical reasoning
- Show code or tests that prove the implementation is correct
- Request clarification on ambiguous feedback

### Step 6: Write review report

Write the review output to an evidence file:

```
btrs/evidence/reviews/review-{branch}-{date}.md
```

Where:
- `{branch}` is the current branch name (sanitized for filename)
- `{date}` is today's date in YYYY-MM-DD format

The report should include:
- The review request context (what was reviewed, git range)
- The full reviewer output (strengths, issues, assessment)
- Actions taken (which issues were fixed, which were deferred)

### Step 7: Update tracking

1. If critical or important issues were found and fixed, commit the fixes.
2. If minor issues were deferred, add them to `btrs/knowledge/tech-debt/` if they represent recurring patterns.
3. Update `btrs/changelog/{today}.md` with a line item about this review.

## Anti-patterns

- **Do not skip review because "changes are small."** Small changes can introduce subtle bugs. The review cost is low; the bug cost is high.
- **Do not self-review instead of dispatching an independent reviewer.** The whole point is a fresh perspective with isolated context. You cannot review your own blind spots.
- **Do not ignore Critical findings.** Critical means the code is broken, insecure, or risks data loss. No exceptions.
- **Do not treat all findings as equal severity.** Minor issues should not block progress. Critical issues must block progress. Conflating them wastes time or ships bugs.
- **Do not pass your session history to the reviewer.** Construct a clean, focused prompt with only the information the reviewer needs.
- **Do not argue with valid technical feedback.** If the reviewer identifies a real issue, fix it. Save pushback for genuinely incorrect assessments.

## Integration with Other Skills

**btrs-execute:** Request review after each task completes. The execute skill's two-stage review (spec compliance then code quality) should use this skill for the code quality stage.

**btrs-finish:** Request a final review before completing a development branch.

**btrs-implement:** Request review after implementing a single task or feature.

**btrs-tdd:** Request review after the red-green-refactor cycle completes to catch issues the tests might not cover.
