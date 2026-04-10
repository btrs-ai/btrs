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
| `/btrs-dispatch` | Direct agent dispatch (power user shortcut) |

## Adaptive Rigor

BTRS v3 auto-detects the appropriate rigor level:

| Level | When | What |
|-------|------|------|
| Quick | Config, docs, small changes | File checks only, no tests |
| Standard | Features, refactoring, code changes | Tests + inline self-review |
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

Type `/btrs` once and all subsequent messages route through BTRS automatically via a UserPromptSubmit hook.

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
