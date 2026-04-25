#!/bin/bash

# FnNAS Documentation Crawler Script
# This script fetches FnNAS (飞牛NAS) documentation from GitHub repositories

CACHE_DIR="$HOME/.openclaw/workspace/skills/fnnas-docs/cache"
REPO_INFO="$CACHE_DIR/fnnas-repo-info.json"
DOCS_DIR="$CACHE_DIR/docs"
LOCAL_CACHE="$CACHE_DIR/fnnas-docs.txt"

# Initialize cache directory
mkdir -p "$CACHE_DIR" "$DOCS_DIR"

# Function to fetch FnNAS repository information
fetch_fnnas_repo_info() {
    local cache_age=604800  # 7 days

    if [ -f "$REPO_INFO" ]; then
        local cache_timestamp=$(stat -c %Y "$REPO_INFO")
        local current_time=$(date +%s)
        if (( current_time - cache_timestamp < cache_age )); then
            echo "Using cached repository info..."
            return 0
        fi
    fi

    echo "Fetching FnNAS repository information..."

    # Fetch main repository info
    curl -s "https://api.github.com/repos/ophub/fnnas" > "$CACHE_DIR/ophub-fnnas.json"
    curl -s "https://api.github.com/repos/FNOSP/fnnas-api" > "$CACHE_DIR/fnnas-api.json"
    curl -s "https://api.github.com/repos/ckcoding/fnnas-docs" > "$CACHE_DIR/fnnas-docs.json"

    # Create repository info file
    cat > "$REPO_INFO" << EOF
{
    "repositories": [
        {
            "name": "ophub/fnnas",
            "description": "Supports running FnNAS on Amlogic, Allwinner, and Rockchip devices",
            "html_url": "https://github.com/ophub/fnnas",
            "type": "main"
        },
        {
            "name": "FNOSP/fnnas-api",
            "description": "飞牛NAS网页API",
            "html_url": "https://github.com/FNOSP/fnnas-api",
            "type": "api"
        },
        {
            "name": "ckcoding/fnnas-docs",
            "description": "飞牛应用开放平台开发文档",
            "html_url": "https://github.com/ckcoding/fnnas-docs",
            "type": "docs"
        }
    ],
    "official_docs": "https://developer.fnnas.com/docs/guide",
    "last_updated": "$(date)",
    "notes": "FnNAS (飞牛NAS) is a NAS solution running on ARM devices"
}
EOF

    echo "Repository info updated."
}

# Download FnNAS documentation
download_fnnas_docs() {
    fetch_fnnas_repo_info
    
    echo "Downloading FnNAS documentation..."
    
    # Download main repository README
    curl -s "https://raw.githubusercontent.com/ophub/fnnas/main/README.md" > "$DOCS_DIR/fnnas-readme.md"
    
    # Download API documentation
    curl -s "https://raw.githubusercontent.com/FNOSP/fnnas-api/main/README.md" > "$DOCS_DIR/fnnas-api-readme.md"
    
    # Download developer documentation
    curl -s "https://raw.githubusercontent.com/ckcoding/fnnas-docs/main/README.md" > "$DOCS_DIR/fnnas-docs-readme.md"
    
    # Fetch from official developer site
    curl -s "https://developer.fnnas.com/docs/guide" > "$DOCS_DIR/fnnas-developer-guide.html"
    
    # Combine all documentation
    cat "$DOCS_DIR/fnnas-readme.md" "$DOCS_DIR/fnnas-api-readme.md" "$DOCS_DIR/fnnas-docs-readme.md" > "$LOCAL_CACHE"
    
    echo "Documentation downloaded to: $LOCAL_CACHE"
    echo "Individual files in: $DOCS_DIR"
}

# Search documentation
search_docs() {
    local query="$1"
    
    if [ -z "$query" ]; then
        echo "Usage: fnnas-docs search <query>"
        return 1
    fi
    
    fetch_fnnas_repo_info
    
    echo "Searching FnNAS documentation for: $query"
    echo ""
    
    # Search in downloaded docs
    if [ -f "$LOCAL_CACHE" ]; then
        echo "=== Downloaded Documentation ==="
        grep -i "$query" "$LOCAL_CACHE" | head -20
    fi
    
    # Search in individual files
    if [ -d "$DOCS_DIR" ]; then
        echo ""
        echo "=== Individual Files Search ==="
        for file in "$DOCS_DIR"/*.md "$DOCS_DIR"/*.html; do
            if [ -f "$file" ]; then
                matches=$(grep -i "$query" "$file" | head -5)
                if [ -n "$matches" ]; then
                    echo "--- $(basename "$file") ---"
                    echo "$matches"
                    echo ""
                fi
            fi
        done
    fi
    
    # Provide general guidance
    case "$query" in
        install|setup)
            echo "=== FnNAS Installation ==="
            echo "FnNAS supports ARM devices:"
            echo "- Amlogic: a311d, s922x, s905x3, s905x2, s912"
            echo "- Allwinner: h6"
            echo "- Rockchip: rk3588, rk3568, rk3399, rk3328"
            echo ""
            echo "See https://github.com/ophub/fnnas for installation guide."
            ;;
        configuration|config)
            echo "=== FnNAS Configuration ==="
            echo "Configuration areas:"
            echo "1. Network Configuration"
            echo "2. Storage Management"
            echo "3. App Store setup"
            echo "4. API configuration"
            echo ""
            echo "See https://developer.fnnas.com/docs/guide for API docs."
            ;;
        api|rest)
            echo "=== FnNAS API Documentation ==="
            echo "API documentation available at:"
            echo "- https://github.com/FNOSP/fnnas-api"
            echo "- https://developer.fnnas.com/docs/guide"
            ;;
        *)
            echo "=== General FnNAS Information ==="
            echo "FnNAS (飞牛NAS) is a NAS solution for ARM devices."
            echo "Official repositories:"
            echo "- https://github.com/ophub/fnnas (main)"
            echo "- https://github.com/FNOSP/fnnas-api (API)"
            echo "- https://github.com/ckcoding/fnnas-docs (docs)"
            echo ""
            echo "Official documentation: https://developer.fnnas.com/docs/guide"
            ;;
    esac
}

# Show repository information
show_repo_info() {
    fetch_fnnas_repo_info
    cat "$REPO_INFO"
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "info")
            show_repo_info
            ;;
        "search")
            search_docs "$arg"
            ;;
        "download")
            download_fnnas_docs
            ;;
        "update")
            fetch_fnnas_repo_info
            ;;
        "topics")
            echo "FnNAS GitHub Topics:"
            echo "- nas"
            echo "- storage"
            echo "- arm"
            echo "- amlogic"
            echo "- rockchip"
            echo "- allwinner"
            echo "- docker"
            echo "- armbian"
            ;;
        *)
            echo "Usage: fnnas-docs <command>"
            echo "Commands:"
            echo "  info    - Show repository information"
            echo "  search  - Search documentation with query"
            echo "  download - Download documentation"
            echo "  update  - Update repository info cache"
            echo "  topics  - Show GitHub topics"
            echo ""
            echo "FnNAS GitHub Repositories:"
            echo "  ophub/fnnas - Main repository"
            echo "  FNOSP/fnnas-api - API documentation"
            echo "  ckcoding/fnnas-docs - Developer docs"
            echo ""
            echo "Official documentation: https://developer.fnnas.com/docs/guide"
            ;;
    esac
}

# Run main function
main "$@"