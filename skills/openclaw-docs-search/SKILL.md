---
name: openclaw-docs-search
description: Search OpenClaw docs content
read_when:
  - Search docs content
  - Find documentation
metadata: {"clawdbot":{"emoji":"🔍","requires":{"bins":["grep","jq"]}}}
---

# OpenClaw Docs Search

**负责搜索文档内容**

## Features

- Search docs using index data
- Search cached pages
- Search local docs
- Return search results

## Quick Commands

### Search docs
```bash
openclaw-docs-search gateway
```

### Search with section
```bash
openclaw-docs-search --section CLI
```

## Implementation

### Search Sources
- Index data from openclaw-docs-index
- Cached pages from openclaw-docs-storage
- Local docs files

### Integration
```bash
# Uses openclaw-docs-index for index data
# Uses openclaw-docs-storage for cached content
```

## Script

```bash
#!/bin/bash
#!/bin/bash
# openclaw-docs-search.sh

INDEX_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-index/cache"
STORAGE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-storage/cache"
LOCAL_DOCS="/usr/lib/node_modules/openclaw/docs"

# Search docs content
search_docs() {
    local query="$1"
    
    if [ -z "$query" ]; then
        echo "Usage: openclaw-docs-search <query>"
        return 1
    fi
    
    echo "Searching for: $query"
    
    # Search in index
    if [ -f "$INDEX_DIR/openclaw-docs-index.json" ]; then
        echo "=== Index Results ==="
        jq ".pages[] | select(.title | contains(\"$query\"))" "$INDEX_DIR/openclaw-docs-index.json"
    fi
    
    # Search in local docs
    if [ -d "$LOCAL_DOCS" ]; then
        echo "=== Local Docs ==="
        find "$LOCAL_DOCS" -name "*.md" -exec grep -i "$query" {} \; | head -5
    fi
    
    # Search in cache
    if [ -d "$STORAGE_DIR" ]; then
        echo "=== Cache ==="
        find "$STORAGE_DIR" -name "*.html" -exec grep -i "$query" {} \; | head -5
    fi
    
    echo "Search complete"
}

# Search with section
search_section() {
    local query="$1"
    local section="$2"
    
    if [ -z "$query" ]; then
        echo "Usage: openclaw-docs-search --section <query>"
        return 1
    fi
    
    echo "Searching in $section: $query"
    
    case "$section" in
        "cli")
            # Search CLI docs
            ;;
        "gateway")
            # Search Gateway docs
            ;;
        "skills")
            # Search Skills docs
            ;;
        *)
            echo "Invalid section"
            ;;
    esac
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "search")
            search_docs "$2"
            ;;
        "--section")
            search_section "$3"
            ;;
        *)
            echo "Usage: openclaw-docs-search <query>"
            ;;
    esac
}

# Run main function
main "$@"
```

## Notes

This skill searches docs using other skills.