#!/bin/bash
#!/bin/bash
# Skill Install Script
# Installs a skill from this repository to OpenClaw workspace

set -e

SKILL_NAME="$1"
REPO_DIR="$(dirname "$0")/.."
WORKSPACE_SKILLS_DIR="$HOME/.openclaw/workspace/skills"

if [ -z "$SKILL_NAME" ]; then
    echo "Usage: ./skill-install.sh <skill-name>"
    echo "Available skills:"
    for skill in "$REPO_DIR/skills"/*; do
        if [ -d "$skill" ]; then
            echo "  $(basename "$skill")"
        fi
    done
    exit 1
fi

SKILL_DIR="$REPO_DIR/skills/$SKILL_NAME"
if [ ! -d "$SKILL_DIR" ]; then
    echo "Error: Skill '$SKILL_NAME' not found in repository"
    exit 1
fi

echo "Installing skill: $SKILL_NAME"
cp -r "$SKILL_DIR" "$WORKSPACE_SKILLS_DIR/"
echo "✅ Skill installed successfully!"
