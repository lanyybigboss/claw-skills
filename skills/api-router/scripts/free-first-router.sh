#!/bin/bash
#!/bin/bash
# free-first-router.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
CURRENT_API="$HOME/.openclaw/workspace/api-config/current-api.txt"

# Free-first routing logic
free_first_route() {
    echo "=== Free-First Router ==="
    
    # Always prefer yuanbao free tokens first
    local current_api=$(cat "$CURRENT_API")
    echo "Current API: $current_api"
    
    # Check yuanbao first
    echo "Checking yuanbao (free API)..."
    
    local yuanbao_available=true
    
    # Yuanbao token check logic
    local yuanbao_free_tokens=$(jq -r ".apis[] | select(.name == \"yuanbao\") | .free_tokens" "$CONFIG_FILE")
    local yuanbao_cost=$(jq -r ".apis[] | select(.name == \"yuanbao\") | .cost" "$CONFIG_FILE")
    
    echo "Yuanbao free tokens: $yuanbao_free_tokens"
    echo "Yuanbao cost: $yuanbao_cost"
    
    # Always switch to yuanbao if not currently using it
    if [ "$current_api" != "yuanbao" ]; then
        echo "Switching to yuanbao (free API)"
        echo "yuanbao" > "$CURRENT_API"
        
        /root/.openclaw/workspace/skills/api-router/scripts/smart-router-with-yuanbao.sh
        return 0
    fi
    
    echo "✅ Already using yuanbao free tokens"
    
    # If yuanbao tokens exhausted, switch to kuaipao
    # This logic will need token usage monitoring
}

# Token usage monitor
token_monitor() {
    echo "=== Token Usage Monitor ==="
    
    local current_api=$(cat "$CURRENT_API")
    local cost=$(jq -r ".apis[] | select(.name == \"$current_api\") | .cost" "$CONFIG_FILE")
    local free_tokens=$(jq -r ".apis[] | select(.name == \"$current_api\") | .free_tokens" "$CONFIG_FILE")
    
    echo "Current API: $current_api"
    echo "Cost: $cost"
    echo "Free tokens: $free_tokens"
    
    # If yuanbao and tokens exhausted, switch
    if [ "$current_api" = "yuanbao" ] && [ "$free_tokens" -lt 100 ]; then
        echo "⚠️ Yuanbao free tokens low: $free_tokens"
        echo "Switching to kuaipao..."
        
        echo "kuaipao" > "$CURRENT_API"
        /root/.openclaw/workspace/skills/api-router/scripts/smart-router-with-yuanbao.sh
    fi
    
    # If kuaipao and cost high, switch
    if [ "$current_api" = "kuaipao" ] && [ "$cost" -gt 0.02 ]; then
        echo "⚠️ Kuaipao cost high: $cost"
        echo "Considering switching..."
    fi
}

# Daily token reset
daily_reset() {
    echo "=== Daily Token Reset ==="
    
    # Reset yuanbao free tokens
    echo "Resetting yuanbao free tokens..."
    
    jq '
    .apis[] | select(.name == "yuanbao") | .free_tokens = 1000
    ' "$CONFIG_FILE" > "$CONFIG_FILE.tmp"
    
    mv "$CONFIG_FILE.tmp" "$CONFIG_FILE"
    
    # Switch back to yuanbao
    echo "yuanbao" > "$CURRENT_API"
    /root/.openclaw/workspace/skills/api-router/scripts/smart-router-with-yuanbao.sh
    
    echo "✅ Daily reset complete"
}

# Show free token status
show_status() {
    echo "=== Free Token Status ==="
    
    local yuanbao_tokens=$(jq -r ".apis[] | select(.name == \"yuanbao\") | .free_tokens" "$CONFIG_FILE")
    local yuanbao_cost=$(jq -r ".apis[] | select(.name == \"yuanbao\") | .cost" "$CONFIG_FILE")
    
    local kuaipao_cost=$(jq -r ".apis[] | select(.name == \"kuaipao\") | .cost" "$CONFIG_FILE")
    
    echo "Yuanbao (腾讯元宝):"
    echo "  Free tokens: $yuanbao_tokens"
    echo "  Cost: $yuanbao_cost"
    echo ""
    echo "Kuaipao (收费中转):"
    echo "  Cost: $kuaipao_cost"
    echo ""
    echo "Usage strategy:"
    echo "  1. First use yuanbao free tokens"
    echo "  2. When yuanbao tokens exhausted, switch to kuaipao"
    echo "  3. Daily reset of yuanbao tokens"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "route")
            free_first_route
            ;;
        "monitor")
            token_monitor
            ;;
        "reset")
            daily_reset
            ;;
        "status")
            show_status
            ;;
        *)
            echo "Usage: free-first-router <route|monitor|reset|status>"
            ;;
    esac
}

# Run main function
main "$@"