---
name: btrs-dispatch
description: >
  Direct dispatch to a single specialist agent — Tier 1 (always-loaded) or
  Tier 2 (on-demand: desktop-engineer, security-ops, cloud-ops, cicd-ops,
  container-ops, monitoring-ops, product, marketing, sales, accounting,
  customer-success, data-analyst). Use when the user names a specific domain
  or specialist directly, or wants a Tier 2 agent that isn't loaded by default.
disable-model-invocation: true
allowed-tools: Agent, Read, Grep, Glob
argument-hint: <domain or agent name> <task>
---

# /btrs-dispatch

Direct agent dispatch. Resolves the user's request to exactly one specialist —
Tier 1 or Tier 2 — and dispatches it via the Agent tool. This is the only path
to Tier 2 specialists, which are not loaded by default and have no registered
subagent type.

The user's request is: $ARGUMENTS

## Step 0: Load the routing table

Read `~/.claude/btrs/skills/shared/agent-registry.md`.

Use this absolute path, not the bare relative path `skills/shared/agent-registry.md`.
A same-named `shared/` directory from an unrelated toolkit can shadow the
relative path depending on the shell's working directory, silently serving the
wrong registry.

## Step 1: Resolve the target agent

1. Match the request against the registry's Quick Match Table (Tier 1 and Tier 2 sections).
2. **Multi-domain** — route to `boss`.
3. **Ambiguous** — ask the user to clarify, naming the two most likely agents.
4. **No match** — default to `boss`.
5. State the resolved agent and its tier before dispatching: "Dispatching to `{agent}` (Tier {1|2}) — {one-line reason}."

## Step 2: Dispatch

**Tier 1** (`architect`, `api-engineer`, `web-engineer`, `mobile-engineer`,
`ui-engineer`, `database-engineer`, `qa-test-engineering`, `code-security`,
`devops`, `research`, `documentation`, `boss`) — these are symlinked into
`~/.claude/agents/` as `btrs-<name>`. Dispatch directly:

```
Agent(subagent_type: "btrs-<name>", prompt: "<task>", description: "<short label>")
```

**Tier 2** (`desktop-engineer`, `security-ops`, `cloud-ops`, `cicd-ops`,
`container-ops`, `monitoring-ops`, `product`, `marketing`, `sales`,
`accounting`, `customer-success`, `data-analyst`) — these have no registered
subagent type. Load the specialist manually:

1. Read `~/.claude/btrs/agents/btrs-<name>/AGENT.md` in full. If it does not
   exist, stop and tell the user — do not guess or proceed without it.
2. Dispatch via `subagent_type: "general-purpose"`, with a prompt of the form:

   ```
   You are acting as the following specialist. Follow its role, responsibilities,
   and constraints exactly as written below.

   ---
   {full contents of AGENT.md}
   ---

   Task: {the user's actual request}
   ```

3. Note in your dispatch announcement that this is a Tier 2 agent running via
   `general-purpose` (no native subagent type) — the user should know it isn't
   a first-class registered agent.

## Step 3: Report

1. Return the dispatched agent's output to the user, unmodified unless it needs summarizing for length.
2. If the agent asked a clarifying question instead of completing the task, surface that question rather than guessing an answer.

## Anti-patterns

- Do not dispatch to `general-purpose` for a Tier 2 request without first reading and injecting its `AGENT.md` — an uninstructed general-purpose agent is not the specialist the user asked for.
- Do not use the bare relative path `skills/shared/agent-registry.md` or `agents/btrs-<name>/AGENT.md` — resolve against `~/.claude/btrs/` explicitly, since a same-named `shared/` directory can otherwise resolve to an unrelated toolkit's files depending on the shell's cwd.
- Do not invent a Tier 2 agent that isn't in the registry. If no match exists, say so.
- Do not skip the ambiguous-match clarification for vague, multi-domain requests — that's what `boss` is for when genuinely broad, but a two-way ambiguity should be asked, not guessed.
