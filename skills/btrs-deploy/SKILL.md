---
name: btrs-deploy
description: Deployment and release workflow with pre-deploy checks, changelog, and post-deploy verification. Use when deploying, releasing, or shipping.
disable-model-invocation: true
allowed-tools: Agent, Read, Write, Edit, Grep, Glob, Bash(git *), Bash(npm *), Bash(npx *), Bash(docker *)
argument-hint: <environment or version>
---

# /btrs-deploy

Deployment and release workflow skill. Runs pre-deploy checks, generates changelogs, bumps versions, executes deployment steps, and performs post-deploy verification.

## Workflow

### Step 0: Read configuration

1. Read `skills/shared/config.md` to resolve `.btrs/` paths and project structure.
2. Read `.btrs/config.json` if it exists for framework, language, and tooling context.
3. Read `.btrs/conventions/` for any deployment-related conventions.
4. Read `.btrs/decisions/` for deployment-related ADRs (infrastructure, CI/CD choices).

### Step 1: Determine deployment target

1. Parse the argument:
   - Environment name: `staging`, `production`, `dev`
   - Version string: `1.2.0`, `patch`, `minor`, `major`
   - Both: `production 1.2.0`
2. If no argument, ask the user to specify environment and version strategy.

### Step 2: Pre-deploy checks

Run these checks before any deployment action. All must pass for production deploys; warnings are acceptable for staging.

1. **Git state**: Working tree is clean (`git status`). No uncommitted changes.
2. **Branch**: On the correct branch for the target environment (e.g., `main` for production).
3. **Tests**: Check that the test suite passes (`npm test` or equivalent).
4. **Build**: Check that the project builds successfully (`npm run build` or equivalent).
5. **Convention compliance**: Run a quick `/btrs-verify` pass on recently changed files.
6. **Open critical TODOs**: Check `.btrs/todos/` for any critical-priority items that are incomplete.
7. **Spec completion**: Check `.btrs/specs/` for any in-progress specs that should be completed first.

Report the pre-deploy checklist:

```markdown
## Pre-Deploy Checklist
- [PASS/FAIL] Git working tree clean
- [PASS/FAIL] On correct branch ({branch})
- [PASS/FAIL] Tests passing
- [PASS/FAIL] Build succeeds
- [PASS/WARN] Convention compliance
- [PASS/WARN] No critical open TODOs
- [PASS/WARN] All release specs complete
```

If any FAIL, stop and report. Do not proceed.

### Step 3: Generate changelog

1. Read `.btrs/changelog/` files since the last release tag.
2. Read git log since the last release tag.
3. Categorize changes:
   - **Features**: New functionality
   - **Fixes**: Bug fixes
   - **Breaking**: Breaking changes
   - **Other**: Refactors, docs, chores
4. Write the release changelog section.

### Step 4: Version bump

1. Determine the new version based on the argument or changelog analysis:
   - Breaking changes present: major bump
   - Features present: minor bump
   - Fixes only: patch bump
2. Update version in `package.json` (or equivalent manifest).
3. Update any other files that reference the version.

### Step 5: Confirm with user

Present the deployment plan:

```markdown
## Deployment Plan
- **Environment**: {target}
- **Version**: {old} -> {new}
- **Changes**: N features, N fixes, N breaking
- **Pre-deploy**: All checks passed

Proceed with deployment? (yes/no)
```

Wait for explicit user approval.

### Step 6: Execute deployment

1. Create a git tag for the release version.
2. Run the project's deploy script if one exists.
3. If no deploy script, guide the user through manual steps based on the infrastructure (read from ADRs).

### Step 7: Post-deploy verification

1. Check that the deployment completed without errors.
2. If health check endpoints exist, verify they respond correctly.
3. Report deployment status.

### Step 8: Write output to vault

1. Write the release notes to `.btrs/changelog/{version}.md` with proper frontmatter.
2. Write deployment record to `.btrs/agents/{deployer-slug}/deploy-{version}.md`.
3. Update `.btrs/changelog/{today}.md` with the deployment event.

## Anti-patterns

- **Do not deploy without pre-deploy checks.** Even "just staging" deserves a clean build and passing tests.
- **Do not deploy with uncommitted changes.** The deployed code must match what is in version control.
- **Do not skip the user confirmation step.** Deployments are irreversible actions that require explicit approval.
- **Do not auto-determine version for production.** Always confirm the version bump with the user.
- **Do not deploy if critical TODOs are open.** Address them first or get explicit user acknowledgment.
- **Do not forget post-deploy verification.** A deployment is not done until it is confirmed working.
