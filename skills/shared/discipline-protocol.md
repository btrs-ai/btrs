# Discipline Protocol

This protocol is mandatory for all implementation work. It is read at Step 0 by every skill and injected into every agent dispatch. Violating the letter of these rules is violating the spirit of these rules.

---

## 1. Test-Driven Development

**Iron Law:** `NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST`

### The Deletion Mandate

Wrote production code before writing a failing test? **Delete it.** No exceptions. Do not keep it as reference. Do not adapt it. Do not look at it. Delete means delete.

The rationale is simple: code written without a failing test was written without a specification. It encodes assumptions, not requirements. Keeping it — even as "reference" — anchors you to those assumptions and defeats the purpose of TDD.

### The RED-GREEN-REFACTOR Cycle

1. **RED:** Write one minimal failing test. Verify it fails. Verify it fails *for the right reason* (expected behavior is absent, not a syntax error or import failure).
2. **GREEN:** Write the simplest code that makes the test pass. Nothing more. No "while I'm here" additions. No anticipating the next test.
3. **REFACTOR:** Clean up while green. Improve naming, extract duplication, simplify structure. Do not add new behavior during refactor — the tests should stay green throughout.
4. **REPEAT.**

### Edge Cases

- **Test passes immediately?** You are testing existing behavior, not new behavior. Fix the test so it specifies something the code does not yet do.
- **Test errors instead of failing?** Fix the error (missing import, typo, wrong path). Re-run until the test *fails correctly* — a proper assertion failure, not a crash.

### When to Use TDD

Always. New features, bug fixes, refactoring. The cycle applies to all production code changes.

**Exceptions:** Only with explicit user permission. The user says "skip tests" or "no tests needed" — then you may proceed without TDD. Implied permission does not count.

### Common Rationalizations

| Excuse | Why It's Wrong |
|---|---|
| "Too simple to test" | Simple code has the longest lifespan and the most dependents. It *especially* needs tests. |
| "I'll test after" | You won't. And if you do, you'll write tests that confirm what you built rather than what was specified. |
| "Already manually tested" | Manual testing is not repeatable, not documented, and not part of the CI pipeline. It proves nothing to the next developer. |
| "Deleting X hours of work is wasteful" | Keeping untested code is technical debt with compound interest. The hours are already spent. The question is whether you pay now or pay more later. |
| "TDD will slow me down" | TDD slows down typing. It speeds up delivery. The difference is debugging time, rework time, and regression time — none of which you are accounting for. |
| "Just this once" | There is no "just this once." Every exception becomes precedent. The discipline exists precisely because the temptation is constant. |

### Full Skill Reference

See `btrs-tdd` for the full TDD skill with worked examples and language-specific patterns.

---

## 2. Verification

**Iron Law:** `NO COMPLETION CLAIMS WITHOUT FRESH VERIFICATION EVIDENCE`

### The 5-Step Gate

Every claim that something "works," "passes," or "is complete" must pass through all five steps in order:

1. **IDENTIFY** the command that produces evidence (test runner, build command, linter, curl request, etc.)
2. **RUN** it fresh. Not from memory. Not from a previous run. Fresh.
3. **READ** the full output. Not the first line. Not the summary. The full output.
4. **VERIFY** the output confirms the specific claim you are about to make.
5. **CLAIM** only then.

Skip any step and you are lying, not verifying. Step 2 is not optional because "it passed last time." Step 3 is not optional because "the exit code was 0." Step 4 is not optional because "it usually works."

### Forbidden Words

Never use these in completion claims:

- "should"
- "probably"
- "seems to"
- "I believe"
- "likely"

These words mean you have not verified. Replace them with evidence or replace the claim with "I have not verified this."

### Forbidden Behavior

Do not express satisfaction before verification:

- "Great!" — before running the tests
- "Done!" — before confirming the output
- "All good!" — before reading the results
- "That should fix it!" — before proving it did

Premature celebration is a completion claim without evidence. It triggers the same failure mode: you stop investigating because you already announced success.

### Full Skill Reference

See `btrs-verify` for the full verification skill with checklists and evidence templates.

---

## 3. Debugging

**Iron Law:** `NO FIXES WITHOUT ROOT CAUSE INVESTIGATION FIRST`

### The 4 Phases

Do not skip ahead. Each phase gates the next.

#### Phase 1: Root Cause Investigation

Reproduce the failure. Read the error. Read the stack trace. Read the relevant source code. Understand *what* is happening before forming any theory about *why*.

