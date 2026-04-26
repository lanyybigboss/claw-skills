#!/bin/bash
#!/bin/bash
# update-model-config.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

# Update OpenClaw model config
update_model_config() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "API config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ] || [ -z "$model" ]; then
        echo "API config incomplete for $api_name"
        return 1
    fi
    
    echo "=== Updating OpenClaw Config ==="
    echo "API: $api_name"
    echo "URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Backup config
    cp "$OPENCLAW_CONFIG" "$OPENCLAW_CONFIG.bak"
    
    # Update AI providers
    sed -i 's/"baseUrl": "https:\/\/kuaipao.ai\/v1"/"baseUrl": "'"$url"'"/' "$OPENCLAW_CONFIG"
    sed -i 's/"apiKey": "sk-TizHhGxXSTb4DYtkqRpuumYPdWvY2xI6Iu0wY9xkrXF2Stgy"/"apiKey": "'"$token"'"/' "$OPENCLAW_CONFIG"
    sed -i 's/"model": "gpt-3.5-turbo"/"model": "'"$model"'"/' "$OPENCLAW_CONFIG"
    
    echo "✅ OpenClaw config updated"
    
    # Restart OpenClaw gateway
    echo "Restarting OpenClaw gateway..."
    # Add restart logic here if needed
}

# Test API config
test_api_config() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "API config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
    
    echo "=== Testing API ==="
    echo "URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Test API
    echo "Testing API connection..."
    curl -s "$url" > /tmp/api-test.html
    
    echo "Testing API response..."
    curl -s -X POST "$url/chat/completions" \
        -H "Authorization: Bearer $token" \
        -H "Content-Type: application/json" \
        -d '{"model":"gpt-3.5-turbo","messages":[{"role":"user","content":"Test"}]}' \
        -o /tmp/api-response.json
    
    echo "API test complete"
}

# Show current OpenClaw config
show_current_config() {
    echo "=== Current OpenClaw Config ==="
    jq '.models.providers.openai' "$OPENCLAW_CONFIG"
}

# Compare configs
compare_configs() {
    echo "=== Current Config ==="
    jq '.models.providers.openai' "$OPENCLAW_CONFIG"
    
    echo "=== API Config ==="
    local current_api=$(cat "$HOME/.openclaw/workspace/api-config/current-api.txt")
    jq ".apis[] | select(.name == \"$current_api\")" "$CONFIG_FILE"
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "update")
            update_model_config "$arg"
            ;;
        "test")
            test_api_config "$arg"
            ;;
        "show")
            show_current_config
            ;;
        "compare")
            compare_configs
            ;;
        *)
            echo "Usage: update-model-config <update|test|show|compare>"
            ;;
    esac
}

# Run main function
main "$@"