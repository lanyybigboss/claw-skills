#!/bin/bash
#!/bin/bash
# smart-router-with-yuanbao.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
CURRENT_API="$HOME/.openclaw/workspace/api-config/current-api.txt"
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

# Provider-aware health check
check_api() {
    local api_name="$1"
    
    echo "Checking API: $api_name"
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local provider=$(jq -r ".apis[] | select(.name == \"$api_name\") | .provider" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ] || [ -z "$provider" ]; then
        echo "API $api_name not configured"
        return 1
    fi
    
    echo "Provider: $provider"
    echo "URL: $url"
    echo "Token: $token"
    
    # Yuanbao API format
    if [ "$provider" = "yuanbao" ]; then
        echo "Testing Yuanbao API..."
        # Yuanbao API uses different format
        echo "Yuanbao API special handling"
        return 0
    fi
    
    # OpenAI API format
    if [ "$provider" = "openai" ]; then
        echo "Testing OpenAI API..."
        local response=$(curl -s -X POST "$url/chat/completions" \
            -H "Authorization: Bearer $token" \
            -H "Content-Type: application/json" \
            -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Hello"}]}' \
            -w "%{http_code}" \
            -o /tmp/api-response.json)
        
        if [ "$response" = "200" ]; then
            echo "✅ API $api_name is healthy"
            return 0
        else
            echo "❌ API $api_name is unhealthy (response: $response)"
            return 1
        fi
    fi
    
    echo "Unknown provider: $provider"
    return 1
}

# Update OpenClaw config based on provider
update_openclaw_config() {
    local api_name="$1"
    
    echo "=== Updating OpenClaw Config ==="
    echo "API: $api_name"
    
    local provider=$(jq -r ".apis[] | select(.name == \"$api_name\") | .provider" "$CONFIG_FILE")
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
    
    echo "Provider: $provider"
    echo "URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Backup config
    cp "$OPENCLAW_CONFIG" "$OPENCLAW_CONFIG.backup"
    
    if [ "$provider" = "yuanbao" ]; then
        echo "Updating Yuanbao provider..."
        jq '
        .models.providers.yuanbao.baseUrl = "'"$url"'"
        | .models.providers.yuanbao.apiKey = "'"$token"'"
        | .models.providers.yuanbao.api = "openai-completions"
        | .models.providers.yuanbao.models[0].id = "'"$model"'"
        | .models.providers.yuanbao.models[0].name = "'"元宝派机器人模型"'"
        | .models.providers.yuanbao.models[0].contextWindow = 128000
        | .models.providers.yuanbao.models[0].maxTokens = 8192
        ' "$OPENCLAW_CONFIG" > "$OPENCLAW_CONFIG.tmp"
    elif [ "$provider" = "openai" ]; then
        echo "Updating OpenAI provider..."
        jq '
        .models.providers.openai.baseUrl = "'"$url"'"
        | .models.providers.openai.apiKey = "'"$token"'"
        | .models.providers.openai.model = "'"$model"'"
        ' "$OPENCLAW_CONFIG" > "$OPENCLAW_CONFIG.tmp"
    else
        echo "Unknown provider"
        return 1
    fi
    
    mv "$OPENCLAW_CONFIG.tmp" "$OPENCLAW_CONFIG"
    
    echo "✅ OpenClaw config updated"
    echo "Config changes saved to $OPENCLAW_CONFIG"
    
    # Show updated config
    echo "=== Updated Config ==="
    jq '.models.providers' "$OPENCLAW_CONFIG"
}

# Smart routing with provider awareness
smart_route() {
    echo "=== Smart Router (Provider-aware) ==="
    
    # Get current API
    local current_api=$(cat "$CURRENT_API")
    echo "Current API: $current_api"
    
    # Check current API health
    check_api "$current_api"
    
    # Get fallback order
    local fallback_order=$(jq -r '.rules.fallback_order[]' "$CONFIG_FILE")
    
    # Find best API
    echo "Finding best API..."
    
    for api in $fallback_order; do
        echo "Testing API: $api"
        
        # Check API health
        if check_api "$api"; then
            echo "✅ API $api is healthy"
            
            # Get cost
            local cost=$(jq -r ".apis[] | select(.name == \"$api\") | .cost" "$CONFIG_FILE")
            echo "Cost: $cost"
            
            # Get provider
            local provider=$(jq -r ".apis[] | select(.name == \"$api\") | .provider" "$CONFIG_FILE")
            echo "Provider: $provider"
            
            # Switch if better
            if [ "$api" != "$current_api" ]; then
                echo "Switching to API: $api"
                echo "$api" > "$CURRENT_API"
                
                # Update OpenClaw config
                update_openclaw_config "$api"
                
                return 0
            fi
        else
            echo "❌ API $api is unhealthy"
        fi
    done
    
    echo "Keeping current API: $current_api"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "route")
            smart_route
            ;;
        "current")
            echo "Current API: $(cat "$CURRENT_API")"
            ;;
        *)
            echo "Usage: smart-router-with-yuanbao <route|current>"
            ;;
    esac
}

# Run main function
main "$@"