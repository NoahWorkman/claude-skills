# Claude Code Skills

A collection of reusable [Claude Code](https://docs.anthropic.com/en/docs/claude-code) slash command skills.

Skills are markdown prompt files that give Claude Code repeatable workflows you can trigger with `/<name>`.

## Install

```bash
# Single flat skill (commands/)
cp commands/wtf.md ~/.claude/commands/

# All flat skills
cp commands/*.md ~/.claude/commands/

# Folder skill (skills/) -- preserves subdirectory structure
cp -r skills/skill-create ~/.claude/skills/
```

Then use in any Claude Code session by typing `/<skill-name>`.

**Flat vs folder skills:** Flat skills are single `.md` files in `commands/`. Folder skills live in `skills/` with subdirectories for scripts, references, assets, and data -- they support progressive disclosure and deterministic tooling.

## Skills

### Session Management

| Skill | Command | Description |
|-------|---------|-------------|
| **WTF** | `/wtf` | Quick situational briefing: what is this chat about, what should I focus on next (up to 3 items with confidence ratings), and one concrete suggested action. |
| **Retro** | `/retro` | End-of-session retrospective: permission optimization, security review, skill/agent audit, memory assessment, session hygiene, and a learning takeaway. Outputs an actionable quick-action list. |
| **Handoff** | `/handoff` | Generate a resume prompt for picking up this conversation in a new session. Creates a copy-pasteable block with context, key files, status, and next steps. |

### Code & Git

| Skill | Command | Description |
|-------|---------|-------------|
| **Commit & Push** | `/commit-push` | Validates the build, stages changes by name (not `git add .`), generates a commit message from the diff, commits with co-author trailer, and pushes. |
| **Git Sanitize** | `/git-sanitize` | Scans staged changes and full git history for sensitive info (paths, UUIDs, keys, emails, internal URLs). Reports findings and recommends safe-to-push or squash-needed. |
| **Skill Publish** | `/skill-publish` | Security audits a skill file for sensitive data, publishes safe skills to a public repo, and regenerates the README. Use with a filename, `audit-all`, or `update-readme`. |

### Product & Planning

| Skill | Command | Description |
|-------|---------|-------------|
| **PRD** | `/prd` | Generate a production-grade Product Requirements Document with discovery interview, user stories, technical specs, and phased roadmap. |
| **PRD Audit** | `/prd-audit` | Validate an existing PRD against the PRD skill schema. Checks section coverage, requirements quality, and flags vague language. |
| **File Bug from Chat** | `/file-bug-from-chat` | Extract bugs, tech debt, and architecture issues from the current conversation. Categorizes, prioritizes, and generates structured reports. |

### Frontend & Media

| Skill | Command | Description |
|-------|---------|-------------|
| **Contrast Check** | `/contrast-check` | Audit Tailwind CSS text/background color pairings for readability on dark themes. Scans `.tsx`, `.jsx`, `.vue`, `.html`, `.svelte` including dynamic classes. Flags FAIL/WARNING with suggested fixes. |
| **YT Download** | `/yt-download` | Download YouTube channel/playlist videos at max quality using `bestvideo+bestaudio`, merge with ffmpeg, embed metadata, and auto-verify codecs and resolution. |

### Skill Development

| Skill | Command | Description |
|-------|---------|-------------|
| **Skill Create** | `/skill-create` | Create new skills with best-practice structure or audit existing ones. Scaffolds folder skills with frontmatter, gotchas, progressive disclosure. Includes a deterministic 11-point structural audit (A/B/C/D grading) plus LLM content review. |

### Utilities

| Skill | Command | Description |
|-------|---------|-------------|
| **GitHub Doc** | `/github-doc` | Fetch and display content from GitHub repos via `gh` CLI. Handles files, directories, PRs, issues, releases, and repo overviews. Smart fallbacks for 404s. |

## Writing Skills

Skills are markdown files in `~/.claude/commands/`. The filename becomes the command (`wtf.md` -> `/wtf`).

Tips:
- Use `$ARGUMENTS` to accept input (e.g., `/skill-publish wtf.md`)
- Be specific about output format -- Claude follows strict formatting rules well
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
- **Universal** -- useful across projects, not tied to a specific codebase
- **Concise** -- under 150 lines of markdown
- **Tested** -- try it in a real session first
- **Clean** -- no sensitive info (run `/skill-publish audit-all` to verify)

## License

MIT
