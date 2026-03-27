# BTRS Agents -- Project Instructions

> This file is the instruction set for the BTRS multi-agent system.
> For Claude Code-specific features, see `CLAUDE.md`.

---

## Platform Support

BTRS is designed for **Claude Code** as the primary platform. The skills, agents, and workflow protocols are optimized for Claude Code's Agent tool, Skill tool, and TaskCreate capabilities.

Other AI tools (Cursor, GitHub Copilot, Windsurf, Codex) may work with the agent definitions in `agents/` and the instruction set in this file, but the full workflow (subagent dispatch, two-stage review, session continuity) requires Claude Code.

---

## System Overview

BTRS is a 24-specialist-agent system with a single entry point: the **Boss Agent**. Every request flows through the Boss, who plans, delegates, and coordinates across specialist agents.

**Core principles:**
- All work flows through specs, conventions, and verification
- Agents are scoped to specific domains and only modify files within their scope
- The `AI/` directory holds persistent memory, config, and documentation
- Agent definitions live in `agents/btrs-*/AGENT.md`

---

## Project Structure

```
btrs/
  agents/              # 24 specialist agents + 1 boss agent
    btrs-boss/AGENT.md
    btrs-architect/AGENT.md
    btrs-api-engineer/AGENT.md
    ...
  skills/              # 15 slash-command skills
    btrs/SKILL.md       # Router -- the single entry point
    btrs-plan/SKILL.md
    btrs-implement/SKILL.md
    ...
  AI/
    config/            # Agent roles, shared configuration
    docs/              # Agent documentation, workflow guides
    memory/            # Persistent memory per agent + global + sessions
      agents/          # Per-agent memory (JSON files)
      global/          # Shared project state, architecture decisions
      sessions/        # Session-scoped context
  docs/                # User-facing documentation
  src/                 # Source code
  templates/           # Scaffolding templates
  plugin.json          # Plugin manifest (skills + agents registry)
```

---

## Agent Registry

### Management (1)
| Agent | Domain | Use When |
|-------|--------|----------|
| Boss | Orchestration, planning | Any multi-step request, task coordination |

### Technical (4)
| Agent | Domain | Use When |
|-------|--------|----------|
| Architect | System design, ADRs | Architecture decisions, tech stack choices |
| QA & Test Engineering | Testing (unit, integration, e2e, perf) | Writing tests, test strategy, quality gates |
| Documentation | Technical writing, API docs | Docs, guides, READMEs, changelogs |
| Research | Tech evaluation, POCs | Evaluating tools, researching approaches |

### Engineering (6)
| Agent | Domain | Use When |
|-------|--------|----------|
| API Engineer | Backend APIs, REST, GraphQL | Endpoints, services, authentication |
| Web Engineer | React, Vue, frontend apps | Web UI, SPA, frontend logic |
| Mobile Engineer | React Native, Flutter, iOS, Android | Mobile apps, native features |
| Desktop Engineer | Electron, Tauri, native desktop | Desktop apps, system integration |
| UI Engineer | Component libraries, design systems | Shared components, Storybook, tokens |
| Database Engineer | Schema design, migrations, optimization | Database changes, queries, indexing |

### Security (2)
| Agent | Domain | Use When |
|-------|--------|----------|
| Code Security | SAST/DAST, vulnerability scanning | Security reviews, dependency audits |
| Security Ops | Infrastructure security, compliance | GDPR, SOC2, pen testing, incident response |

### Operations (4)
| Agent | Domain | Use When |
|-------|--------|----------|
| Cloud Ops | AWS, Azure, GCP | Infrastructure provisioning, cloud config |
| CI/CD Ops | Pipelines, GitHub Actions | Build/deploy automation, release workflows |
| Container Ops | Docker, Kubernetes | Containerization, orchestration, Helm |
| Monitoring Ops | Prometheus, Grafana, observability | Alerting, dashboards, log aggregation |

### Business (6)
| Agent | Domain | Use When |
|-------|--------|----------|
| Product | Strategy, roadmap, requirements | Feature prioritization, PRDs, user stories |
| Marketing | Campaigns, growth, SEO | Marketing strategy, content, analytics |
| Sales | Pipeline, revenue, BD | Sales strategy, proposals, CRM |
| Accounting | Financials, bookkeeping | Invoicing, budgets, financial reports |
| Customer Success | Retention, support | Customer health, ticket triage, onboarding |
| Data Analyst | BI, analytics, dashboards | Data queries, reports, visualizations |

