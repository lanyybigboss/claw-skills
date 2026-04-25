---
name: openclaw-docs
description: Crawl and extract OpenClaw official documentation from docs.openclaw.ai, enabling quick reference lookup and documentation search.
read_when:
  - Searching OpenClaw documentation
  - Need information about OpenClaw CLI commands
  - Learning OpenClaw configuration and usage
metadata: {"clawdbot":{"emoji":"📚","requires":{"bins":["curl","jq"]}}}
---

# OpenClaw Documentation Crawler

This skill provides tools to fetch, search, and display OpenClaw documentation from the official docs.openclaw.ai website.

## Features

1. **Fetch full documentation index**: Get all pages and their URLs from docs.openclaw.ai
2. **Search documentation**: Search for specific topics or keywords
3. **View specific documentation**: Retrieve and display a specific documentation page
4. **Local caching**: Cache downloaded documentation locally for faster access

## Quick Commands

### Get Documentation Index
```bash
openclaw-docs index
```

### Search Documentation
```bash
openclaw-docs search "gateway"
```

### View Specific Page
```bash
openclaw-docs view "/pl/cli/gateway"
```

### Update Local Cache
```bash
openclaw-docs update
```

## Implementation Details

### Data Sources
- **Primary**: https://docs.openclaw.ai (online documentation)
- **Secondary**: /usr/lib/node_modules/openclaw/docs/ (local documentation files)
- **GitHub**: https://github.com/openclaw/openclaw (source repository)

### Caching Strategy
- Cache fetched documentation in `~/.openclaw/workspace/skills/openclaw-docs/cache/`
- Cache expiration: 24 hours
- Automatic updates when cache is stale

### Example Usage Patterns

**When asked about OpenClaw CLI commands:**
```bash
openclaw-docs search "openclaw gateway"
```

**When asked about configuration:**
```bash
openclaw-docs search "configuration"
```

**When asked about installation:**
```bash
openclaw-docs search "install"
```

## Implementation Files

The skill includes:
1. `scripts/openclaw-docs.sh` - Main script for fetching and searching docs
2. `references/openclaw-docs-index.json` - Full documentation index cache
3. `references/openclaw-docs-schema.json` - Structured documentation schema
4. `examples/usage.md` - Example usage patterns

## Installation Requirements

- `curl` - For fetching web content
- `jq` - For parsing JSON responses
- `grep` - For text filtering