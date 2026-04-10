# BTRS

**12 specialist AI agents. 6 commands. Adaptive rigor.**

BTRS is a Claude Code plugin that orchestrates specialist AI agents with adaptive discipline enforcement, persistent project knowledge via Obsidian, and session continuity. It auto-detects the right level of rigor for each task — strict TDD for production code, light verification for config changes.

---

## Quick Start

```bash
# Install globally for Claude Code
./install.sh

# Use in any project
/btrs build me a user dashboard with analytics
```

---

## Commands

| Command | Purpose |
|---------|---------|
| `/btrs` | Main router — classifies and routes any request automatically |
| `/btrs-build` | Feature building: brainstorm → plan → implement → verify → finish |
| `/btrs-fix` | Systematic debugging with root cause investigation |
| `/btrs-review` | Code review, security audit, or tech debt scan |
| `/btrs-research` | Technology evaluation, brainstorming, or analysis |
| `/btrs-dispatch` | Direct agent dispatch (power user shortcut) |

---

## What Happens When You Type `/btrs`

1. **Session activation** — creates a marker so all subsequent messages auto-route through BTRS
2. **Init check** — if first time, scans the project and creates the `btrs/` vault
3. **Classification** — categorizes your request: build, fix, review, research, or direct dispatch
4. **Rigor assessment** — auto-detects quick/standard/strict based on what you're touching
5. **Dispatch** — routes to the right agent(s) with conventions and protocols injected
6. **Verification** — based on rigor level, from file checks (quick) to full TDD (strict)

---

## Agents

### Tier 1 — Always Loaded (12)

| Agent | Domain |
|-------|--------|
| `boss` | Multi-agent coordination |
| `architect` | System design, ADRs |
| `api-engineer` | Backend APIs |
| `web-engineer` | Frontend apps |
| `mobile-engineer` | Mobile apps |
| `ui-engineer` | Components, design systems |
| `database-engineer` | Schema, migrations |
| `qa-test-engineering` | Testing |
| `code-security` | Security review |
| `devops` | Cloud, CI/CD, containers, monitoring |
| `research` | Tech evaluation |
| `documentation` | Technical writing |

### Tier 2 — On-Demand (12)

Available via `/btrs-dispatch`. Includes: desktop-engineer, security-ops, cloud-ops, cicd-ops, container-ops, monitoring-ops, product, marketing, sales, accounting, customer-success, data-analyst.

---

## Adaptive Rigor

| Level | When | What |
|-------|------|------|
| **Quick** | Config, docs, small changes | File checks only, no tests |
| **Standard** | Features, refactoring | Tests + inline self-review checklist |
| **Strict** | Security, production, migrations | Full TDD + 5-step verification gate |

Auto-detected. Override with "use strict mode" or "quick is fine".

---

## The `btrs/` Directory

BTRS creates a `btrs/` directory in your project — an Obsidian vault for persistent project knowledge.

```
btrs/
├── config.json          # Project config (framework, language, tools)
├── project-map.md       # Agent scopes and architecture
├── status.md            # Active work state
├── decisions/           # Architecture Decision Records
├── specs/               # Feature specifications
└── conventions/
    ├── registry.md      # Component/utility registry
    ├── patterns.md      # Convention rules
    └── anti-patterns.md # What NOT to do
```

Open `btrs/` in Obsidian for graph view, search, and visual navigation.

---

## Session Continuity

Type `/btrs` once. A `UserPromptSubmit` hook ensures all subsequent messages in the session route through BTRS automatically. New sessions start fresh.

---

## Installation

```bash
git clone https://github.com/btrs-ai/btrs.git ~/.claude/btrs
~/.claude/btrs/install.sh
```

Or update an existing install:

```bash
~/.claude/btrs/install.sh
```

---

## Upgrading from v2

Run `/btrs` in any project with a v2 vault. BTRS will detect the old `knowledge/work/evidence/` structure and automatically migrate to the v3 flat structure.

---

## License

MIT
