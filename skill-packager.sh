#!/bin/bash
#!/bin/bash
# OpenClaw Skill Packager
# This script helps package skills for Git repository

set -e

REPO_DIR="/tmp/claw-skills"
WORKSPACE_SKILLS_DIR="$HOME/.openclaw/workspace/skills"

echo "🔧 OpenClaw Skill Packager"

# Create directory structure
mkdir -p "$REPO_DIR/skills"
mkdir -p "$REPO_DIR/templates"

# Copy skills from workspace
echo "📦 Copying skills from workspace..."
for skill_dir in "$WORKSPACE_SKILLS_DIR"/*; do
    if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        echo "  Copying: $skill_name"
        cp -r "$skill_dir" "$REPO_DIR/skills/"
    fi
done

# Create README with skill list
echo "📝 Creating repository README..."
cat > "$REPO_DIR/README.md" << 'EOF'
# OpenClaw Skills Repository

This repository contains OpenClaw skills for sharing and collaboration.

## Available Skills

EOF

# List skills in README
for skill_dir in "$REPO_DIR/skills"/*; do
    if [ -d "$skill_dir" ] && [ -f "$skill_dir/SKILL.md" ]; then
        skill_name=$(basename "$skill_dir")
        skill_desc=$(grep -m1 "^description:" "$skill_dir/SKILL.md" | sed 's/description: *//' || echo "No description")
        echo "- **$skill_name**: $skill_desc" >> "$REPO_DIR/README.md"
    fi
done

cat >> "$REPO_DIR/README.md" << 'EOF'

## How to Use

### Install a Skill
1. Clone this repository
2. Copy the skill directory to `~/.openclaw/workspace/skills/`
3. OpenClaw will automatically detect and load the skill

### Develop New Skills
1. Use the templates in `templates/` directory
2. Follow the skill specification in `docs/skill-spec.md`

### Update Skills
1. Pull changes from this repository
2. Copy updated skill directories to workspace
3. Restart OpenClaw or reload skills

## Structure
- `skills/` - Ready-to-use skills
- `templates/` - Skill development templates
- `docs/` - Documentation and specifications
- `scripts/` - Utility scripts for skill management

## Contributing
1. Fork this repository
2. Add your skill to `skills/` directory
3. Ensure it includes a proper SKILL.md file
4. Submit a pull request
EOF

# Create skill specification document
mkdir -p "$REPO_DIR/docs"
cat > "$REPO_DIR/docs/skill-spec.md" << 'EOF'
# OpenClaw Skill Specification

## Overview
A skill is a directory containing:
- `SKILL.md` - Main documentation file
- `scripts/` - Optional scripts directory
- `references/` - Optional reference files
- Other supporting files

## SKILL.md Format
The SKILL.md file uses YAML frontmatter for metadata:

```yaml
---
name: Skill Name
description: Brief description of the skill
read_when:
  - Trigger condition 1
  - Trigger condition 2
metadata: {"clawdbot":{"emoji":"📊","requires":{"bins":["node","npm"]}}}
allowed-tools: Bash(skill:*)
---
```

### Required Fields
- `name`: Skill name
- `description`: Skill description
- `read_when`: List of trigger phrases/conditions

### Optional Fields
- `metadata`: Additional metadata for clawdbot
- `allowed-tools`: Tool permission declarations

## Skill Structure
1. **SKILL.md** - Main documentation and tool usage guide
2. **scripts/** - Shell scripts, Python scripts, etc.
3. **references/** - Reference files, examples, templates
4. **config/** - Configuration files (optional)

## Best Practices
- Keep skills focused on specific tasks
- Include clear examples
- Provide troubleshooting guidance
- Test skill before publishing
EOF

# Create basic skill template
cat > "$REPO_DIR/templates/basic-skill/SKILL.md" << 'EOF'
---
name: Basic Skill Template
description: A template for creating OpenClaw skills
read_when:
  - When users ask about [topic]
  - When you need to perform [action]
metadata: {"clawdbot":{"emoji":"🔧","requires":{"bins":["bash"]}}}
allowed-tools: Bash(basic-skill:*)
---

# [Skill Name]

## Purpose
Brief description of what this skill does.

## Installation
```bash
# Installation commands if needed
```

## Usage Examples

### Example 1: Basic Usage
```bash
# Command example
```

### Example 2: Advanced Usage
```bash
# More complex example
```

## Commands Reference

### Command 1
```bash
# Syntax and description
```

### Command 2
```bash
# Syntax and description
```

## Troubleshooting

### Common Issues
- Issue 1: Solution
- Issue 2: Solution

### Debug Tips
- How to debug the skill

## References
- Links to documentation
- Related resources

EOF

# Create skill management scripts
mkdir -p "$REPO_DIR/scripts"
cat > "$REPO_DIR/scripts/skill-install.sh" << 'EOF'
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
EOF

cat > "$REPO_DIR/scripts/skill-update.sh" << 'EOF'
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
EOF

# Create Git configuration
cat > "$REPO_DIR/.gitignore" << 'EOF'
# Ignore workspace-specific files
workspace/
.local/
.env
secrets/
*.log
*.tmp
EOF

echo "🎉 Repository setup complete!"
echo ""
echo "To push to GitHub:"
echo "1. cd /tmp/claw-skills"
echo "2. git add ."
echo "3. git commit -m 'Add skills and templates'"
echo "4. git push origin main"
echo ""
echo "Skills directory now contains:"
ls -la "$REPO_DIR/skills"
echo ""
echo "Total skills packaged: $(ls -1 "$REPO_DIR/skills" | wc -l)"
EOF