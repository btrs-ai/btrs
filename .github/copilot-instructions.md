# BTRS Agents -- GitHub Copilot Instructions

See **AGENTS.md** for the full BTRS instruction set. This file adds Copilot-specific patterns.

## How to Use BTRS with Copilot

### Loading Agent Context
Copilot Chat supports file references. Include agent instructions as context:
- Reference `agents/btrs-<name>/AGENT.md` for domain-specific guidance
- Reference `AGENTS.md` for universal instructions and conventions
- Reference `AI/memory/global/project-state.json` for current project state

### Agent Selection
When asking Copilot to help with implementation, specify which agent's domain applies:
- Architecture decisions: load `agents/btrs-architect/AGENT.md`
- Backend APIs: load `agents/btrs-api-engineer/AGENT.md`
- Frontend work: load `agents/btrs-web-engineer/AGENT.md`
- Testing: load `agents/btrs-qa-test-engineering/AGENT.md`
- (see AGENTS.md for the full list of 24 agents)

### Copilot Chat Workflow
1. Start by referencing AGENTS.md for conventions and anti-patterns
2. Reference the relevant agent's AGENT.md for domain-specific rules
3. Ask Copilot to plan the change before implementing
4. Review the plan, then approve execution
5. After changes, ask Copilot to verify using the 5-point protocol from AGENTS.md

### Copilot Inline Suggestions
When writing code, Copilot's inline suggestions should follow:
- Existing patterns in the codebase (check before accepting suggestions)
- Anti-pattern rules from AGENTS.md (no duplicating existing utilities, no hardcoded tokens)
- Agent scope boundaries (each agent has defined file ownership)

## Key Directories
- `agents/btrs-*/AGENT.md` -- Agent definitions
- `skills/btrs-*/SKILL.md` -- Skill definitions
- `AI/memory/` -- Persistent memory (per-agent, global, sessions)
- `AI/docs/` -- Internal documentation and workflow guides

## Conventions (Mandatory)
1. Always reference AGENTS.md before starting implementation
2. Check the registry before creating new components or utilities
3. Follow the 5-point verification protocol after changes
4. Match existing codebase patterns exactly
5. Update AI/memory/ files after completing work
