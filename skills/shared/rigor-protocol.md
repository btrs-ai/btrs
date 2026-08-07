# Rigor Protocol

This protocol replaces always-on strict enforcement with risk-aware auto-detection. Read at Step 0 by every skill. The goal is to apply the right level of discipline for the task at hand — saving tokens on trivial work while maintaining full rigor for critical code.

---

## Rigor Levels

### Quick Mode

**Triggers:**
- Config-only changes (`.json`, `.yaml`, `.env`, `.toml`, `.ini`)
- Documentation changes (`.md`, `README`, comments-only edits)
- Single-file edits under 50 lines
- Style/formatting changes
- User says "quick fix", "just update", "simple change"

**Requirements:**
- Confirm files exist and changes are correct
- No tests required
- No formal verification report
- No separate review

**Announce:** `Rigor: quick — {reason (e.g., "config-only change")}`

---

### Standard Mode (default)

**Triggers:**
- New features or functionality
- Refactoring existing code
- Multi-file code changes
- Any `.ts`, `.tsx`, `.js`, `.jsx`, `.py`, `.go`, `.rs`, `.java` changes
- Default when no other mode clearly applies

**Requirements:**
- Tests are **recommended, not required**. Write them when the user asks, when the
  dispatch context requires them, or when the change is about to go into a PR/MR and
  the user accepts the offer
- Before creating a PR/MR, offer to write tests for the new behavior; proceed without
  them if declined
- If tests were written, run them and confirm they pass before claiming done
- Inline self-review checklist before completion:

```
## Self-Review
- [ ] Code compiles/runs without errors
- [ ] If tests were written, they pass
- [ ] Follows existing project patterns (checked conventions)
- [ ] No duplicated utilities (grepped codebase)
- [ ] No hardcoded values that should be config/env
```

- No separate verification report file
- No separate review subagent dispatch

**Announce:** `Rigor: standard — {reason (e.g., "new feature, multi-file")}`

---

### Strict Mode

**Triggers:**
- Production deployment code or scripts
- Security-sensitive paths: auth, payments, encryption, session management, access control
- API contract changes (breaking changes to public interfaces)
- Database migrations or schema changes
- Changes touching 5+ files
- User explicitly requests strict mode ("be thorough", "production", "careful")
- Anything involving user data, PII, or compliance

**Requirements:**
- Full TDD — the RED-GREEN-REFACTOR cycle:
  1. **RED:** Write one minimal failing test. Verify it fails *for the right reason*
     (expected behavior absent, not a syntax/import error). If it passes immediately,
     it tests existing behavior — fix the test.
  2. **GREEN:** Write the simplest code that makes it pass. No "while I'm here" additions.
  3. **REFACTOR:** Clean up while green. No new behavior during refactor.
  4. Production code written before its failing test gets deleted and redone test-first.
- 5-step verification gate:
  1. IDENTIFY the verification command
  2. RUN it fresh
  3. READ the full output
  4. VERIFY the output confirms your claim
  5. CLAIM only then
- Forbidden words in completion claims: "should", "probably", "seems to", "I believe", "likely"
- No premature celebration before verification
- Contributing factor sweep for bug fixes (see Phase 3.5 in `~/.claude/btrs/skills/btrs-fix/SKILL.md`)

**Announce:** `Rigor: strict — {reason (e.g., "auth-related, security-sensitive")}`

---

## Assessment Logic

When a skill starts, assess rigor level in this order:

1. **Check user intent** — Did the user signal a level? ("quick fix" → quick, "production" → strict, "be thorough" → strict)
2. **Check domain** — Security keywords (auth, payment, encrypt, migrate, deploy)? → strict
3. **Check scope** — How many files? What types? Single config file → quick. 5+ source files → strict.
4. **Check file types** — `.md`/`.json`/`.yaml` only → quick. Source code → standard minimum.
5. **Default** — If ambiguous, use **standard**.

## User Override

The user can always override:
- "Use strict mode" → strict, regardless of assessment
- "Quick is fine" / "Skip tests" → quick, regardless of assessment
- State the override: "Overriding to {level} per user request."

## Escape Clause

The user explicitly requests skipping any protocol? Acknowledge and proceed. The user always takes precedence.

Note the default: at quick and standard rigor, tests are already optional — "implement this feature" means implement it, offering tests before a PR/MR. Saying "write tests" or "use strict mode" opts in; strict-mode triggers (security, production, migrations) opt in automatically.

When invoking the escape clause, state it: "Skipping {rule} per your request."

---

## Quick Reference

| Rigor | Tests Required | Verification | Review | Token Cost |
|-------|---------------|-------------|--------|------------|
| Quick | No | File existence | None | Low |
| Standard | No (offered before PR/MR, written on request) | Inline checklist (+ run any tests written) | Self-review | Medium |
| Strict | Full TDD (R-G-R) | 5-step gate + evidence | Full protocol | High |
