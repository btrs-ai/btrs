# BTRS Agents

**24 specialist AI agents. 1 command.**

```
/btrs build me a user dashboard with analytics
```

AI agent orchestration plugin — 24 specialists, 16 skills, convention enforcement, self-verification, tech debt tracking, and auto-generated Obsidian docs. One command: `/btrs`.

Works with Claude Code, Cursor, GitHub Copilot, Windsurf, OpenAI Codex, and any AI assistant that reads markdown.

---

## Install

All install methods are **global** — BTRS is available in every project you open.

**Claude Code (plugin registry):**

```
/plugin marketplace add btrs-ai/btrs
/plugin install btrs
```

**Claude Code (manual):**

```bash
git clone https://github.com/btrs-ai/btrs.git ~/.claude/btrs
~/.claude/btrs/install.sh
```

**Other AI tools** (Cursor, Copilot, Windsurf, Codex) — global install:

```bash
git clone https://github.com/btrs-ai/btrs.git ~/.btrs
```

Then set up your tool's global rules. See [detailed instructions](#installation-detailed) for each tool, including per-project options.

---

## Use

```
/btrs [anything you want]
```

First time? It auto-scans your project. After that, just talk.

**Want real examples?** See the [Usage Guide](docs/USAGE-GUIDE.md) — shows exactly how to use every agent for building features, fixing bugs, security audits, deployments, and more.

**Prefer a visual docs site?** Open [docs/index.html](docs/index.html) in your browser for the full interactive documentation with installation tabs, agent cards, FAQs, and dark mode.

---

## How It Works

1. You type `/btrs` + what you want
2. BTRS classifies your request (code, architecture, security, ops, business, etc.)
3. Dispatches the right specialist agent(s) -- or multiple in parallel
4. Agents follow your project's conventions (mandatory, not optional)
5. Each agent verifies its own work with evidence
6. Documentation updated automatically in the `.btrs/` Obsidian vault

No configuration required. No prompt engineering. Just describe what you need.

---

## The 24 Agents

### Management (1)

| Agent | What it does |
|-------|-------------|
| Boss | Orchestrates everything -- breaks down requests, assigns agents, tracks progress |

### Technical (4)

| Agent | What it does |
|-------|-------------|
| Architect | System design, architecture decisions, ADRs |
| QA & Test Engineering | Unit, integration, e2e, performance, security testing |
| Documentation | Technical writing, API docs, guides, changelogs |
| Research | Technology evaluation, POCs, innovation |

### Engineering (6)

| Agent | What it does |
|-------|-------------|
| API Engineer | Backend APIs, REST, GraphQL, microservices |
| Web Engineer | React, Vue, frontend applications |
| Mobile Engineer | React Native, Flutter, iOS, Android |
| Desktop Engineer | Electron, Tauri, native desktop apps |
| UI Engineer | Component libraries, design systems, Storybook |
| Database Engineer | Schema design, migrations, query optimization |

### Security (2)

| Agent | What it does |
|-------|-------------|
| Code Security | SAST/DAST, vulnerability scanning, secure coding |
| Security Ops | Infrastructure security, compliance (GDPR, SOC2, etc.) |

### Operations (5)

| Agent | What it does |
|-------|-------------|
| Cloud Ops | AWS, Azure, GCP infrastructure |
| CI/CD Ops | Pipelines, GitHub Actions, release workflows |
| Container Ops | Docker, Kubernetes, orchestration |
| Monitoring Ops | Prometheus, Grafana, observability |
| DevOps | Cross-cutting operational workflows |

### Business (6)

| Agent | What it does |
|-------|-------------|
| Product | Strategy, roadmap, requirements, user stories |
| Marketing | Campaigns, growth, SEO, content |
| Sales | Pipeline, revenue, proposals |
| Accounting | Financials, bookkeeping, invoicing |
| Customer Success | Retention, support, onboarding |
| Data Analyst | BI, analytics, dashboards, reports |

---

## The 15 Skills

