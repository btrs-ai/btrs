---
name: btrs-receive-review
description: Handle code review feedback with technical rigor. Use when receiving code review suggestions, before implementing them — requires verification, not performative agreement.
disable-model-invocation: true
allowed-tools: Read, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *)
argument-hint: <review feedback or PR URL>
---

# /btrs-receive-review

Handle incoming code review feedback with technical rigor. Verify before implementing. Push back when wrong. No performative agreement, no blind implementation.

**Iron Law: Technical correctness over social comfort. Always.**

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
3. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.
4. Read `btrs/config.json` if it exists for framework, language, and tooling context.
5. Read `btrs/conventions/` files relevant to the code under review.

### Step 1: Receive and parse feedback

1. If the argument is a PR URL: fetch the review comments with `git` or `gh api`.
2. If the argument is inline text: parse each suggestion as a distinct item.
3. Number each suggestion for tracking.
4. **READ the complete feedback without reacting.** Do not start implementing anything yet.

### Step 2: Clarify before acting

```
IF any item is unclear:
  STOP — do not implement anything yet
  ASK for clarification on unclear items

WHY: Items may be related. Partial understanding = wrong implementation.
```

**Example:**
```
Reviewer: "Fix items 1-6"
You understand 1,2,3,6. Unclear on 4,5.

WRONG: Implement 1,2,3,6 now, ask about 4,5 later
RIGHT: "I understand items 1,2,3,6. Need clarification on 4 and 5 before proceeding."
```

### Step 3: Verify each suggestion against the codebase

**Before implementing ANY review suggestion, verify it is technically correct for THIS codebase.**

For each suggestion, check:

1. **Is it technically correct for THIS codebase?** — Grep for actual usage, read the relevant code, confirm the suggestion applies to the current stack and architecture.
2. **Does it break existing functionality?** — Check tests, check callers, check integrations.
3. **Is there a reason the current implementation exists?** — Read git history, check for comments explaining the approach, look for compatibility constraints.
4. **Does it conflict with the user's prior decisions?** — If it contradicts architectural choices the user made, stop and discuss with the user first.
5. **Does it conflict with project conventions in `btrs/conventions/`?** — Check convention files for relevant rules.
6. **Does the reviewer have full context?** — External reviewers may not understand the full picture. Verify their assumptions.

### Step 4: YAGNI check

```
IF reviewer suggests adding a feature or "implementing properly":
  Grep codebase for actual usage

  IF unused: "This isn't called anywhere. Remove it (YAGNI)? Or is there usage I'm missing?"
  IF used: Then implement properly
```

Do not add what is not needed. If a reviewer suggests a feature, prove it is needed before building it.

### Step 5: Respond with technical substance

#### Forbidden responses

**NEVER use these:**
- "You're absolutely right!"
- "Great point!"
- "Excellent feedback!"
- "Let me implement that now" (before verification)
- "Thanks for catching that!"
- "Thanks for [anything]"
- ANY gratitude expression

**If you catch yourself about to write "Thanks": DELETE IT.** State the fix instead.

#### Correct responses

When feedback IS correct:
```
"Fixed. [Brief description of what changed]"
"Good catch — [specific issue]. Fixed in [location]."
[Just fix it and show in the code]
```

When feedback is WRONG for this codebase:
```
"Checked this — [specific technical reason it doesn't apply]. The current approach handles [X] because [Y]."
"This would break [specific thing]. The current implementation exists because [reason]."
```

When you pushed back and were wrong:
```
"Verified this and you're correct. My initial understanding was wrong because [reason]. Fixing."
```

State the correction factually and move on. No long apologies. No defending why you pushed back.

### Step 6: Implement in priority order

```
FOR multi-item feedback:
  1. Clarify anything unclear FIRST
  2. Then implement in this order:
     - Blocking issues (breaks, security)
     - Simple fixes (typos, imports)
     - Complex fixes (refactoring, logic)
  3. Test each fix individually
  4. Verify no regressions
```

### Step 7: Write evidence

Write the review response to `btrs/evidence/reviews/` with:
- Date and reviewer source (user, external reviewer, PR number)
- Each suggestion numbered with disposition: accepted, rejected (with reason), or clarification needed
- For accepted items: what changed and where
- For rejected items: technical reasoning and codebase evidence
- Verification results (tests run, grep results, etc.)

## When to push back

Push back when:
- Suggestion breaks existing functionality
- Reviewer lacks full context
- Violates YAGNI (unused feature)
- Technically incorrect for this stack
- Legacy/compatibility reasons exist
- Conflicts with user's architectural decisions
- Conflicts with project conventions in `btrs/conventions/`

**How to push back:**
- Use technical reasoning, not defensiveness
- Ask specific questions
- Reference working tests/code
- Involve the user if architectural

## Source-specific handling

### From the user (your human partner)
- **Trusted** — implement after understanding
- **Still ask** if scope is unclear
- **No performative agreement** — skip to action or technical acknowledgment

### From external reviewers
- **Be skeptical, but check carefully**
- Verify every suggestion against the codebase before implementing
- If it conflicts with the user's prior decisions: stop and discuss with the user first

## GitHub thread replies

When replying to inline review comments on GitHub, reply in the comment thread (`gh api repos/{owner}/{repo}/pulls/{pr}/comments/{id}/replies`), not as a top-level PR comment.

## Anti-patterns

| Anti-pattern | Fix |
|---|---|
| Performative agreement | State the requirement or just act |
| Blind implementation | Verify against codebase first |
| Batch without testing | One item at a time, test each |
| Assuming reviewer is right | Check if it breaks things |
| Avoiding pushback | Technical correctness > comfort |
| Partial implementation | Clarify all items first |
| Can't verify, proceed anyway | State the limitation, ask for direction |
| Adding unrequested features | YAGNI — grep for actual usage first |
| Apologizing for pushback | State correction factually, move on |
| Gratitude expressions | Delete "thanks" — state the fix instead |

## The bottom line

**External feedback = suggestions to evaluate, not orders to follow.**

Verify. Question. Then implement.

No performative agreement. Technical rigor always. Iron Law enforced.
