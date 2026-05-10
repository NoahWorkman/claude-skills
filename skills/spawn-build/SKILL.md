---
name: spawn-build
description: Launch a parallel Claude Code session in a fresh macOS Terminal window to execute a self-contained build brief. Use when a spec or prompt file is ready to execute and the user wants to watch the build run in a separate window without losing the current session. Triggers on /spawn-build, "spawn a build", "run this brief in a new window", or any request to delegate execution of a brief to a parallel agent. Default brief path is BUILD_PROMPT.md (relative to cwd); accepts any relative or absolute path as an argument.
---

# spawn-build

## What this skill does

Runs `scripts/spawn.sh` to spawn a parallel Claude Code session in a new macOS Terminal window. The new agent receives a wrapper instruction plus the contents of a self-contained build brief, then executes the brief.

## How to invoke

1. Determine the prompt path:
   - If the user supplied an argument (e.g., `/spawn-build path/to/brief.md`), use it.
   - Otherwise, use the default `BUILD_PROMPT.md` (relative to the current working directory).

2. Run the spawn script via Bash:

```bash
bash ~/.claude/skills/spawn-build/scripts/spawn.sh [prompt-path]
```

The script handles path resolution, file existence checks, project-root detection (`git rev-parse --show-toplevel` with cwd fallback), temp launcher generation, and `osascript` Terminal spawning. Do not duplicate that logic — invoke the script.

3. Report the script's stdout to the user verbatim. It contains the resolved prompt path, project directory, and launcher path. Do not monitor the spawned agent — it runs in parallel.

## What the spawned agent receives

The launcher pipes a wrapper instruction plus the brief into a fresh `claude --dangerously-skip-permissions` session. The wrapper says:

> Execute the build brief below. The brief is self-contained — do not re-read prior conversations or files unless the brief explicitly tells you to. Build the deliverables it specifies. Report status when done — what built, what placeholders, what needs handwork.

The wrapper is opinionated for build-style briefs that produce file deliverables. If the brief is a different shape (e.g., research/analysis), edit the temp launcher before it runs, or invoke `claude` directly with custom wrapper text.

## Failure modes

- **Prompt file missing** → script exits 1 with a clear error. Tell the user the resolved path that didn't resolve and suggest correcting the argument.
- **`osascript` blocked or non-macOS** → script exits 2 and prints the manual command. Pass that command to the user verbatim.
- **`claude` not in PATH inside the spawned shell** → user environment issue; the new Terminal window will show the error. Mention this possibility in the report so the user can debug if needed.

## Notes for the executing Claude

- This skill spawns a parallel agent. Do not try to read its output, monitor its progress, or edit files it might be writing.
- The temp launcher is not auto-deleted. The user can re-run it from any terminal.
- The skill targets Terminal.app. iTerm2 users can edit `scripts/spawn.sh` to target iTerm; the rest of the flow is identical.