| Skill | What it does | When to use |
|-------|-------------|-------------|
| `/btrs` | Routes everything | Default entry point -- start here |
| `/btrs-init` | Scans project, creates vault | First time setup or refresh |
| `/btrs-propose` | 3 solution approaches | Design decisions |
| `/btrs-plan` | Creates specs and task breakdowns | Planning features |
| `/btrs-implement` | Builds from spec | Writing code |
| `/btrs-review` | Reviews code and architecture | Quality checks |
| `/btrs-audit` | Security and quality audit | Security review |
| `/btrs-verify` | Pattern compliance check | After implementation |
| `/btrs-health` | Project-wide drift check | Maintenance |
| `/btrs-deploy` | Release workflow | Shipping |
| `/btrs-research` | Tech evaluation | Comparing options |
| `/btrs-analyze` | Data and business analysis | Metrics and reports |
| `/btrs-spec` | Spec management | Working with specifications |
| `/btrs-handoff` | Agent-to-agent bridge | Multi-agent workflows |
| `/btrs-doc` | Refresh documentation | Stale docs |
| `/btrs-tech-debt` | Scan, capture, prioritize, fix tech debt | Code quality, cleanup |

You don't need to memorize these. `/btrs` routes to the right one automatically.

---

## Installation (Detailed)

### Claude Code (Plugin — Recommended)

**Installs globally.** Available in every project you open with Claude Code.

```
/plugin marketplace add btrs-ai/btrs
/plugin install btrs
```

Auto-updates when new versions are released. Nothing to maintain.

### Claude Code (Manual)

**Installs globally.** Symlinks skills and agents into `~/.claude/` so they're available everywhere.

```bash
git clone https://github.com/btrs-ai/btrs.git ~/.claude/btrs
~/.claude/btrs/install.sh
```

Run `install.sh` again anytime to pull the latest version and re-link.

### Claude AI (Web)

In the Claude.ai web interface:

1. Upload `AGENTS.md` as context in a Claude Project
2. Reference agent instruction files (`agents/btrs-*/AGENT.md`) for specialized tasks
3. The convention and verification systems work through conversation

Note: The full plugin features (slash command skills, auto-dispatch routing) require Claude Code. The web interface gives you access to agent knowledge and workflows through manual context loading.

### Claude Cowork

In Claude Cowork:

1. Upload `AGENTS.md` as context for the full instruction set
2. Load agent files (`agents/btrs-*/AGENT.md`) for specialized domain expertise
3. The orchestration pattern (Boss delegates to specialists) works through conversation

### Cursor

**Global (available in every project):**
```bash
git clone https://github.com/btrs-ai/btrs.git ~/.btrs
ln -sf ~/.btrs/.cursorrules ~/.cursorrules
```
Use `@~/.btrs/agents/btrs-architect/AGENT.md` to load agents in any project.

**Per-project (this project only):**
```bash
git clone https://github.com/btrs-ai/btrs.git .btrs-agents
```
The `.cursorrules` file auto-loads. Use `@.btrs-agents/agents/btrs-architect/AGENT.md` to load agents.

### GitHub Copilot

**Global (available in every repo):**
```bash
git clone https://github.com/btrs-ai/btrs.git ~/.btrs
mkdir -p ~/.github
cp ~/.btrs/.github/copilot-instructions.md ~/.github/copilot-instructions.md
```

**Per-repo (this repo only):**
```bash
git clone https://github.com/btrs-ai/btrs.git .btrs-agents
cp .btrs-agents/.github/copilot-instructions.md .github/copilot-instructions.md
```

Reference agent files in Copilot Chat for domain expertise.

### Windsurf

**Global (available in every project):**
```bash
git clone https://github.com/btrs-ai/btrs.git ~/.btrs
ln -sf ~/.btrs/.windsurfrules ~/.windsurfrules
```
Use `@~/.btrs/agents/btrs-api-engineer/AGENT.md` to load agents in any project.

**Per-project (this project only):**
```bash
git clone https://github.com/btrs-ai/btrs.git .btrs-agents
```
The `.windsurfrules` file auto-loads. Use `@.btrs-agents/agents/btrs-api-engineer/AGENT.md` to load agents.

