#!/bin/bash
#!/bin/bash
# auto-switch.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
CURRENT_API="$HOME/.openclaw/workspace/api-config/current-api.txt"

# Auto switch based on health
auto_switch_by_health() {
    local current_api=$(cat "$CURRENT_API")
    
    echo "Current API: $current_api"
    
    # Test current API
    echo "Testing current API..."
    
    local url=$(jq -r ".apis[] | select(.name == \"$current_api\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$current_api\") | .token" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ]; then
        echo "API $current_api not configured"
        return 1
    fi
    
    # Health check
    local response=$(curl -s -X POST "$url/chat/completions" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Health check"}]}' \
        -w "%{http_code}" \
        -o /tmp/api-health.json)
    
    if [ "$response" != "200" ]; then
        echo "Current API $current_api unhealthy (response: $response)"
        
        # Find next healthy API
        local fallback_order=$(jq -r '.rules.fallback_order[]' "$CONFIG_FILE")
        
        for api in $fallback_order; do
            if [ "$api" != "$current_api" ]; then
                echo "Testing API: $api"
                
                local test_url=$(jq -r ".apis[] | select(.name == \"$api\") | .url" "$CONFIG_FILE")
                local test_token=$(jq -r ".apis[] | select(.name == \"$api\") | .token" "$CONFIG_FILE")
                
                if [ -z "$test_url" ] || [ -z "$test_token" ]; then
                    echo "API $api not configured"
                    continue
                fi
                
                local test_response=$(curl -s -X POST "$test_url/chat/completions" \
                    -H "Authorization: Bearer $test_token" \
                    -H "Content-Type: application/json" \
                    -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Health check"}]}' \
                    -w "%{http_code}" \
                    -o /tmp/api-test.json)
                
                if [ "$test_response" = "200" ]; then
                    echo "✅ API $api is healthy, switching..."
                    echo "$api" > "$CURRENT_API"
                    echo "✅ Current API switched to $api"
                    
                    # Update OpenClaw config
                    update_openclaw_config "$api"
                    
                    return 0
                else
                    echo "❌ API $api unhealthy (response: $test_response)"
                fi
            fi
        done
        
        echo "❌ No healthy APIs found"
        return 1
    else
        echo "✅ Current API $current_api is healthy"
        return 0
    fi
}

# Auto switch based on cost
auto_switch_by_cost() {
    echo "Cost-based switching not implemented"
}

# Auto switch based on tokens
auto_switch_by_tokens() {
    echo "Token-based switching not implemented"
}

# Update OpenClaw config
update_openclaw_config() {
    local api_name="$1"
    
    echo "Updating OpenClaw config to API: $api_name"
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
    
    echo "Config updates:"
    echo "  URL: $url"
    echo "  Token: $token"
    echo "  Model: $model"
    
    # OpenClaw config updates will be done manually
    echo "OpenClaw config update required"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "health")
            auto_switch_by_health
            ;;
        "cost")
            auto_switch_by_cost
            ;;
        "tokens")
            auto_switch_by_tokens
            ;;
        *)
            echo "Usage: auto-switch <health|cost|tokens>"
            ;;
    esac
}

# Run main function
main "$@"