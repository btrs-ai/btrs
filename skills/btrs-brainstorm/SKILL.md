---
name: btrs-brainstorm
description: Collaborative design exploration before implementation. Use before any creative work — creating features, building components, adding functionality, or modifying behavior. Explores intent, requirements, and design before code.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *)
argument-hint: <feature idea or problem description>
---

# /btrs-brainstorm

Turn ideas into fully formed designs and specs through collaborative dialogue. This skill is the entry point for all creative work — before any code is written, any component scaffolded, or any feature implemented.

<HARD-GATE>
Do NOT invoke any implementation skill, write any code, scaffold any project, or take any implementation action until you have presented a design and the user has approved it. This applies to EVERY idea regardless of perceived simplicity.
</HARD-GATE>

## Anti-Pattern: "This Is Too Simple To Need A Design"

Every project goes through this process. A config change, a single utility function, a small refactor — all of them. "Simple" features are where unexamined assumptions cause the most wasted work. The design can be short (a few sentences for truly simple ideas), but you MUST present it and get approval.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `btrs/` paths and project structure.
2. Read `skills/shared/discipline-protocol.md` for TDD, verification, and debugging mandates.
3. Read `skills/shared/workflow-protocol.md` for status display and lifecycle requirements.
4. Read `btrs/config.json` if it exists for framework, language, and tooling context.
5. Read all `btrs/conventions/` files for existing project patterns and coding standards.
6. Read `skills/shared/spec-format.md` for the canonical spec template.
7. Read `skills/shared/agent-registry.md` for available agents and their domains.

### Step 1: Explore context

Before asking a single question, understand the current project state:

1. Glob `btrs/specs/SPEC-*.md` to find existing specs — avoid overlap and identify related work.
2. Read `btrs/decisions/` for relevant ADRs that constrain design choices.
3. Run `git log --oneline -20` to check recent commits for related work.
4. Glob `btrs/code-map/` to understand existing components, utilities, and system boundaries.
5. Note anything relevant to the user's idea — you will reference this during questioning.

### Step 2: Understand the idea

Ask clarifying questions to fully understand what the user wants to build.

**Rules:**
- One question at a time. Never combine multiple questions into a single message.
- Prefer multiple choice questions when the options are knowable. Open-ended is fine when they are not.
- Focus on: purpose, constraints, success criteria, affected areas, and user expectations.
- Before going deep on details, assess scope: if the idea describes multiple independent subsystems (e.g., "build a platform with chat, billing, and analytics"), flag this immediately. Do not spend questions refining details of a project that needs decomposition first.
- If the project is too large for a single spec, help the user decompose into sub-projects: what are the independent pieces, how do they relate, what order should they be built? Then brainstorm the first sub-project through the normal flow. Each sub-project gets its own spec, plan, and implementation cycle.

**Question categories (in rough order):**
1. **Purpose** — What problem does this solve? Who benefits?
2. **Constraints** — What must it work with? What cannot change?
3. **Scope** — What is included? What is explicitly excluded?
4. **Success criteria** — How do we know it works? What does "done" look like?
5. **Affected areas** — Which existing systems or files are touched?
6. **Trade-offs** — Speed vs. quality? Flexibility vs. simplicity?

### Step 3: Propose approaches

Once you understand the idea, present 2-3 different approaches with trade-offs.

- Lead with your recommended approach and explain why.
- For each approach, cover: summary, pros, cons, estimated complexity, and affected agents.
- If the decision is complex and involves weighted criteria, use the btrs-propose scoring matrix format (weights: Alignment 30%, Feasibility 25%, Maintainability 20%, Risk 15%, Velocity 10%).
- Let the user pick or suggest a hybrid. Do not proceed until an approach is selected.

### Step 4: Present design

Present the design in sections scaled to their complexity. A few sentences if straightforward, up to 200-300 words if nuanced.

**After each section, ask whether it looks right before continuing.**

