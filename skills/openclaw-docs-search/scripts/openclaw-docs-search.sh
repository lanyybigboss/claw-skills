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

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "search")
            search_docs "$2"
            ;;
        *)
            echo "Usage: openclaw-docs-search search <query>"
            ;;
    esac
}

# Run main function
main "$@"