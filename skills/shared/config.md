# BTRS Configuration Reference

Where to write outputs and how the project vault is structured.

## Vault Layout

`btrs/` lives at the project root (where `.git/` lives) and is an Obsidian vault.

```
btrs/
  config.json              # Project configuration
  project-map.md           # Agent scopes and architecture overview
  status.md                # Current work state
  decisions/               # Architecture Decision Records (ADRs)
  specs/                   # Feature specifications + plans (merged)
  conventions/
    registry.md            # Component/utility/hook/type registry
    patterns.md            # ALL convention rules in one file
    anti-patterns.md       # What NOT to do
  .obsidian/               # Obsidian config
```

`btrs/config.json` holds project settings (`framework`, `language`, `testFramework`,
`packageManager`, `srcDir`, `monorepo`, …). Read the file itself — it is self-describing.
If it does not exist, `/btrs` runs init automatically on first use.

## Output Paths

| Output Type | Path |
|-------------|------|
| Architecture decisions | `btrs/decisions/` |
| Feature specs & plans | `btrs/specs/` |
| Conventions & patterns | `btrs/conventions/` |
| Active work status | `btrs/status.md` |

## Writing Rules

1. **Use standard paths.** Do not invent new top-level directories under `btrs/`.
2. **Include frontmatter.** Every `.md` file in `btrs/` must have YAML frontmatter.
3. **Increment IDs.** Scan existing files for the next available ID.
   Specs are `SPEC-NNN`, ADRs are `ADR-NNN` (zero-padded, e.g. `SPEC-001`).
4. **Never overwrite without reading.** Always read an existing file before modifying it.
