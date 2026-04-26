#!/bin/bash
#!/bin/bash
# openclaw-docs-structure.sh

INDEX_FILE="$HOME/.openclaw/workspace/skills/openclaw-docs-index/cache/openclaw-docs-index.json"

# Generate structure tree
generate_tree() {
    if [ -f "$INDEX_FILE" ]; then
        echo "OpenClaw Docs Structure"
        echo "======================"
        
        jq '.pages[]' "$INDEX_FILE" | while read line; do
            local title=$(echo "$line" | jq -r '.title')
            local href=$(echo "$line" | jq -r '.href')
            local summary=$(echo "$line" | jq -r '.summary')
            
            echo "📄 $title ($href)"
            echo "  $summary"
            echo ""
        done
    else
        echo "Index not found"
        echo "Run: openclaw-docs-index fetch"
    fi
}

# Show CLI structure
show_cli() {
    if [ -f "$INDEX_FILE" ]; then
        echo "CLI Structure"
        echo "============"
        jq '.pages[] | select(.href == "/cli")' "$INDEX_FILE"
    fi
}

# Show Gateway structure
show_gateway() {
    if [ -f "$INDEX_FILE" ]; then
        echo "Gateway Structure"
        echo "================"
        jq '.pages[] | select(.href == "/gateway")' "$INDEX_FILE"
    fi
}

# Show Skills structure
show_skills() {
    if [ -f "$INDEX_FILE" ]; then
        echo "Skills Structure"
        echo "==============="
        jq '.pages[] | select(.href == "/skills")' "$INDEX_FILE"
    fi
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "cli")
            show_cli
            ;;
        "gateway")
            show_gateway
            ;;
        "skills")
            show_skills
            ;;
        *)
            generate_tree
            ;;
    esac
}

# Run main function
main "$@"