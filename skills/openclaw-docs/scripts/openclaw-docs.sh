#!/bin/bash

# OpenClaw Documentation Crawler Script
# This script fetches and searches OpenClaw documentation

CACHE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs/cache"
INDEX_FILE="$CACHE_DIR/openclaw-docs-index.json"
LOCAL_DOCS="/usr/lib/node_modules/openclaw/docs"

# Initialize cache directory
mkdir -p "$CACHE_DIR"

# Fetch documentation index from docs.openclaw.ai
fetch_index() {
    local url="https://docs.openclaw.ai"
    local cache_age=86400  # 24 hours
    
    # Check if cache is fresh
    if [ -f "$INDEX_FILE" ]; then
        local cache_timestamp=$(stat -c %Y "$INDEX_FILE")
        local current_time=$(date +%s)
        if (( current_time - cache_timestamp < cache_age )); then
            echo "Using cached index..."
            return 0
        fi
    fi
    
    echo "Fetching documentation index from $url..."
    
    # Fetch the main page
    curl -s "$url" > "$CACHE_DIR/openclaw-docs-main.html"
    
    # Create a simple index structure
    cat > "$INDEX_FILE" << EOF
{
    "source": "$url",
    "fetched": "$(date)",
    "pages": [
        {"title": "Introduction", "href": "/", "summary": "OpenClaw introduction"},
        {"title": "CLI Reference", "href": "/cli", "summary": "OpenClaw CLI commands"},
        {"literal": "Gateway", "href": "/gateway", "summary": "Gateway documentation"},
        {"literal": "Skills", "href": "/skills", "summary": "Skills management"},
        {"literal": "Plugins", "href": "/plugins", "summary": "Plugins management"},
        {"literal": "Security", "href": "/security", "summary": "Security documentation"}
    ]
}
EOF
    
    echo "Index updated."
}

# Search documentation
search_docs() {
    local query="$1"
    
    if [ -z "$query" ]; then
        echo "Usage: openclaw-docs search <query>"
        return 1
    fi
    
    fetch_index
    
    echo "Searching for: $query"
    
    # Search in local docs
    if [ -d "$LOCAL_DOCS" ]; then
        echo "=== Local Documentation ==="
        find "$LOCAL_DOCS" -name "*.md" -exec grep -i "$query" {} \; | head -20
    fi
    
    # Search in cache
    echo "=== Online Documentation (from cache) ==="
    grep -i "$query" "$CACHE_DIR/openclaw-docs-main.html" | head -10
}

# View specific page
view_page() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Usage: openclaw-docs view <path>"
        return 1
    fi
    
    local url="https://docs.openclaw.ai$path"
    echo "Fetching: $url"
    
    curl -s "$url" | head -1000
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "index")
            fetch_index
            echo "Index file: $INDEX_FILE"
            ;;
        "search")
            search_docs "$arg"
            ;;
        "view")
            view_page "$arg"
            ;;
        "update")
            fetch_index
            ;;
        *)
            echo "Usage: openclaw-docs <command>"
            echo "Commands:"
            echo "  index    - Fetch and display documentation index"
            echo "  search   - Search documentation with query"
            echo "  view     - View specific documentation page"
            echo "  update   - Update local cache"
            ;;
    esac
}

# Run main function
main "$@"