---
name: api-router
description: Switch APIs when token depleted
read_when:
  - API tokens depleted
  - Need smart routing
metadata: {"clawdbot":{"emoji":"🔄","requires":{"bins":["curl","jq"]}}}
---

# API Router

**词元耗尽时自动切换API**

## Quick Commands

```bash
api-router status
api-router check-tokens
api-router switch-api kuaipao
```

## Implementation

### Features
- Monitor token usage
- Switch API providers
- Smart routing logic
- Multi-API configuration