### OpenAI Codex

**Global:**
```bash
git clone https://github.com/btrs-ai/btrs.git ~/.btrs
```

**Per-project:** Copy `AGENTS.md` into your project root:
```bash
cp ~/.btrs/AGENTS.md ./AGENTS.md
```

Codex reads AGENTS.md natively. Reference agent files for domain expertise.

---

## The .btrs/ Obsidian Vault

When you run `/btrs-init`, BTRS creates a `.btrs/` directory in your project. This is an Obsidian vault.

**What's inside:**

```
.btrs/
  specs/          # Technical specifications
  todos/          # Tracked work items
  decisions/      # Architecture Decision Records
  code-map/       # Registry of components, utilities, patterns
  conventions/    # Your project's enforced rules
  changelog/      # Auto-generated change log entries
```

**How to use it:**
- Open `.btrs/` in [Obsidian](https://obsidian.md) for a visual knowledge base
- Graph view shows how specs, decisions, and code connect
- Everything is plain markdown -- works without Obsidian too
- Updated automatically after every agent completes work

---

## Convention System

Conventions prevent AI drift. They keep agents from ignoring your project's patterns.

- **Auto-detected** from your existing codebase during `/btrs-init`
- **Injected into agent context** on every task (mandatory, not optional)
- **Component/utility registry** prevents agents from recreating things that already exist
- **Anti-pattern lists** prevent common mistakes specific to your project
- **`/btrs-verify`** catches violations after the fact

This means the 10th file an agent creates follows the same patterns as the 1st.

---

## Self-Verification

Agents don't just say "done." They prove it.

Every agent runs a 5-point check before reporting completion:

1. **File existence** -- do all created/modified files actually exist?
2. **Pattern compliance** -- does the code match project conventions?
3. **Functional claims** -- does the code do what was claimed?
4. **Integration points** -- do imports resolve, types match, APIs connect?
5. **Completeness** -- is anything missing from the original requirement?

Evidence is required for each claim. Failures get fixed before the agent reports done.

---

## Multi-Solution Exploration

`/btrs-propose` generates 3 parallel approaches for any design decision:

1. **Minimal** -- smallest change that works
2. **Conventional** -- standard industry approach
3. **Scalable** -- built for growth

Each approach is scored against your project's specific criteria (conventions, tech stack, existing patterns). You pick the winner, then `/btrs-plan` and `/btrs-implement` take it from there.

---

## Cross-AI Compatibility

BTRS is not locked to one AI tool.

- **`AGENTS.md`** is the universal source of truth -- any AI that reads markdown can use it
- **Each AI tool has a thin adapter** (`.cursorrules`, `.windsurfrules`, etc.) that loads automatically
- **The `.btrs/` vault is plain markdown** -- works with any AI, any editor, any workflow
- **Conventions and verification are AI-agnostic** -- they work through the instruction files, not through any specific runtime

The architecture is: markdown instructions in, verified code out. The AI tool in the middle is interchangeable.

---

## Updating

```bash
~/.claude/btrs/install.sh
```

This pulls the latest version and re-links all skills and agents.

---

## Uninstalling

```bash
~/.claude/btrs/uninstall.sh
```

This removes all symlinks from `~/.claude/` and optionally deletes the toolkit directory.

---

## Project Structure

```
btrs/
  agents/            # 24 specialist agents (AGENT.md each)
  skills/            # 15 slash-command skills (SKILL.md each)
  templates/         # Obsidian vault templates
  docs/
    index.html       # Interactive documentation site (open in browser)
    USAGE-GUIDE.md   # Real examples for every agent and scenario
  AGENTS.md          # Universal instructions (works with any AI)
  CLAUDE.md          # Claude Code adapter
  .cursorrules       # Cursor adapter
  .windsurfrules     # Windsurf adapter
  .codex-instructions.md   # OpenAI Codex adapter
  .github/copilot-instructions.md  # GitHub Copilot adapter
  install.sh         # Installer (Claude Code)
  uninstall.sh       # Uninstaller
  plugin.json        # Plugin manifest
```

---

## License

MIT
