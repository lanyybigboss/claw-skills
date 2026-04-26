---
name: openclaw-docs-view
description: View docs pages with clean formatting
read_when:
  - View docs pages
  - Need docs content
metadata: {"clawdbot":{"emoji":"📖","requires":{"bins":["curl","sed","grep"]}}}
---

# OpenClaw Docs View

**查看文档页面，去除HTML噪音**

## Quick Commands

```bash
openclaw-docs-view /cli
```

## Implementation

### Features
 - Fetch or use cached pages
 - Clean HTML formatting
 - Extract technical content

### Integration
 - Uses openclaw-docs-storage cache
 - Uses openclaw-docs-index paths