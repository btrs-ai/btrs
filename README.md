# BTRS

**24 specialist AI agents. 24 skills. Iron Law discipline. One command.**

BTRS is a Claude Code plugin that orchestrates specialist AI agents with behavioral discipline enforcement, persistent project knowledge, and session continuity. Every agent operates under Iron Law protocols -- test-first development, evidence-before-claims, root-cause-before-fix -- enforced automatically, not suggested optionally.

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
├── knowledge/          <- Permanent project truth
│   ├── conventions/    <- Detected patterns and standards
│   ├── decisions/      <- Architecture Decision Records
│   ├── code-map/       <- Component/utility/hook/constant/type/API registry
│   └── tech-debt/      <- Tracked debt items with fix instructions
├── work/               <- Active work (lifecycle-managed)
│   ├── specs/          <- Feature specifications
│   ├── plans/          <- Implementation plans
│   ├── todos/          <- Task breakdowns
│   ├── changelog/      <- Change records
│   └── status.md       <- Session continuity: what's active, blocked, completed
├── evidence/           <- Audit trail
│   ├── reviews/        <- Code review reports
│   ├── verification/   <- Verification evidence
│   ├── debug/          <- Root cause investigations
│   └── sessions/       <- Agent activity summaries
└── .obsidian/          <- Open in Obsidian for graph visualization
```

Everything is plain markdown. Works with any editor, any workflow. Open in [Obsidian](https://obsidian.md) for graph visualization of how specs, decisions, and code connect.

---

## Discipline Enforcement

Three Iron Laws govern every agent:

- **TDD** -- no production code without a failing test first.
- **Verification** -- no completion claims without fresh evidence. Agents prove their work, not just assert it.
- **Debugging** -- no fixes without root cause investigation. Four-phase systematic analysis before any code changes.

Additional enforcement:

- **Dependency justification** -- native solution > self-write > existing package > new dependency.
- **Duplication prevention** -- code-map registry checked before creating anything new.
- **Performance awareness** -- no unbounded operations, no O(n^2) where O(n) exists.

---

## The 24 Agents

| Category | Agents |
|----------|--------|
| Management | boss |
| Technical | architect, qa-test-engineering, documentation, research |
| Engineering | api-engineer, web-engineer, mobile-engineer, desktop-engineer, ui-engineer, database-engineer |
| Security | code-security, security-ops |
| Operations | cloud-ops, cicd-ops, container-ops, monitoring-ops, devops |
| Business | product, marketing, sales, accounting, customer-success, data-analyst |

Each agent has a dedicated instruction file at `agents/btrs-{name}/AGENT.md` with domain-specific protocols, verification requirements, and output formats.

---

## The 24 Skills

| Purpose | Skills |
|---------|--------|
| Entry and Orchestration | btrs, btrs-init, btrs-execute, btrs-handoff |
| Design and Planning | btrs-brainstorm, btrs-plan, btrs-propose |
| Discipline | btrs-tdd, btrs-debug, btrs-verify, btrs-receive-review, btrs-sanity-check |
| Workflow | btrs-worktree, btrs-finish, btrs-request-review, btrs-dispatch |
| Quality and Ops | btrs-implement, btrs-review, btrs-audit, btrs-deploy, btrs-health, btrs-tech-debt, btrs-research, btrs-analyze, btrs-doc |

You do not need to memorize these. `/btrs` routes to the right one automatically.

---

## Session Continuity

`/btrs` reads `btrs/work/status.md` and picks up where you left off. No separate resume command needed. If you have active work from a previous session, BTRS will ask whether to continue it or start something new.

---

## Installation

**Global install (recommended):**

```bash
./install.sh
```

Symlinks skills and agents into `~/.claude/` so they are available in every project.

**Per-project:**

Copy the BTRS directory to your project root and reference it locally.

**Uninstall:**

```bash
./uninstall.sh
```

Removes all symlinks from `~/.claude/` and optionally deletes the toolkit directory.

**Update:**

Run `./install.sh` again to pull the latest version and re-link.

---

## Configuration

`/btrs-init` scans your project and generates `btrs/config.json` with detected conventions, tech stack, file structure patterns, and project metadata. This configuration is injected into every agent's context automatically. Re-run `/btrs-init` after major project changes to refresh detection.

---

## License

MIT
