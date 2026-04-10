---
name: fix
description: >
  Systematic debugging and bug fixing. Use for any bug, test failure, error,
  or unexpected behavior. Enforces root cause investigation before fixes.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *), Bash(node *)
argument-hint: <bug description or error message>
---

# Systematic Debugging

**Core principle:** ALWAYS find root cause before attempting fixes. Symptom fixes are failure.

The user's request is: $ARGUMENTS

## Step 0: Load context

1. Read `btrs/config.json` if it exists.
2. Read `skills/shared/rigor-protocol.md` — debugging always uses at least **standard** rigor.
3. State: "Rigor: {standard|strict} — {reason}"

## Phase 1: Root Cause Investigation

**BEFORE attempting ANY fix:**

1. **Read error messages carefully** — stack traces, line numbers, error codes. Don't skip past them.
2. **Reproduce consistently** — Can you trigger it reliably? What are the exact steps?
3. **Check recent changes** — `git diff`, recent commits, new dependencies, config changes.
4. **Trace data flow** — Where does the bad value originate? Keep tracing backward until you find the source.
5. **Gather evidence in multi-component systems** — Log at each component boundary to identify WHERE it breaks before WHY.

## Phase 2: Pattern Analysis

1. **Find working examples** — Locate similar working code in the codebase.
2. **Compare against references** — If implementing a pattern, read the reference COMPLETELY.
3. **Identify differences** — What's different between working and broken?
4. **Understand dependencies** — What other components, settings, or environment does this need?

## Phase 3: Hypothesis and Testing

1. **Form single hypothesis** — "I think X is the root cause because Y." Be specific.
2. **Test minimally** — The SMALLEST possible change to test hypothesis. One variable at a time.
3. **Verify** — Did it work? Yes: proceed to Phase 3.5. No: form NEW hypothesis (don't pile fixes).

## Phase 3.5: Contributing Factor Sweep

Before implementing a fix:

1. **List at least 3 alternative explanations** — even unlikely ones.
2. **Rule each out with evidence** — not intuition. "Probably not X" doesn't count.
3. **Check for co-factors** — Multiple things wrong simultaneously?
4. **Check adjacent code** — Same bug pattern repeated nearby?
5. **State conclusion:** "Root cause: X (evidence: ...). Ruled out: Y (evidence: ...), Z (evidence: ...)."

If you cannot rule out alternatives with evidence, return to Phase 1.

## Phase 4: Implementation

1. **Write failing test** — Reproduce the bug in an automated test (RED).
2. **Implement single fix** — Address root cause, not symptom. ONE change at a time.
3. **Verify fix:**
   - Run the failing test — does it pass now? (GREEN)
   - Run the full related test suite — no regressions?
   - State evidence: "Ran [command], output was [result], confirming [claim]."
   - **NEVER say "that should fix it" — prove it did.**
4. **If fix doesn't work:**
   - Count attempts. If < 3: return to Phase 1 with new information.
   - **If >= 3: STOP.** You are guessing, not debugging. Discuss architecture with the user.

## The 3-Attempt Rule

After 3 failed fix attempts: **STOP.** Question your assumptions:
- Is this pattern fundamentally sound?
- Are we sticking with it through inertia?
- Should we refactor rather than patch?

Discuss with the user before attempting a fourth fix.

## Red Flags — STOP and return to Phase 1

If you catch yourself thinking:
- "Quick fix for now, investigate later"
- "Just try changing X and see"
- "It's probably X, let me fix that"
- "One more fix attempt" (after 2+ tries)
- Each fix reveals a new problem elsewhere

## Anti-Patterns

- Do not propose fixes in Phase 1. Investigation first.
- Do not skip Phase 2. Find working examples first.
- Do not test multiple hypotheses at once.
- Do not continue past 3 failed fixes without user discussion.
- Do not trust "it works now" without understanding why.
