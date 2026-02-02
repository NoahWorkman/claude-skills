# Claude Code Skills

A collection of reusable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) slash command skills.

Skills are markdown prompt files that give Claude Code repeatable workflows you can trigger with `/<name>`.

## Install

```bash
# Single skill
cp commands/wtf.md ~/.claude/commands/

# All skills
cp commands/*.md ~/.claude/commands/
```

Then use in any Claude Code session by typing `/<skill-name>`.

## Skills

| Skill | Command | Description |
|-------|---------|-------------|
| **WTF** | `/wtf` | Quick situational briefing — what is this chat about, what should I focus on next (up to 3 items with confidence ratings), and one concrete suggested action to approve or reject. |
| **Retro** | `/retro` | End-of-session retrospective — analyzes the conversation for permission optimizations, security concerns, potential new skills, and workflow improvements. Outputs actionable quick-action list. |
| **Commit & Push** | `/commit-push` | Stages all changes, generates a commit message from the actual diff, commits, and pushes to the current branch. No PR created. |
| **Skill Publish** | `/skill-publish` | Security audits a skill file for sensitive info (UUIDs, API keys, internal paths, personal names), publishes safe skills to the public repo, and regenerates this README. Use with a filename, "audit-all", or "update-readme". |

## Writing Skills

Skills are markdown files in `~/.claude/commands/`. The filename becomes the command (`wtf.md` → `/wtf`).

Tips:
- Use `$ARGUMENTS` to accept input (e.g., `/skill-publish wtf.md`)
- Be specific about output format — Claude follows strict formatting rules well
- Include constraints ("keep under 15 lines", "do NOT list completed tasks")
- Test the skill in a real conversation before publishing

## Security

All skills in this repo pass an automated audit before publishing. The `/skill-publish` skill checks for:
- UUIDs, API keys, tokens, passwords
- Internal file paths with usernames
- Personal names, client names, company accounts
- Internal/staging URLs, MCP server URLs
- Email addresses

If you contribute a skill, it must pass this audit.

## Contributing

PRs welcome. Keep skills:
- **Universal** — useful across projects, not tied to a specific codebase
- **Concise** — under 100 lines of markdown
- **Tested** — try it in a real session first
- **Clean** — no sensitive info (run `/skill-publish audit-all` to verify)

## License

MIT