#### Phase 2: Pattern Analysis

Compare the failure to known patterns. Is this a common error type (null reference, off-by-one, race condition, stale cache)? Have similar failures occurred elsewhere in this codebase? What changed recently that could explain the timing?

#### Phase 3: Hypothesis and Testing

Form a specific, falsifiable hypothesis: "The failure occurs because X, and if I change Y, the failure will stop and test Z will pass." Test the hypothesis. If it fails, return to Phase 1 with the new information.

#### Phase 4: Implementation

Only now write the fix. The fix should address the root cause identified in Phase 1, not the symptom. Apply TDD: write a test that reproduces the bug (RED), fix the bug (GREEN), clean up (REFACTOR).

### The 3-Attempt Rule

After 3 failed fix attempts: **STOP.** You are not debugging anymore — you are guessing. Step back and question your assumptions about the architecture. Discuss with the user before attempting a fourth fix.

### Full Skill Reference

See `btrs-debug` for the full debugging skill with companion techniques (bisection, minimal reproduction, logging strategy).

---

## 4. Dependency Justification

**Before adding any package**, justify it against three alternatives in this order:

### Alternative 1: Native/Built-in API

Does the language or runtime already provide this functionality?

| Instead of | Use |
|---|---|
| `axios` | `fetch` (built into Node 18+, all modern browsers) |
| `uuid` | `crypto.randomUUID()` (built into Node 19+, all modern browsers) |
| `lodash.cloneDeep` | `structuredClone()` (built into Node 17+, all modern browsers) |

If a native API exists and covers your use case, the dependency is not justified.

### Alternative 2: Write It Yourself

Can you solve this with a 5-20 line utility function? If so, write the function (with a test) instead of adding a dependency. A small, tested utility you own is better than a large dependency you don't.

### Alternative 3: Existing Project Package

Is there already a package in the project that provides this functionality? Do not add `dayjs` if `date-fns` is already installed. Do not add `lodash` if `ramda` is already installed. Check `package.json` (or equivalent) first.

### When a Dependency Is Justified

A dependency is the last resort, not the first. When you do add one, check:

- **Maintenance:** Is it actively maintained? When was the last release?
- **Vulnerabilities:** Does `npm audit` (or equivalent) flag it?
- **Transitive dependencies:** How many sub-dependencies does it pull in?
- **Usage ratio:** Are you using 5% of a large library? Consider a smaller alternative or importing only what you need.

---

## 5. Duplication Prevention

**Before creating any new function, constant, type, or component:**

1. **Check the code-map registry** at `btrs/knowledge/code-map/`. The registry indexes existing utilities, components, types, and constants across the project.
2. **Grep the codebase.** The registry is a snapshot, not a complete picture. Search for similar function names, type names, and string patterns.
3. **If something does 80% of what you need, extend it.** Do not create a parallel implementation. Add the missing 20% to the existing code (with tests) rather than duplicating the 80% you already have.

Creating a duplicate is faster in the short term and more expensive in every other term. Two implementations means two places to update, two places to test, and an eventual inconsistency that becomes a bug.

---

## 6. Performance Awareness

**Before writing any loop that touches a database, API, or large collection:** state the expected time complexity. If worse than O(n), justify why.

### Patterns to Avoid

- **`await` in loops:** Each iteration waits for the previous one. Use `Promise.all()`, batch APIs, or pipeline patterns instead.
- **Queries in loops (N+1):** One query to get a list, then one query per item. Use joins, batch fetches, or eager loading instead.
- **Nested loops over the same collection:** O(n^2) when O(n) with a Set or Map lookup is available.
- **Fetching full objects when a subset would do:** `SELECT *` when you need two columns. Loading entire documents when you need one field. Over-fetching wastes bandwidth, memory, and time.

State the complexity. If it's acceptable, proceed. If it's not, fix it before it ships.

---

## 7. Escape Clause

The user explicitly requests skipping any rule in this protocol? Acknowledge the request and proceed. The user always takes precedence over this document.

The key word is **explicitly**. Not by implication. Not by omission. Not because "they probably don't care about tests for this." The user says "skip TDD" or "don't worry about tests" or "just write the code" — that is explicit. The user says "implement this feature" without mentioning tests — that is not permission to skip TDD. That is a normal request that follows the normal protocol.

When you invoke the escape clause, state it: "Skipping [rule] per your request." This keeps the decision visible and reversible.
