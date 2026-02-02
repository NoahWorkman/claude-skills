# Skill Publish - Audit & Publish Claude Skills

When triggered, audit a skill and optionally publish it to the public repo.

## Arguments
$ARGUMENTS should be one of:
- A skill filename (e.g., "wtf.md") — audit and publish that skill
- "audit-all" — audit every skill in ~/.claude/commands/
- "update-readme" — regenerate the public repo README from published skills

## Step 1: Security Audit

Read the skill file(s) from ~/.claude/commands/ and scan for:

**BLOCK if any of these are found:**
- UUIDs (tenant IDs, project IDs, user IDs, API keys)
- Email addresses
- Passwords or tokens
- Internal file paths containing usernames or project-specific directories (e.g., /Users/yourname, /Projects/internal-project/)
- Personal names of real people (not placeholder names)
- Company-specific account names or client names
- Internal URLs (localhost, staging, internal domains)
- MCP server URLs

**WARN but allow:**
- Generic MCP tool references (e.g., mcp__cquenced__canvas_items) — these are public API surface
- Generic directory patterns (e.g., ~/.claude/commands/)

Report result as:
- PASS: No sensitive info found
- FAIL: [list each finding with line number]

If FAIL, stop and show findings. Do not publish.

## Step 2: Publish

If PASS, copy the skill file to your claude-skills repo's `commands/` directory.

## Step 3: Update README

After publishing, regenerate the `README.md` in the root of your claude-skills repo:

For each .md file in the public repo's commands/ folder:
1. Read the file
2. Extract: skill name (from filename), first line description, what it does (1 sentence summary)
3. Add to the skills table in README

Use this README template:

```
# Claude Code Skills

A collection of reusable [Claude Code](https://claude.ai/claude-code) slash command skills.

## Install

Copy any skill file to your Claude Code commands directory:

\`\`\`bash
# Single skill
cp commands/wtf.md ~/.claude/commands/

# All skills
cp commands/*.md ~/.claude/commands/
\`\`\`

Then use in any Claude Code session by typing `/<skill-name>`.

## Skills

| Skill | Description |
|-------|-------------|
[generated rows here]

## Contributing

PRs welcome. Skills must pass a security audit — no API keys, internal URLs, personal names, UUIDs, or org-specific paths.

## License

MIT
```

## Rules
- NEVER publish a skill that fails the audit
- ALWAYS update the README after publishing
- If "audit-all" finds failures, list them but still publish the ones that pass
