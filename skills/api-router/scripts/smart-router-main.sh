#!/bin/bash
#!/bin/bash
# smart-router-main.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
CURRENT_API="$HOME/.openclaw/workspace/api-config/current-api.txt"

# Smart routing decision
smart_route() {
    echo "=== Smart Router ==="
    
    # Get current API
    local current_api=$(cat "$CURRENT_API")
    echo "Current API: $current_api"
    
    # Check current API health
    /root/.openclaw/workspace/skills/api-router/scripts/simple-health-check.sh check "$current_api"
    
    # Get fallback order
    local fallback_order=$(jq -r '.rules.fallback_order[]' "$CONFIG_FILE")
    
    # Find best API
    echo "Finding best API..."
    
    for api in $fallback_order; do
        echo "Testing API: $api"
        
        # Check API health
        if /root/.openclaw/workspace/skills/api-router/scripts/simple-health-check.sh check "$api"; then
            echo "✅ API $api is healthy"
            
            # Get cost
            local cost=$(jq -r ".apis[] | select(.name == \"$api\") | .cost" "$CONFIG_FILE")
            echo "Cost: $cost"
            
            # Switch if better
            if [ "$api" != "$current_api" ]; then
                echo "Switching to API: $api"
                echo "$api" > "$CURRENT_API"
                
                # Update OpenClaw config
                /root/.openclaw/workspace/skills/api-router/scripts/openclaw-update.sh update "$api"
                
                return 0
            fi
        else
            echo "❌ API $api is unhealthy"
        fi
    done
    
    echo "Keeping current API: $current_api"
}

# Monitor token usage
monitor_tokens() {
    echo "=== Token Monitor ==="
    
    # Get current API
    local current_api=$(cat "$CURRENT_API")
    
    # Get API info
    local url=$(jq -r ".apis[] | select(.name == \"$current_api\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$current_api\") | .token" "$CONFIG_FILE")
    
    # Test API usage
    local response=$(curl -s -X POST "$url/chat/completions" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Token check"}]}' \
        -w "%{http_code}" \
        -o /tmp/api-token.json)
    
    if [ "$response" = "200" ]; then
        local usage=$(cat /tmp/api-token.json | jq -r '.usage.total_tokens')
        echo "API $current_api tokens used: $usage"
        
        # Get token threshold
        local threshold=$(jq -r '.rules.token_threshold' "$CONFIG_FILE")
        
        if [ "$usage" -gt "$threshold" ]; then
            echo "Token usage exceeds threshold: $usage > $threshold"
            echo "Consider switching API"
        fi
    else
        echo "API $current_api not responding"
    fi
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "route")
            smart_route
            ;;
        "monitor")
            monitor_tokens
            ;;
        *)
            echo "Usage: smart-router-main <route|monitor>"
            ;;
    esac
}

# Run main function
main "$@"