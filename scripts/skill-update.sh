#!/bin/bash
#!/bin/bash
# Skill Update Script
# Updates all skills from repository to workspace

set -e

REPO_DIR="$(dirname "$0")/.."
WORKSPACE_SKILLS_DIR="$HOME/.openclaw/workspace/skills"

echo "Updating skills from repository..."

for skill_dir in "$REPO_DIR/skills"/*; do
    if [ -d "$skill_dir" ]; then
        skill_name=$(basename "$skill_dir")
        echo "  Updating: $skill_name"
        
        # Remove existing skill if present
        rm -rf "$WORKSPACE_SKILLS_DIR/$skill_name"
        
        # Copy new skill
        cp -r "$skill_dir" "$WORKSPACE_SKILLS_DIR/"
    fi
done

echo "✅ All skills updated successfully!"
