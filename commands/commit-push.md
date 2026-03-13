# Commit & Push

Validate, commit, and push all current changes.

## Before committing

1. Run the project's validation command (`pnpm validate`, `npm run build`, `pnpm typecheck`, etc.). Check `package.json` scripts or the project's CLAUDE.md for the right command. If nothing exists, skip but warn the user.
2. If validation fails, stop. Show the errors. Do not commit broken code.

## Preparing the commit

3. Run `git status` to see what's changed (never use `-uall` flag).
4. Run `git diff` to understand the actual changes.
5. Run `git log --oneline -5` to match the project's commit message style.
6. Stage files **by name** -- never use `git add .` or `git add -A`. These can accidentally include secrets, `.env` files, build artifacts, or large binaries.
7. If you see `.env`, credentials, or anything that looks like secrets in the diff, do NOT stage those files. Warn the user.

## Committing

8. Write a commit message that describes **why**, not just what. Keep it concise (1-2 sentences). Match the style from the git log.
9. End the message with: `Co-Authored-By: Claude <noreply@anthropic.com>`
10. Use a HEREDOC to pass the commit message to preserve formatting.

## Pushing

11. Push to the current branch.
12. Report the commit hash and branch name.

## Rules

- Never create a pull request unless asked.
- Never push if validation fails.
- Never amend a previous commit unless explicitly asked.
- If there are no changes to commit, say so and stop.
- If a pre-commit hook fails, fix the issue and create a NEW commit. Do not use `--amend` (that would modify the wrong commit since the failed commit never happened).
