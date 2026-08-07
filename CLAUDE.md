# BTRS v3 — Claude Code Instructions

## Entry Point

Use `/btrs` as the primary entry point. It routes to the correct skill automatically.

### Commands

| Command | Purpose |
|---------|---------|
| `/btrs` | Router — classifies and routes any request |
| `/btrs-build` | Feature building: brainstorm → plan → implement → verify |
| `/btrs-fix` | Systematic debugging with root cause investigation |
| `/btrs-review` | Code review, security audit, tech debt scan |
| `/btrs-research` | Technology evaluation, brainstorming, analysis |
| `/btrs-dispatch` | Direct agent dispatch — Tier 1 or Tier 2 |
| `/btrs-init` | Scan a project and create/refresh the `btrs/` vault (runs automatically on first `/btrs` use) |
| `/btrs-deploy` | Deployment and release workflow with pre-deploy checks |
| `/btrs-health` | Project-wide drift and consistency check |
| `/btrs-update` | Pull the latest BTRS release and reinstall |

## Adaptive Rigor

BTRS v3 auto-detects the appropriate rigor level:

| Level | When | What |
|-------|------|------|
| Quick | Config, docs, small changes | File checks only, no tests |
| Standard | Features, refactoring, code changes | Inline self-review; tests offered before PR, written on request |
| Strict | Security, production, migrations, 5+ files | Full TDD + 5-step verification |

Override with "use strict mode" or "quick is fine".

## Agents

### Tier 1 — Always Loaded

| Agent | Domain |
|-------|--------|
| `btrs-boss` | Multi-agent coordination |
| `btrs-architect` | System design, ADRs |
| `btrs-api-engineer` | Backend APIs |
| `btrs-web-engineer` | Frontend apps |
| `btrs-mobile-engineer` | Mobile apps |
| `btrs-ui-engineer` | Components, design systems |
| `btrs-database-engineer` | Schema, migrations |
| `btrs-qa-test-engineering` | Testing |
| `btrs-code-security` | Security review |
| `btrs-devops` | Cloud, CI/CD, containers, monitoring |
| `btrs-research` | Tech evaluation |
| `btrs-documentation` | Technical writing |

### Tier 2 — On-Demand (via `/btrs-dispatch`)

`desktop-engineer`, `security-ops`, `cloud-ops`, `cicd-ops`, `container-ops`, `monitoring-ops`, `product`, `marketing`, `sales`, `accounting`, `customer-success`, `data-analyst`

## Session Continuity

Type `/btrs` once per session. A UserPromptSubmit hook injects the routing instruction on the first prompt of a session (in-scope directories); after that the router stays in context and keeps routing without re-injection.

## Project Vault

BTRS creates a `btrs/` directory (Obsidian vault) in each project:

```
btrs/
├── config.json          # Project config
├── project-map.md       # Agent scopes
├── status.md            # Active work
├── decisions/           # ADRs
├── specs/               # Feature specs
└── conventions/         # Patterns, registry, anti-patterns
```

## Key Files

- **Agent definitions**: `agents/btrs-*/AGENT.md`
- **Skill definitions**: `skills/*/SKILL.md`
- **Rigor protocol**: `skills/shared/rigor-protocol.md`
- **Agent registry**: `skills/shared/agent-registry.md`
- **Plugin manifest**: `plugin.json`
