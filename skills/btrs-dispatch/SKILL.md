---
name: btrs-dispatch
description: >
  Direct dispatch to a single specialist agent — Tier 1 (always-loaded) or
  Tier 2 (on-demand; see agent-registry.md). Use when the user names a specific
  domain or specialist directly.
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

The registry's tier tables (Step 0) are the source of truth for which agents are
Tier 1 vs Tier 2 and which model tier each dispatches on — do not restate them here.

**Tier 1** — symlinked into `~/.claude/agents/` as `btrs-<name>`. Dispatch directly:

```
Agent(subagent_type: "btrs-<name>", prompt: "<task>", description: "<short label>")
```

**Tier 2** — no registered subagent type. Load the specialist manually:

1. Confirm `~/.claude/btrs/agents/btrs-<name>/AGENT.md` exists using Glob. **Do not
   read it** — the file is only needed by the subagent; reading it here loads it into
   *your* context for nothing. If Glob finds nothing, stop and tell the user.
2. Dispatch via `subagent_type: "general-purpose"`, having the subagent load its own
   role as its first action. If the registry's Model column marks the agent `sonnet`,
   pass `model: "sonnet"` on the Agent call:

   ```
   Your first action is to read ~/.claude/btrs/agents/btrs-<name>/AGENT.md in full.
   That file defines your role, responsibilities, and constraints — adopt it exactly
   as written and follow it for the rest of this task. If the file is missing, stop
   and report that instead of guessing.

   Task: {the user's actual request}
   ```

3. Note in your dispatch announcement that this is a Tier 2 agent running via
   `general-purpose` (no native subagent type), and which model it runs on.

## Step 3: Report

1. Return the dispatched agent's output to the user, unmodified unless it needs summarizing for length.
2. If the agent asked a clarifying question instead of completing the task, surface that question rather than guessing an answer.

## Anti-patterns

- Do not dispatch to `general-purpose` for a Tier 2 request without instructing it to load its `AGENT.md` first — an uninstructed general-purpose agent is not the specialist the user asked for.
- Do not read a Tier 2 `AGENT.md` into your own context in order to paste it into the prompt. The subagent reads it itself; doing both loads 17–23 KB twice for no benefit.
- Do not read a **Tier 1** `AGENT.md` at all — the registered `btrs-<name>` subagent type already loads it as its system prompt.
- Do not use the bare relative path `skills/shared/agent-registry.md` or `agents/btrs-<name>/AGENT.md` — resolve against `~/.claude/btrs/` explicitly, since a same-named `shared/` directory can otherwise resolve to an unrelated toolkit's files depending on the shell's cwd.
- Do not invent a Tier 2 agent that isn't in the registry. If no match exists, say so.
- Do not skip the ambiguous-match clarification for vague, multi-domain requests — that's what `boss` is for when genuinely broad, but a two-way ambiguity should be asked, not guessed.