**Sections to cover:**
1. **Architecture** — High-level structure, component relationships, boundaries.
2. **Components** — What new things are created? What existing things are modified?
3. **Data flow** — How does data move through the system?
4. **Error handling** — What can go wrong? How is it handled?
5. **Testing approach** — What kinds of tests? What coverage goals?
6. **Agent assignments** — Which BTRS agents will be involved and in what order?

**Design principles:**
- Follow existing project patterns discovered in Step 0. Do not invent new patterns when existing ones work.
- Break the system into smaller units that each have one clear purpose, communicate through well-defined interfaces, and can be understood and tested independently.
- For each unit: what does it do, how do you use it, and what does it depend on?
- Where existing code has problems that affect the work (e.g., a file grown too large, unclear boundaries), include targeted improvements as part of the design. Do not propose unrelated refactoring.
- YAGNI ruthlessly. Remove unnecessary features, abstractions, and options from all designs.

### Step 5: Write spec

Once the user approves the design, write the formal spec.

1. **Assign spec ID:** Glob `btrs/specs/SPEC-*.md` to find the highest existing SPEC number. Increment by 1 and zero-pad to 3 digits.
2. **Write spec file** to `btrs/specs/SPEC-{NNN}-{slug}.md` using the template from `skills/shared/spec-format.md`.
3. **Include all sections:** title, status (`draft`), priority, summary, background, requirements (functional + non-functional), user stories, technical design, affected files (new + modified), agent assignments with dependencies, acceptance criteria, out of scope, open questions, references.
4. **Use wiki links** to connect the spec to related ADRs, conventions, and existing specs.
5. **Commit the spec:**
   ```
   git add btrs/specs/SPEC-{NNN}-{slug}.md
   git commit -m "Add SPEC-{NNN}: {title} (draft)"
   ```

### Step 6: Spec self-review

After writing the spec, review it with fresh eyes:

1. **Placeholder scan:** Any "TBD", "TODO", incomplete sections, or vague requirements? Fix them.
2. **Internal consistency:** Do any sections contradict each other? Does the architecture match the feature descriptions? Do agent assignments cover all tasks?
3. **Scope check:** Is this completable in 1-5 working sessions? If not, it needs decomposition.
4. **Ambiguity check:** Could any requirement be interpreted two different ways? If so, pick one and make it explicit.

Fix any issues inline. No need to announce fixes — just fix and move on.

### Step 7: User review gate

After the self-review passes, present the spec for user approval:

> "Spec written and committed to `btrs/specs/SPEC-{NNN}-{slug}.md`. Please review it and let me know if you want changes before we plan implementation."

Wait for the user's response. If they request changes, make them, re-run the self-review, and re-commit. Only proceed once the user approves.

### Step 8: Transition to planning

Once the user approves the spec, invoke `btrs-plan` to create a structured implementation plan.

**The terminal state is invoking btrs-plan.** Do NOT invoke btrs-implement, btrs-init, or any other implementation skill. The ONLY skill you invoke after brainstorming is btrs-plan.

## Key Principles

- **One question at a time** — Do not overwhelm with multiple questions in a single message.
- **Multiple choice preferred** — Easier to answer than open-ended when the options are knowable.
- **YAGNI ruthlessly** — Remove unnecessary features, abstractions, and options from all designs.
- **Explore alternatives** — Always propose 2-3 approaches before settling on one.
- **Incremental validation** — Present design section by section, get approval before moving on.
- **Be flexible** — Go back and revisit earlier decisions when new information changes the picture.
- **Follow existing patterns** — The codebase already has conventions. Use them.

## Anti-Patterns

- Do not skip the question phase for "simple" features.
- Do not present only one approach.
- Do not write code examples in the design — that is implementation, not design.
- Do not skip the user review gate.
- Do not invoke any skill other than btrs-plan after approval.
- Do not create a spec that overlaps with an existing spec without noting the relationship and linking to it.
- Do not propose patterns that conflict with existing project conventions.
