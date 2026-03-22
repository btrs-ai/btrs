---
name: btrs-spec
description: Read, validate, and update feature specs. Check completeness, verify spec-code alignment, update after changes. Use when working with specs.
disable-model-invocation: true
allowed-tools: Read, Write, Edit, Grep, Glob
argument-hint: <spec-id or path>
---

# /btrs-spec

Spec management skill. Reads, validates, and updates feature specs. Checks completeness, verifies spec-code alignment, and updates specs after implementation changes.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for project context.
3. Read `skills/shared/spec-format.md` for the canonical spec template.
4. Read `skills/shared/obsidian-conventions.md` for frontmatter and formatting rules.

### Step 1: Load the spec

1. If the argument is a SPEC-ID (e.g., `SPEC-003`): Glob `.btrs/specs/SPEC-003*.md` and read the file.
2. If the argument is a file path: read the file directly.
3. If no argument: list all specs with their statuses and ask which one to work on.

### Step 2: Determine the operation

Based on the user's intent (derived from context or explicit instruction):

- **Read**: Display the spec with status summary.
- **Validate**: Check the spec for completeness and correctness.
- **Update**: Modify the spec based on implementation progress or requirement changes.
- **Align**: Check that the spec matches the current state of the code.

### Step 3: Validate the spec (if validating)

Check the spec against the template from `skills/shared/spec-format.md`:

1. **Frontmatter completeness**:
   - Required fields present: id, title, status, priority, created, updated, author, agents, tags
   - Dates are valid format (YYYY-MM-DD)
   - Status is a valid value (draft, in-progress, review, complete, cancelled)
   - Agent slugs are valid (cross-reference with `skills/shared/agent-registry.md`)

2. **Content completeness**:
   - Summary section exists and is non-empty
   - Requirements section has at least one functional requirement
   - Acceptance criteria section has at least one criterion
   - Affected files section lists at least one file
   - Agent assignments table is present

3. **Link integrity**:
   - All wiki links resolve to existing `.btrs/` files
   - `depends_on` and `blocks` references point to existing specs
   - Agent output links are valid if referenced

4. **Quality checks**:
   - Acceptance criteria are testable (not vague)
   - Requirements use specific language (not "should work well")
   - Out of scope section is not empty

Report findings:

```markdown
## Spec Validation: {SPEC-ID}

### Frontmatter
- [PASS/FAIL] {check}

### Content
- [PASS/FAIL] {check}

### Links
- [PASS/FAIL] {check}

### Quality
- [PASS/WARN] {check}

**Overall**: VALID | NEEDS WORK
```

### Step 4: Check spec-code alignment (if aligning)

1. Read the affected files listed in the spec.
2. For each file:
   - Does it exist? (New files should exist if spec is in-progress or later.)
   - Does its content match the spec's description?
3. Check each acceptance criterion:
   - Is there code that implements this criterion?
   - Grep for key patterns mentioned in the criterion.
4. Report alignment:

```markdown
## Spec-Code Alignment: {SPEC-ID}

### Affected Files
- [EXISTS/MISSING] `src/path/to/file.ts` -- {matches/differs from spec}

### Acceptance Criteria
- [MET/UNMET] {criterion} -- {evidence}

**Alignment**: {percentage} of criteria met
```

### Step 5: Update the spec (if updating)

1. Read the current spec file.
2. Apply the requested changes (new requirements, updated criteria, status change, etc.).
3. Update the `updated` date in frontmatter.
4. If changing status:
   - `draft` -> `in-progress`: Verify all required sections are filled.
   - `in-progress` -> `review`: Verify all acceptance criteria have been addressed.
   - `review` -> `complete`: Verify all criteria are met and verified.
5. Edit the file in place using the Edit tool.
6. Verify the edit was applied correctly by re-reading the file.

### Step 6: Update related files

1. If TODOs reference this spec, check if their statuses need updating.
2. Update `.btrs/changelog/{today}.md` with the spec operation performed.

## Anti-patterns

- **Do not modify a spec without reading it first.** Always load the current state.
- **Do not mark a spec as complete without checking acceptance criteria.** Use the alignment check.
- **Do not validate against rules not in the spec template.** Use only `skills/shared/spec-format.md` as the standard.
- **Do not update the `updated` date without making an actual change.** Timestamp accuracy matters.
- **Do not remove acceptance criteria that have not been met.** If a criterion is no longer needed, move it to "Out of scope" with a reason.
- **Do not create circular dependencies between specs.** If A depends on B, B must not depend on A.
