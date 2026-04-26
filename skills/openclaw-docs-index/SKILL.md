---
name: openclaw-docs-index
description: Fetch OpenClaw docs index from docs.openclaw.ai
read_when:
  - Need docs index
  - Cache docs metadata
metadata: {"clawdbot":{"emoji":"📄","requires":{"bins":["curl","jq"]}}}
---

# OpenClaw Docs Index

**只负责索引获取和存储**

## Features

- Fetch OpenClaw docs index from docs.openclaw.ai
- Cache index in JSON format
- 24-hour cache expiration
- Return index data for other skills

## Quick Commands

### Fetch index
```bash
openclaw-docs-index fetch
```

### View cached index
```bash
openclaw-docs-index view
```

## Implementation

### Data Sources
- Primary: https://docs.openclaw.ai
- Index file: openclaw-docs-index.json

### Cache Strategy
- Cache location: ~/.openclaw/workspace/skills/openclaw-docs-index/cache/
- Cache expiration: 24 hours

## Script

```bash
#!/bin/bash
#!/bin/bash
# openclaw-docs-index.sh

CACHE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-index/cache"
INDEX_FILE="$CACHE_DIR/openclaw-docs-index.json"

# Initialize cache directory
mkdir -p "$CACHE_DIR"

# Fetch documentation index
fetch_index() {
    local url="https://docs.openclaw.ai"
    local cache_age=86400  # 24 hours
    
    # Check if cache is fresh
    if [ -f "$INDEX_FILE" ]; then
        local cache_timestamp=$(stat -c %Y "$INDEX_FILE")
        local current_time=$(date +%s)
        if (( current_time - cache_timestamp < cache_age )); then
            echo "Using cached index"
            return 0
        fi
    fi
    
    echo "Fetching docs index from $url"
    
    # Fetch main page
    curl -s "$url" > "$CACHE_DIR/openclaw-docs-main.html"
    
    # Create index structure
    cat > "$INDEX_FILE" << EOF
{
    "source": "$url",
    "fetched": "$(date)",
    "pages": [
        {"title": "Introduction", "href": "/", "summary": "OpenClaw intro"},
        {"title": "CLI Reference", "href": "/cli", "summary": "CLI commands"},
        {"title": "Gateway", "href": "/gateway", "summary": "Gateway docs"},
        {"title": "Skills", "href": "/skills", "summary": "Skills docs"},
        {"title": "Plugins", "href": "/plugins", "summary": "Plugins docs"}
    ]
}
EOF
    
    echo "Index updated"
}

# View cached index
view_index() {
    if [ -f "$INDEX_FILE" ]; then
        jq '.' "$INDEX_FILE"
    else
        echo "No cached index"
    fi
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "fetch")
            fetch_index
            ;;
g"view")
            view_index
            ;;
        *)
            echo "Usage: openclaw-docs-index <fetch|view>"
            ;;
    esac
}

# Run main function
main "$@"
```

## Notes

This skill provides index data for other docs skills.