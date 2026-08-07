# Agent Core Protocol

Shared contract for every BTRS agent. Read once per dispatch; do not re-read if already in context.

## Scoped Dispatch

When dispatched by the /btrs orchestrator you receive:

- TASK: what to do
- SPEC: where to read the spec (if applicable)
- YOUR SCOPE: primary, shared, and external file paths
- CONVENTIONS: relevant project conventions (injected, do not skip)
- OUTPUT: where to write your results

## Rigor

Follow the rigor level stated in your dispatch context (quick / standard / strict, defined in `~/.claude/btrs/skills/shared/rigor-protocol.md`). If no level was given for implementation work, assume standard.

- **Quick**: confirm files exist and changes are correct. No tests, no report.
- **Standard**: tests are recommended, not required. Offer them before a PR/MR is created, and write them when the user or dispatch asks. Run any tests you did write.
- **Strict**: read `rigor-protocol.md` and follow full TDD and the 5-step verification gate.

## Self-Verification (before reporting completion)

1. Verify files you claim to have created/modified exist (Glob)
2. Verify pattern compliance against injected conventions
3. Verify functional claims with evidence (grep results, file reads, command output)
4. For code work: verify integration points (imports resolve, types match)
5. State the evidence inline in your final report — never "should work"

If any check fails: fix and re-verify before reporting complete.

## Documentation Output (code-producing work)

After completing work that adds or changes code:

1. Update `btrs/conventions/registry.md` with new or changed components, utilities, hooks, or types
2. Update `btrs/status.md` if the active work state changed
3. Record durable decisions as ADRs in `btrs/decisions/`, linking related notes: [[specs/...]], [[decisions/...]]

Non-code agents: update `btrs/status.md` only. Report the work itself in your final message to the caller — do not write session logs into the vault.

## Convention Compliance (code-producing work)

Follow all conventions injected in your dispatch prompt. Before creating any new component, utility, or pattern, check `btrs/conventions/registry.md` and `btrs/conventions/` for an existing solution — if one covers most of the need, use it instead of recreating it.

## Status & Communication

- Announce any sub-dispatch before making it (agent, task, context) — no silent execution
- Show verification evidence inline (command, exit code, result)
- Debugging: investigate the root cause before fixing; sweep for contributing factors — no fix without understanding why
- Dependencies: prefer native / self-written / existing packages before adding a new one
