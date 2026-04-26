#!/bin/bash
#!/bin/bash
# update-openclaw-config.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

# Update OpenClaw config with API
update_config() {
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
    
    echo "Updating OpenClaw config with API: $api_name"
    echo "URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Create temporary config
    cp "$OPENCLAW_CONFIG" "$OPENCLAW_CONFIG.bak"
    
    # Update AI providers
    sed -i 's/"baseUrl": "https://kuaipao.ai/v1"/"baseUrl": "'"$url"'"/' "$OPENCLAW_CONFIG"
    sed -i 's/"apiKey": "sk-TizHhGxXSTb4DYtkqRpuumYPdWvY2xI6Iu0wY9xkrXF2Stgy"/"apiKey": "'"$token"'"/' "$OPENCLAW_CONFIG"
    sed -i 's/"model": "gpt-3.5-turbo"/"model": "'"$model"'"/' "$OPENCLAW_CONFIG"
    
    echo "Config updated"
}

# Test API connection
test_api() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "API config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
    
    echo "Testing API: $api_name"
    echo "URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Test connection
    curl -s "$url" > /tmp/api-test.html
    
    echo "Connection test complete"
}

# List available APIs
list_apis() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "API config file not found"
        return 1
    fi
    
    echo "=== Available APIs ==="
    jq '.apis[]' "$CONFIG_FILE"
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "update")
            update_config "$arg"
            ;;
        "test")
            test_api "$arg"
            ;;
        "list")
            list_apis
            ;;
        *)
            echo "Usage: update-openclaw-config <update|test|list>"
            ;;
    esac
}

# Run main function
main "$@"