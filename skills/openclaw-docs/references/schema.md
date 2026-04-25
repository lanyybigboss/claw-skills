# OpenClaw Documentation Schema

## Documentation Structure

OpenClaw documentation is organized into several main categories:

### 1. CLI Commands (`/cli`)
- Gateway commands (`openclaw gateway`)
- Agent commands (`openclaw agent`)
- Session commands (`openclaw sessions`)
- Configuration commands (`openclaw config`)
- Skill commands (`openclaw skills`)
- Plugin commands (`openclaw plugins`)
- Memory commands (`openclaw memory`)
- Cron commands (`openclaw cron`)
- Security commands (`openclaw security`)
- Device commands (`openclaw devices`)

### 2. Gateway (`/gateway`)
- Gateway setup and management
- Network model and discovery
- Pairing and authentication
- Local models and CLI backends
- Remote access (SSH tunnels, Tailscale)

### 3. Skills (`/skills`)
- Skill discovery (ClawHub, SkillHub)
- Skill installation and management
- Skill creation and development
- Skill configuration and usage

### 4. Plugins (`/plugins`)
- Plugin architecture
- Plugin marketplace
- Plugin installation and configuration
- MCP integration

### 5. Security (`/security`)
- Security architecture
- Threat modeling (MITRE ATLAS)
- Formal verification
- Secret management
- Credential handling

### 6. Concepts (`/concepts`)
- Markdown formatting
- Rich output protocol
- Session management and compaction
- Prompt caching
- Usage tracking and costs
- Timezone handling
- Transcript hygiene

### 7. Tools (`/tools`)
- Camera tools
- Canvas tools
- Screen tools
- Exec tools
- Browser automation
- Text-to-speech (TTS)

### 8. Reference (`/reference`)
- TypeBox schemas
- Device models database
- API usage costs
- Memory configuration
- Onboarding wizard reference

## Data Sources

1. **docs.openclaw.ai** - Official documentation website
2. **GitHub Repository** - https://github.com/openclaw/openclaw (source)
3. **Local Installation** - `/usr/lib/node_modules/openclaw/docs/`
4. **CLI Commands** - `openclaw docs` command for searching

## API Endpoints

- Main site: https://docs.openclaw.ai
- JSON index endpoint: https://docs.openclaw.ai (embeds JSON structure)
- GitHub API: https://api.github.com/repos/openclaw/openclaw/contents/docs
- Local CLI: `openclaw docs <query>` for live search

## Caching Strategy

### Cache Location
`~/.openclaw/workspace/skills/openclaw-docs/cache/`

### Cache Files
- `index.json` - Main documentation index
- `cli.json` - CLI command reference
- `gateway.json` - Gateway documentation
- `skills.json` - Skills documentation
- `plugins.json` - Plugins documentation
- `security.json` - Security documentation

### Cache Expiry
- Default: 24 hours
- Can be forced to update with `update` command

## Usage Examples

### Search Examples
```bash
# Search for CLI commands
openclaw-docs search "openclaw gateway"

# Search for configuration
openclaw-docs search "configuration"

# Search for installation
openclaw-docs search "install"
```

### View Examples
```bash
# View CLI gateway documentation
openclaw-docs view "/pl/cli/gateway"

# View skill management
openclaw-docs view "/pl/cli/skills"

# View security concepts
openclaw-docs view "/pl/security"
```

### Integration with OpenClaw
This skill works with `openclaw docs` CLI command and can be used to:
1. Provide documentation snippets to users
2. Answer questions about OpenClaw usage
3. Help troubleshoot configuration issues
4. Guide skill development