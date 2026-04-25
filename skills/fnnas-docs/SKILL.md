---
name: fnnas-docs
description: Crawl and extract FnNAS (飞牛NAS) documentation from official GitHub repositories and developer documentation site, providing NAS operation guidance and API documentation.
read_when:
  - Need FenNAS (飞牛NAS) documentation
  - Searching NAS setup or configuration guides
  - Need Iron Blade Technology project information
metadata: {"clawdbot":{"emoji":"📦","requires":{"bins":["curl","jq","git"]}}}
---

# FenNAS (飞牛NAS) Documentation Crawler

This skill provides tools to fetch, search, and display FenNAS documentation from Iron Blade Technology's GitHub repositories.

## Features

1. **Fetch GitHub repository info**: Get FenNAS repository structure from GitHub
2. **Download documentation**: Clone or download FenNAS documentation
3. **Search documentation**: Search for specific NAS topics
4. **Extract API documentation**: Parse API docs and usage guides
5. **Local caching**: Cache downloaded documentation locally for faster access

## Quick Commands

### Fetch Repository Info
```bash
fnnas-docs info
```

### Search Documentation
```bash
fnnas-docs search "setup"
```

### Download Repository
```bash
fnnas-docs download
```

### Update Local Cache
```bash
fnnas-docs update
```

### List GitHub Topics
```bash
fnnas-docs topics
```

## Implementation Details

### Target Repository
FnNAS (飞牛NAS) official GitHub repositories:
- https://github.com/ophub/fnnas - Main FnNAS repository
- https://github.com/FNOSP/fnnas-api - FnNAS web API
- https://github.com/ckcoding/fnnas-docs - FnNAS developer documentation

Official documentation site:
- https://developer.fnnas.com/docs/guide

### Data Sources
- **GitHub API**: https://api.github.com/repos/ophub/fnnas
- **Repository README**: Primary documentation source
- **GitHub Wiki**: Additional documentation pages
- **Issues and Discussions**: User questions and solutions
- **Official Docs**: https://developer.fnnas.com/docs/guide

### Caching Strategy
- Cache fetched documentation in `~/.openclaw/workspace/skills/fnnas-docs/cache/`
- Cache expiration: 7 days
- Store repository metadata and documentation extracts

### Example Usage Patterns

**When asked about FenNAS installation:**
```bash
fnnas-docs search "install"
```

**When asked about NAS configuration:**
```bash
fnnas-docs search "configuration"
```

**When asked about API usage:**
```bash
fnnas-docs search "API"
```

**When asked about storage setup:**
```bash
fnnas-docs search "storage"
```

## Implementation Files

The skill includes:
1. `scripts/fnnas-docs.sh` - Main script for fetching and searching docs
2. `references/fnnas-repo-info.json` - GitHub repository information
3. `references/fnnas-docs-schema.json` - Structured documentation schema
4. `examples/usage.md` - Example usage patterns
5. `cache/` - Downloaded documentation cache

## Installation Requirements

- `curl` - For fetching GitHub API data
- `jq` - For parsing JSON responses
- `git` - For cloning repositories (optional)
- `grep` - For text filtering
- `awk` - For text processing