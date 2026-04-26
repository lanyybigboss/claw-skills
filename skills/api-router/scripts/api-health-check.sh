#!/bin/bash
#!/bin/bash
# api-health-check.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
LOG_FILE="$HOME/.openclaw/workspace/api-config/health-log.json"

# Health check all APIs
health_check_all() {
    echo "=== API Health Check ==="
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found"
        return 1
    fi
    
    # Get all APIs
    local api_count=$(jq '.apis | length' "$CONFIG_FILE")
    
    for i in $(seq 0 $(($api_count - 1))); do
        local name=$(jq -r ".apis[$i].name" "$CONFIG_FILE")
        local url=$(jq -r ".apis[$i].url" "$CONFIG_FILE")
        local token=$(jq -r ".apis[$i].token" "$CONFIG_FILE")
        
        echo "Checking API: $name"
        
        if [ -n "$url" ] && [ -n "$token" ]; then
            # Test API health
            curl -s "$url" > /tmp/api-check-$name.html
            
            # Test chat completion
            echo "Testing chat completion..."
            local response=$(curl -s -X POST "$url/chat/completions" \
                -H "Authorization: Bearer $token" \
                -H "Content-Type: application/json" \
                -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Hello"}]}' \
                -w "%{http_code}" \
                -o /tmp/api-response-$name.json)
            
            if [ "$response" = "200" ]; then
                echo "✅ API $name is healthy"
                
                # Parse usage
                local usage=$(cat /tmp/api-response-$name.json | jq -r '.usage.total_tokens')
                echo "Usage: $usage tokens"
            else
                echo "❌ API $name is unhealthy"
            fi
        else
            echo "⚠️ API $name not configured"
        fi
        
        echo ""
    done
}

# Check specific API
health_check_api() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .ifurl" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ]; then
        echo "API $api_name not configured"
        return 1
    fi
    
    echo "Testing API: $api_name"
    echo "URL: $url"
    echo "Token: $token"
    
    # Test API
    echo "Testing chat completion..."
    local response=$(curl -s -X POST "$url/chat/completions" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Hello"}]}' \
        -w "%{http_code}" \
        -o /tmp/api-response.json)
    
    echo "Response code: $response"
    
    if [ "$response" = "200" ]; then
        local usage=$(cat /tmp/api-response.json | jq -r '.usage.total_tokens')
        echo "✅ API $api_name is healthy"
        echo "Used tokens: $usage"
        
        return 0
    else
        echo "❌ API $api_name is unhealthy"
        return 1
    fi
}

# Check token balance
check_token_balance() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ]; then
        echo "API $api_name not configured"
        return 1
    fi
    
    # Get usage history
    echo "Checking token usage for $api_name"
    
    # Test API
    local response=$(curl -s -X POST "$url/chat/completions" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Check"}]}' \
        -w "%{http_code}" \
        -o /tmp/api-check.json)
    
    if [ "$response" = "200" ]; then
        local usage=$(cat /tmp/api-check.json | jq -r '.usage.total_tokens')
        echo "API $api_name tokens used: $usage"
        
        return 0
    else
        echo "API $api_name not responding"
        return 1
    fi
}

# Switch API if unhealthy
switch_if_unhealthy() {
    local current_api=$(cat "$HOME/.openclaw/workspace/api-config/current-api.txt")
    
    echo "Current API: $current_api"
    
    # Check current API health
    if health_check_api "$current_api"; then
        echo "✅ Current API is healthy"
        return 0
    else
        echo "❌ Current API is unhealthy, switching..."
        
        # Get fallback order
        local fallback_order=$(jq -r '.rules.fallback_order[]' "$CONFIG_FILE")
        
        for api in $fallback_order; do
            if [ "$api" != "$current_api" ]; then
                if health_check_api "$api"; then
                    echo "Switching to API: $api"
                    echo "$api" > "$HOME/.openclaw/workspace/api-config/current-api.txt"
                    echo "✅ API switched to $api"
                    
                    # Update OpenClaw config
                    /root/.openclaw/workspace/skills/api-router/scripts/update-openclaw-config.sh update "$api"
                    
                    return 0
                fi
            fi
        fi
        
        echo "❌ No healthy APIs found"
        return 1
    fi
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "all")
            health_check_all
            ;;
        "api")
            health_check_api "$arg"
            ;;
        "balance")
            check_token_balance "$arg"
            ;;
        "switch")
            switch_if_unhealthy
            ;;
        *)
            echo "Usage: api-health-check <all|api|balance|switch>"
            ;;
    esac
}

# Run main function
main "$@"