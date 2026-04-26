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
        {"title": "Plugins", "href": "/plugins", "summary": "Plugins docs"},
        {"title": "Security", "href": "/security", "summary": "Security docs"}
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
        "view")
            view_index
            ;;
        *)
            echo "Usage: openclaw-docs-index <fetch|view>"
            ;;
    esac
}

# Run main function
main "$@"