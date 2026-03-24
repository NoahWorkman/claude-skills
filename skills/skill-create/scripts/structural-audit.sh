#!/usr/bin/env bash
# structural-audit.sh -- Deterministic structural checks for Claude Code skills
# Usage: bash structural-audit.sh <skill-path>
#   <skill-path> can be:
#     - A skill folder (e.g., ~/.claude/skills/my-skill)
#     - A flat command file (e.g., ~/.claude/commands/my-command.md)
# Output: JSON to stdout with check results, score, and grade
# Exit code: always 0 (results in stdout, not exit codes)

set -u

SKILL_PATH="${1:?Usage: structural-audit.sh <skill-path>}"

# Determine if this is a folder skill or flat command
IS_FOLDER=false
SKILL_FILE=""
SKILL_NAME=""

if [ -d "$SKILL_PATH" ]; then
    IS_FOLDER=true
    SKILL_FILE="$SKILL_PATH/SKILL.md"
    SKILL_NAME="$(basename "$SKILL_PATH")"
elif [ -f "$SKILL_PATH" ]; then
    SKILL_FILE="$SKILL_PATH"
    SKILL_NAME="$(basename "$SKILL_PATH" .md)"
else
    echo "{\"error\": \"Path not found: $SKILL_PATH\", \"skill\": \"unknown\", \"score\": 0, \"grade\": \"D\"}"
    exit 0
fi

# Helper: check if file exists and contains content
has_content() {
    [ -f "$1" ] && [ -s "$1" ]
}

# Extract frontmatter (between first two --- lines)
FRONTMATTER=""
if has_content "$SKILL_FILE"; then
    FRONTMATTER=$(awk '/^---$/{n++; next} n==1{print} n>=2{exit}' "$SKILL_FILE")
fi

# S1: Folder structure (not flat) -- has directory with SKILL.md inside
S1=false
if [ "$IS_FOLDER" = true ] && [ -f "$SKILL_FILE" ]; then
    S1=true
fi

# S2: Frontmatter exists (--- delimiters)
S2=false
if has_content "$SKILL_FILE"; then
    DELIMITER_COUNT=$(grep -c '^---$' "$SKILL_FILE" 2>/dev/null | tail -1 || echo "0")
    if [ "$DELIMITER_COUNT" -ge 2 ]; then
        S2=true
    fi
fi

# S3: name in frontmatter
S3=false
if [ -n "$FRONTMATTER" ] && echo "$FRONTMATTER" | grep -q '^name:'; then
    S3=true
fi

# S4: description in frontmatter
S4=false
if [ -n "$FRONTMATTER" ] && echo "$FRONTMATTER" | grep -q '^description:'; then
    S4=true
fi

# S5: user-invocable declared
S5=false
if [ -n "$FRONTMATTER" ] && echo "$FRONTMATTER" | grep -q 'user-invocable:'; then
    S5=true
fi

# S6: category declared (one of 9 types)
S6=false
VALID_CATEGORIES="library/api reference|product verification|data fetching|business process|code scaffolding|code quality|ci/cd & deployment|runbooks|infrastructure ops"
if [ -n "$FRONTMATTER" ]; then
    CATEGORY_LINE=$(echo "$FRONTMATTER" | grep '^category:' | head -1 | sed 's/^category:[[:space:]]*//' | tr -d '"' | tr -d "'" | tr '[:upper:]' '[:lower:]' | tr '-' ' ')
    if [ -n "$CATEGORY_LINE" ] && echo "$CATEGORY_LINE" | grep -qiE "$VALID_CATEGORIES"; then
        S6=true
    fi
fi

# S7: ## Gotchas section present
S7=false
if has_content "$SKILL_FILE" && grep -q '## Gotchas' "$SKILL_FILE" 2>/dev/null; then
    S7=true
fi

# S8: References other files in folder
S8=false
if has_content "$SKILL_FILE" && grep -qE '(references/|assets/|scripts/|data/)' "$SKILL_FILE" 2>/dev/null; then
    S8=true
fi

# S9: Has subdirectory structure (at least one subdir)
S9=false
if [ "$IS_FOLDER" = true ]; then
    SUBDIR_COUNT=$(find "$SKILL_PATH" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' ')
    if [ "$SUBDIR_COUNT" -gt 0 ]; then
        S9=true
    fi
fi

# S10: Description contains trigger language
S10=false
if has_content "$SKILL_FILE" && grep -qiE '(use when|triggers? on|invoke when)' "$SKILL_FILE" 2>/dev/null; then
    S10=true
fi

# S11: Data/state storage configured (data/ dir or config.json exists)
S11=false
if [ "$IS_FOLDER" = true ]; then
    if [ -d "$SKILL_PATH/data" ] || [ -f "$SKILL_PATH/config.json" ]; then
        S11=true
    fi
fi

# Calculate score
SCORE=0
for check in S1 S2 S3 S4 S5 S6 S7 S8 S9 S10 S11; do
    val=$(eval echo "\$$check")
    if [ "$val" = "true" ]; then
        SCORE=$((SCORE + 1))
    fi
done

# Determine grade
if [ $SCORE -ge 9 ]; then
    GRADE="A"
elif [ $SCORE -ge 7 ]; then
    GRADE="B"
elif [ $SCORE -ge 5 ]; then
    GRADE="C"
else
    GRADE="D"
fi

# Output JSON
cat <<EOF
{
  "skill": "$SKILL_NAME",
  "path": "$SKILL_PATH",
  "is_folder": $IS_FOLDER,
  "checks": {
    "S1_folder_structure": $S1,
    "S2_frontmatter_exists": $S2,
    "S3_name_in_frontmatter": $S3,
    "S4_description_in_frontmatter": $S4,
    "S5_user_invocable": $S5,
    "S6_category_declared": $S6,
    "S7_gotchas_section": $S7,
    "S8_references_files": $S8,
    "S9_subdirectory_structure": $S9,
    "S10_trigger_language": $S10,
    "S11_data_storage": $S11
  },
  "score": $SCORE,
  "max_score": 11,
  "grade": "$GRADE"
}
EOF
