#!/bin/bash
#!/bin/bash
# openclaw-docs-view.sh

STORAGE_DIR="$HOME/.openclaw/workspace/skills/openclaw-docs-storage/cache"

# Clean HTML formatting
clean_html() {
    sed -e 's/<[^>]*>//g' \
        -e '/^$/d' \
        -e '/^\s*$/d' \
        -e '/\.css/d' \
        -e '/\.js/d' \
        -e '/script/d' \
        -e '/<style/d' \
        -e '/DOCTYPE/d'
}

# View docs page
view_page() {
    local path="$1"
    
    if [ -z "$path" ]; then
        echo "Usage: openclaw-docs-view <path>"
        return 1
    fi
    
    local cache_file="$STORAGE_DIR/${path//\//-}.html"
    local url="https://docs.openclaw.ai$path"
    
    # Check cache
    if [ -f "$cache_file" ]; then
        echo "Using cached page"
        cat "$cache_file" | clean_html | head -50
    else
        echo "Fetching page"
        curl -s "$url" | clean_html | head -50
    fi
}

# View CLI docs
view_cli() {
    view_page "/cli"
}

# View Gateway docs
view_gateway() {
    view_page "/gateway"
}

# View Skills docs
view_skills() {
    view_page "/skills"
}

# View Plugins docs
view_plugins() {
    view_page "/plugins"
}

# View Security docs
view_security() {
    view_page "/security"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "cli")
            view_cli
            ;;
        "gateway")
            view_gateway
            ;;
        "skills")
            view_skills
            ;;
        "plugins")
            view_plugins
            ;;
        "security")
            view_security
            ;;
        *)
            view_page "$command"
            ;;
    esac
}

# Run main function
main "$@"