#!/bin/bash
# Spawn a parallel Claude Code session in a new macOS Terminal window to execute
# a self-contained build brief.
#
# Usage:   spawn.sh [prompt-path]
# Default: BUILD_PROMPT.md (relative to cwd)
#
# The script:
#   1. Resolves prompt path (absolute or relative to cwd)
#   2. Verifies prompt file exists
#   3. Determines project root (git toplevel or cwd fallback)
#   4. Writes a temp launcher script with the wrapper instruction + prompt
#   5. Opens a new Terminal.app window and runs the launcher
#   6. Prints paths so the user has a record

set -e

PROMPT_INPUT="${1:-BUILD_PROMPT.md}"

# Resolve to absolute path (relative paths resolve against cwd)
if [[ "$PROMPT_INPUT" = /* ]]; then
    PROMPT="$PROMPT_INPUT"
else
    PROMPT="$(pwd)/$PROMPT_INPUT"
fi

if [ ! -f "$PROMPT" ]; then
    echo "ERROR: Prompt file not found: $PROMPT" >&2
    echo "       (resolved from input: $PROMPT_INPUT)" >&2
    exit 1
fi

# Project root: git toplevel if available, else cwd
PROJECT_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# Temp launcher script
TS="$(date +%s)"
LAUNCHER="/tmp/spawn-build-${TS}.sh"

cat > "$LAUNCHER" <<EOF_LAUNCHER
#!/bin/bash
cd "$PROJECT_ROOT" || exit 1
(
printf 'Execute the build brief below. The brief is self-contained — do not re-read prior conversations or files unless the brief explicitly tells you to. Build the deliverables it specifies. Report status when done — what built, what placeholders, what needs handwork.\\n\\n---\\n\\n'
cat "$PROMPT"
) | claude --dangerously-skip-permissions
EOF_LAUNCHER

chmod +x "$LAUNCHER"

# Spawn Terminal.app window. Fall back to manual instructions on failure.
if osascript \
    -e 'tell application "Terminal" to activate' \
    -e "tell application \"Terminal\" to do script \"bash ${LAUNCHER}\"" \
    >/dev/null 2>&1; then
    echo "Spawned new Terminal window."
    echo "  Prompt:    $PROMPT"
    echo "  Project:   $PROJECT_ROOT"
    echo "  Launcher:  $LAUNCHER"
else
    echo "Could not open a new Terminal window automatically."
    echo "Open a new Terminal window manually and run:"
    echo ""
    echo "    bash $LAUNCHER"
    echo ""
    echo "  Prompt:    $PROMPT"
    echo "  Project:   $PROJECT_ROOT"
    exit 2
fi
