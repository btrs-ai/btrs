# BTRS

**12 specialist AI agents. One command.**

BTRS is a Claude Code plugin that orchestrates specialist AI agents with adaptive rigor, persistent project knowledge, and session continuity. Discipline scales to match every task -- from lightweight adaptive checks to strict enforcement -- applied automatically, not suggested optionally.

---

## Quick Start

```bash
# Install globally for Claude Code
./install.sh

# Use in any project
/btrs build me a user dashboard with analytics
```

That's it. One command.

---

## What Happens When You Type `/btrs`

1. **Session check** -- reads `btrs/work/status.md`. If you have active work, asks if you want to continue or start new.
2. **Classification** -- categorizes your request: quick answer, debug, design, single-agent, multi-agent, decision, or clarification needed.
3. **Workflow** -- depending on classification:
   - Design requests: `btrs-brainstorm` then `btrs-plan` then `btrs-execute`
   - Bug reports: `btrs-debug` (systematic 4-phase investigation)
   - Implementation: worktree, TDD, agent dispatch, review, sanity check, finish
4. **Discipline enforcement** -- every agent gets Iron Law protocols injected: test-first, evidence-before-claims, root-cause-before-fix.
5. **Completion** -- 10-pass sanity check, then branch finish (merge/PR/keep/discard).

---

## The `btrs/` Directory

When you run `/btrs-init`, BTRS creates a `btrs/` directory in your project. This is both a structured knowledge base and an Obsidian vault.

```
btrs/
├── config.json         ← Project configuration (framework, language, tools)
├── knowledge/
│   ├── conventions/
│   ├── decisions/
│   ├── code-map/
│   │   ├── components.md
│   │   ├── utilities.md
│   │   ├── hooks.md
│   │   ├── constants.md
│   │   ├── types.md
│   │   └── api.md
│   └── tech-debt/
├── work/
│   ├── specs/
│   ├── plans/
│   ├── todos/
│   ├── changelog/
│   └── status.md
├── evidence/
│   ├── reviews/
│   ├── verification/
│   ├── debug/
│   └── sessions/
└── .obsidian/
```

Everything is plain markdown. Works with any editor, any workflow. Open in [Obsidian](https://obsidian.md) for graph visualization of how specs, decisions, and code connect.

---

## Adaptive Rigor

Discipline scales to match the task:

- **Adaptive** -- lightweight checks for simple tasks.
- **Standard** -- TDD, verification, and root cause analysis for typical work.
- **Strict** -- full enforcement for critical paths and production changes.

Core principles:

- **Verification** -- agents prove their work with evidence, not assertions.
- **Root cause first** -- no fixes without investigation.
- **Dependency justification** -- native solution > self-write > existing package > new dependency.
- **Duplication prevention** -- code-map registry checked before creating anything new.

---

## Agents

| Category | Agents |
|----------|--------|
| Management | boss |
| Technical | architect, qa-test-engineering, documentation, research |
| Engineering | api-engineer, web-engineer, mobile-engineer, ui-engineer, database-engineer |
| Security | code-security |
| Operations | devops |

Each agent has a dedicated instruction file at `agents/btrs-{name}/AGENT.md` with domain-specific protocols, verification requirements, and output formats.

---

## Skills

| Skill | Purpose |
|-------|---------|
| `/btrs` | Entry point — routes to the right skill automatically |
| `/btrs-build` | Build features, implement specs, create new functionality |
| `/btrs-fix` | Systematic debugging and bug fixing |
| `/btrs-review` | Code review, architecture review, PR review |
| `/btrs-research` | Technology evaluation, library comparison, feasibility studies |
| `/btrs-dispatch` | Parallel agent dispatch for independent tasks |

You do not need to memorize these. `/btrs` routes to the right one automatically.

---

## Session Continuity

`/btrs` reads `btrs/work/status.md` and picks up where you left off. No separate resume command needed. If you have active work from a previous session, BTRS will ask whether to continue it or start something new.

---

## Installation

**From GitHub (recommended):**

```bash
# Clones to ~/.claude/btrs/ and symlinks skills + agents
curl -fsSL https://raw.githubusercontent.com/btrs-ai/btrs/main/install.sh | bash
```

**From local clone:**

```bash
git clone git@github.com:btrs-ai/btrs.git
cd btrs
./install.sh
```

**Uninstall:**

```bash
./uninstall.sh
```

---

## Configuration

`/btrs-init` scans your project and generates `btrs/config.json` with detected conventions, tech stack, file structure patterns, and project metadata. This configuration is injected into every agent's context automatically. Re-run `/btrs-init` after major project changes to refresh detection.

---

## License

MIT
