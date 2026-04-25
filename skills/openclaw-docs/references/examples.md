# OpenClaw Documentation Skill Examples

## Example 1: Search CLI Commands

```bash
# Search for all gateway-related commands
openclaw-docs search "gateway"

# Search for agent-related commands
openclaw-docs search "agent"

# Search for memory commands
openclaw-docs search "memory"

# Search for cron/scheduling commands
openclaw-docs search "cron"
```

## Example 2: View Specific Documentation

```bash
# View gateway CLI reference
openclaw-docs view "/pl/cli/gateway"

# View agent CLI reference
openclaw-docs view "/pl/cli/agent"

# View skill CLI reference
openclaw-docs view "/pl/cli/skills"

# View configuration CLI reference
openclaw-docs view "/pl/cli/config"
```

## Example 3: Update Cache

```bash
# Update documentation cache (fetch latest)
openclaw-docs update

# View index (after update)
openclaw-docs index
```

## Example 4: Local Documentation Access

```bash
# Search in local documentation files
ls /usr/lib/node_modules/openclaw/docs/reference/templates

# View specific local template
cat /usr/lib/node_modules/openclaw/docs/reference/templates/AGENTS.md

# Explore CLI documentation structure
ls /usr/lib/node_modules/openclaw/docs/cli/
```

## Example 5: Integration with Agent Skills

```markdown
When using this skill in OpenClaw agent context:

### Skill Detection
The agent should automatically read SKILL.md when:
- User asks "how to use OpenClaw gateway"
- User asks "what CLI commands are available"
- User asks "how to configure OpenClaw"
- User asks "OpenClaw security documentation"

### Skill Execution Flow
1. User asks about OpenClaw documentation
2. Agent reads SKILL.md
3. Agent runs appropriate command:
   - `openclaw-docs search "gateway"` for gateway questions
   - `openclaw-docs search "cli"` for CLI questions
   - `openclaw-docs view "/pl/cli/gateway"` for specific pages

### Error Handling
If curl fails to fetch online docs:
1. Fallback to local docs in `/usr/lib/node_modules/openclaw/docs`
2. Use `openclaw docs` CLI command for search
3. Provide general guidance from cached data
```

## Example 6: Caching Strategy

```bash
# Cache directory structure
tree ~/.openclaw/workspace/skills/openclaw-docs/cache/

# Force cache refresh
rm ~/.openclaw/workspace/skills/openclaw-docs/cache/index.json
openclaw-docs index

# Check cache age
stat ~/.openclaw/workspace/skills/openclaw-docs/cache/index.json
```

## Example 7: JSON Index Structure

```json
{
  "source": "https://docs.openclaw.ai",
  "fetched": "2024-04-25T12:00:00Z",
  "pages": [
    {
      "title": "CLI Gateway",
      "href": "/pl/cli/gateway",
      "summary": "CLI Gateway OpenClaw (`openclaw gateway`) — uruchamianie, odpytywanie i wykrywanie Gateway",
      "category": "cli"
    },
    {
      "title": "Skills",
      "href": "/pl/cli/skills",
      "summary": "Dokumentacja CLI dla `openclaw skills` (search/install/update/list/info/check)",
      "category": "cli"
    },
    {
      "title": "Memory",
      "href": "/pl/cli/memory",
      "summary": "Dokumentacja CLI dla `openclaw memory` (status/index/search/promote/promote-explain/rem-harness)",
      "category": "cli"
    }
  ]
}
```

## Example 8: GitHub Source Integration

```bash
# Check GitHub documentation structure
curl -s https://api.github.com/repos/openclaw/openclaw/contents/docs | jq '.[].name'

# Fetch specific doc file from GitHub
curl -s https://raw.githubusercontent.com/openclaw/openclaw/main/docs/cli/gateway.md

# Combine local, cached, and GitHub sources
openclaw-docs search "gateway" | head -50
```