---

## Workflow

### 1. Plan Mode (Default)

Every implementation request starts in plan mode:
1. Analyze the request -- scope, complexity, domains involved
2. Break down into TASK-001, TASK-002, etc. with agent assignments
3. Identify dependencies and execution order
4. Present the plan and wait for user approval
5. Only execute after explicit approval

### 2. Memory System

Agents persist context across sessions via JSON files:
- **Per-agent**: `AI/memory/agents/<agent-name>/*.json`
- **Global**: `AI/memory/global/*.json` (architecture decisions, project state)
- **Sessions**: `AI/memory/sessions/latest.json`

When coordinating multi-agent work, pass context by having the next agent read the previous agent's memory output.

### 3. Agent Scoping

Each agent has a defined scope in its `AGENT.md` file. Agents should:
- Only modify files within their declared scope
- Flag any need to modify files outside scope
- Read (but not write) other agents' memory for context

---

## Convention System

Conventions are mandatory rules, not suggestions.

- **Check the registry** before creating any new component, utility, or pattern
- **Follow anti-patterns list** -- never recreate what exists, never hardcode design tokens
- **Read canonical examples** before writing new code in an unfamiliar area
- **Match existing patterns** in the codebase exactly

### Anti-Pattern Rules (Universal)
1. Never recreate components/utilities that exist in the registry
2. Never hardcode values that have design tokens or config
3. Never skip verification
4. Never modify files outside your agent scope without flagging
5. Never execute tasks without user approval (plan mode default)
6. Never write code without reading existing patterns first

---

## Verification Protocol

All code changes must be self-verified before reporting completion. Run these 5 checks:

1. **File existence** -- Do all created/modified files exist and have content?
2. **Pattern compliance** -- Does the code follow existing project conventions?
3. **Functional claims** -- Does the code actually do what was claimed?
4. **Integration points** -- Do imports resolve? Do types match? Do APIs connect?
5. **Completeness** -- Is anything missing from the original requirement?

Evidence is required for each claim. Fix failures before reporting done.

---

## Output Requirements

### Memory Files
- All memory files use JSON format
- Update relevant memory after completing work
- Update `AI/memory/sessions/latest.json` with session summary

### Documentation
- Agent docs live in `AI/docs/agents/`
- Workflow docs live in `AI/docs/workflows/`
- User-facing docs live in `docs/`

---

## How to Use Agent Instructions

Each agent's full instructions are in `agents/btrs-<name>/AGENT.md`. These files contain:
- Role and responsibilities
- Memory read/write locations
- Specific workflows and protocols
- Skills the agent can invoke

When working on a task, load the relevant agent's AGENT.md for domain-specific guidance.

---

## Skills (Slash Commands)

The system provides 15 skills as entry points:

| Skill | Purpose |
|-------|---------|
| `/btrs` | Router -- dispatches to the right skill automatically |
| `/btrs-init` | Initialize BTRS in a new project |
| `/btrs-propose` | Propose a new feature or change |
| `/btrs-plan` | Create a task breakdown and execution plan |
| `/btrs-implement` | Write code from a spec or task |
| `/btrs-review` | Code review with security and quality checks |
| `/btrs-audit` | Deep audit of code, architecture, or process |
| `/btrs-verify` | Run the 5-point verification protocol |
| `/btrs-health` | Project health check across all dimensions |
| `/btrs-deploy` | Deployment planning and execution |
| `/btrs-research` | Technology research and evaluation |
| `/btrs-analyze` | Analyze data, metrics, or codebase patterns |
| `/btrs-spec` | Write a technical specification |
| `/btrs-handoff` | Create handoff documents between agents/sessions |
| `/btrs-doc` | Generate or update documentation |

---

## Quick Start

1. Read this file for universal instructions
2. Load the relevant agent's `AGENT.md` for domain-specific guidance
3. Check `AI/memory/global/project-state.json` for current project context
4. Follow plan mode: plan first, execute after approval
5. Verify all work before reporting completion
6. Update memory files after completing work
