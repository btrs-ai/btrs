# BTRS v3 — Agent System

## Overview

BTRS is a 12-active-agent system with 12 on-demand agents. The `/btrs` router classifies requests and dispatches to the right agent via 6 tiered commands.

## Architecture

```
User → /btrs (router) → /build, /fix, /review, /research, /dispatch
                              ↓
                        Agent dispatch (Tier 1 or Tier 2)
                              ↓
                        Adaptive rigor (quick / standard / strict)
                              ↓
                        Verification + completion
```

## Tier 1 — Active Agents

Always loaded, available for immediate dispatch.

| Agent | Slug | Domain | Typical Requests |
|-------|------|--------|-----------------|
| Boss | `boss` | Coordination | "Build a complete feature", multi-domain requests |
| Architect | `architect` | System design | "Design the architecture", "Create an ADR" |
| API Engineer | `api-engineer` | Backend | "Build an API for", "Add an endpoint" |
| Web Engineer | `web-engineer` | Frontend | "Build a page", "Create a React component" |
| Mobile Engineer | `mobile-engineer` | Mobile | "Build the mobile app", "Add push notifications" |
| UI Engineer | `ui-engineer` | Components | "Create a Button component", "Set up design system" |
| Database Engineer | `database-engineer` | Database | "Design the schema", "Optimize this query" |
| QA/Test Engineer | `qa-test-engineering` | Testing | "Write tests for", "Check coverage" |
| Code Security | `code-security` | App security | "Scan for vulnerabilities", "Security review" |
| DevOps | `devops` | All ops | "Set up CI/CD", "Deploy", "Configure monitoring" |
| Research | `research` | Evaluation | "Compare X vs Y", "Research approaches" |
| Documentation | `documentation` | Writing | "Document the API", "Write a guide" |

## Tier 2 — On-Demand Agents

Available via `/dispatch`. Not loaded by default to save context.

| Agent | Slug | Domain |
|-------|------|--------|
| Desktop Engineer | `desktop-engineer` | Electron, Tauri |
| Security Ops | `security-ops` | Infrastructure security, compliance |
| Cloud Ops | `cloud-ops` | Deep AWS/Azure/GCP |
| CI/CD Ops | `cicd-ops` | Deep pipeline optimization |
| Container Ops | `container-ops` | Deep Kubernetes/Docker |
| Monitoring Ops | `monitoring-ops` | Deep observability |
| Product | `product` | Product strategy, roadmap |
| Marketing | `marketing` | Campaigns, SEO |
| Sales | `sales` | Pipeline, revenue |
| Accounting | `accounting` | Finance, bookkeeping |
| Customer Success | `customer-success` | Retention, support |
| Data Analyst | `data-analyst` | BI, analytics |

## Routing Rules

1. **Single domain** — Route directly to matching agent
2. **Multi-domain** — Route to `boss` for coordination
3. **Ops keywords** — Route to `devops` (delegates to specialized ops agents for deep dives)
4. **Ambiguous** — Ask user to clarify
5. **No match** — Default to `boss`

## Adaptive Rigor

Replaces the v2 Iron Law always-on enforcement:

| Level | Triggers | Requirements |
|-------|----------|-------------|
| **Quick** | Config, docs, single-file <50 lines | File checks only |
| **Standard** | Features, refactoring, multi-file | Tests + inline self-review |
| **Strict** | Security, production, migrations, 5+ files | Full TDD + 5-step verification |

Auto-detected based on file types, scope, domain, and user intent. User can override.

## Agent Dispatch Protocol

When dispatching any agent, include:

1. **TASK** — Specific, actionable description
2. **RIGOR** — Level and reason
3. **SCOPE** — Primary file patterns, what NOT to modify
4. **CONVENTIONS** — Inline (not file references)
5. **VERIFICATION** — Based on rigor level

## Context Passing

Sequential agents pass context via `btrs/` paths:
- Architect writes to `btrs/decisions/`
- Engineers read decisions, write implementations
- Security reviews all outputs
- All agents update `btrs/status.md`
