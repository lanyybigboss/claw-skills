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
