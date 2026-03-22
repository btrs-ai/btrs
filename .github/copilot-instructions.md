# BTRS Agents -- GitHub Copilot Instructions

See **AGENTS.md** for the full BTRS instruction set. This file adds Copilot-specific patterns.

## Setup

### Option 1: Global (all repos)

```bash
# Clone BTRS
git clone https://github.com/btrs-ai/btrs.git ~/.btrs

# Copy Copilot instructions to your global config
mkdir -p ~/.github
cp ~/.btrs/.github/copilot-instructions.md ~/.github/copilot-instructions.md
```

### Option 2: Per-repo

Add BTRS to your repo:

```bash
git clone https://github.com/btrs-ai/btrs.git .btrs-agents
cp .btrs-agents/.github/copilot-instructions.md .github/copilot-instructions.md
```

The `.github/copilot-instructions.md` file auto-loads in VS Code with Copilot.

### Option 3: Copilot Chat context

In Copilot Chat, reference files directly:
```
@workspace AGENTS.md
```

## How to Use BTRS with Copilot

### Agent Selection
When asking Copilot to help with implementation, load the right agent's instructions:
- Architecture decisions: reference `agents/btrs-architect/AGENT.md`
- Backend APIs: reference `agents/btrs-api-engineer/AGENT.md`
- Frontend work: reference `agents/btrs-web-engineer/AGENT.md`
- Testing: reference `agents/btrs-qa-test-engineering/AGENT.md`
- Database: reference `agents/btrs-database-engineer/AGENT.md`
- Security: reference `agents/btrs-code-security/AGENT.md`

See AGENTS.md for the full list of 24 agents.

### Copilot Chat Workflow
1. Reference AGENTS.md for conventions and anti-patterns
2. Reference the relevant agent's AGENT.md for domain-specific rules
3. Ask Copilot to plan the change before implementing
4. Review the plan, then approve execution
5. After changes, ask Copilot to verify using the 5-point protocol

### Copilot Inline Suggestions
When writing code, Copilot's inline suggestions should follow:
- Existing patterns in the codebase (check before accepting)
- Anti-pattern rules from AGENTS.md
- Convention rules from `.btrs/conventions/`

## Conventions (from AGENTS.md)
1. Check `.btrs/conventions/registry.md` before creating new components or utilities
2. Follow the 5-point verification protocol after changes
3. Match existing codebase patterns exactly
4. Update `.btrs/` vault files after completing work (code-map, todos, changelog)
