---
name: openclaw-docs-update
description: Update docs index and cache
read_when:
  - Cache expired
  - Need fresh docs
metadata: {"clawdbot":{"emoji":"🔄","requires":{"bins":["curl","jq"]}}}
---

# OpenClaw Docs Update

**更新索引和缓存**

## Quick Commands

```bash
openclaw-docs-update
```

## Implementation

### Features
 - Check cache expiry
 - Update index
 - Update cache

### Integration
 - Updates openclaw-docs-index
 - Updates openclaw-docs-storage