# Claude Code Instructions for this repo

## Security Rule

NEVER commit files containing:
- Absolute file paths with usernames (e.g., /Users/yourname/, /home/yourname/)
- UUIDs, API keys, tokens, or passwords
- Personal names, email addresses, or client/company names
- Internal URLs (localhost, staging, internal domains)
- MCP server URLs

Before writing or editing any file in this repo, scan the content for the above. If found, replace with generic placeholders.

## Publishing Skills

When copying a skill from ~/.claude/commands/ to this repo's commands/ directory:
1. Read the source file
2. Replace any local paths with generic references
3. Replace any personal/org-specific names with generic examples
4. Write the sanitized version to commands/
5. Update README.md with the new skill entry

The private copy in ~/.claude/commands/ can contain real paths and names. The public copy in this repo must not.
