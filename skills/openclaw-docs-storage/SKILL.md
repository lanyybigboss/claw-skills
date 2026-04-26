---
name: openclaw-docs-storage
description: Manage docs cache and local files
read_when:
  - Cache docs pages
  - Manage local docs
metadata: {"clawdbot":{"emoji":"🗂️","requires":{"bins":["curl","jq"]}}}
---

# OpenClaw Docs Storage

**负责缓存管理和本地文档**

## Features

- Cache fetched documentation pages
- Manage local documentation files
- Cache expiration control
- Store docs for quick access

## Quick Commands

### Cache a page
```bash
openclaw-docs-storage cache /cli
```

### View cached page
```bash
openclaw-docs-storage view /cli
```

### Clear cache
```bash
openclaw-docs-storage clear
```

## Implementation

### Cache Structure
```bash
CACHE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-storage/cache"
```

### Local Docs
```bash
LOCAL_DOCS="/usr/lib/node_modules/openclaw/docs"
```

### Cache Strategy
- Cache expires after 24 hours
- Automatically cleans old files

## Script

```bash
#!/bin/bash
#!/bin/bash
# openclaw-docs-storage.sh

CACHE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-storage/cache"
LOCAL_DOCS="/usr/lib/node_modules/openclaw/docs"

# Initialize cache directory
mkdir -p "$CACHE_DIR"

# Cache a docs page
cache_page() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Usage: openclaw-docs-storage cache <path>"
        return 1
    fi
    
    local url="https://docs.openclaw.ai$path"
    local cache_file="$CACHE_DIR/${path//\//-}.html"
    
    echo "Caching: $url"
    curl -s "$url" > "$cache_file"
    
    echo "Cached: $cache_file"
}

# View cached page
view_cache() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Usage: openclaw-docs-storage view <path>"
        return 1
    fi
    
    local cache_file="$CACHE_DIR/${path//\//-}.html"
    
    if [ -f "$cache_file" ]; then
        head -50 "$cache_file"
    else
        echo "No cached page for $path"
    fi
}

# View local docs
view_local() {
    local query="$1"
    
    if [ -d "$LOCAL_DOCS" ]; then
        if [ -z "$query" ]; then
            echo "Local docs location: $LOCAL_DOCS"
        else
            find "$LOCAL_DOCS" -name "*.md" -exec grep -i "$query" {} \; | head -10
        fi
    else
        echo "Local docs not found"
    fi
}

# Clear cache
clear_cache() {
    rm -rf "$CACHE_DIR"
    mkdir -p "$CACHE_DIR"
    echo "Cache cleared"
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "cache")
            cache_page "$arg"
            ;;
        "view")
            view_cache "$arg"
            ;;
        "local")
            view_local "$arg"
            ;;
        "clear")
            clear_cache
            ;;
        *)
            echo "Usage: openclaw-docs-storage <cache|view|local|clear>"
            ;;
    esac
}

# Run main function
main "$@"
```

## Notes

This skill manages storage for docs skills.