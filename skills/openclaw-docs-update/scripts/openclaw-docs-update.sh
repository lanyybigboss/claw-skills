#!/bin/bash
#!/bin/bash
# openclaw-docs-update.sh

INDEX_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-index/cache"
STORAGE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-storage/cache"
INDEX_FILE="$INDEX_DIR/openclaw-docs-index.json"

# Check cache expiry
check_cache() {
    if [ -f "$INDEX_FILE" ]; then
        local cache_timestamp=$(stat -c %Y "$INDEX_FILE")
        local current_time=$(date +%s)
        local cache_age=86400  # 24 hours
        
        if (( current_time - cache_timestamp < cache_age )); then
            echo "Cache is fresh"
            return 0
        else
            echo "Cache expired"
            return 1
        fi
    else
        echo "Cache not found"
        return 1
    fi
}

# Update index
update_index() {
    local url="https://docs.openclaw.ai"
    
    echo "Updating index..."
    curl -s "$url" > "$INDEX_DIR/openclaw-docs-main.html"
    
    cat > "$INDEX_FILE" << EOF
{
    "source": "$url",
    "fetched": "$(date)",
    "pages": [
        {"title": "Introduction", "href": "/", "summary": "OpenClaw intro"},
        {"title": "CLI Reference", "href": "/cli", "summary": "CLI commands"},
        {"title": "Gateway", "href": "/gateway", "summary11": "Gateway docs"},
        {"title": "Skills", "href": "/skills", "summary": "Skills docs"},
        {"title": "Plugins", "href": "/plugins", "summary": "Plugins docs"},
        {"title": "Security", "href": "/security", "summary": "Security docs"}
    ]
}
EOF
    
    echo "Index updated"
}

# Update cache
update_cache() {
    echo "Updating cache..."
    
    # Update CLI cache
    curl -s "https://docs.openclaw.ai/cli" > "$STORAGE_DIR/-cli.html"
    
    # Update Gateway cache
    curl -s "https://docs.openclaw.ai/gateway" > "$STORAGE_DIR/-gateway.html"
    
    # Update Skills cache
    curl -s "https://docs.openclaw.ai/skills" > "$STORAGE_DIR/-skills.html"
    
    echo "Cache updated"
}

# Update all
update_all() {
    update_index
    update_cache
    echo "Update complete"
}

# Main function
main() {
    if check_cache; then
        echo "Cache is fresh"
    else
        update_all
    fi
}

# Run main function
main "$@"