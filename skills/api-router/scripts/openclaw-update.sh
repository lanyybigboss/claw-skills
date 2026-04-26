#!/bin/bash
#!/bin/bash
# openclaw-update.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
OPENCLAW_CONFIG="$HOME/.openclaw/openclaw.json"

# Update OpenClaw config
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
    
    echo "=== OpenClaw Config Update ==="
    echo "API Name: $api_name"
    echo "Base URL: $url"
    echo "Token: $token"
    echo "Model: $model"
    
    # Backup config
    cp "$OPENCLAW_CONFIG" "$OPENCLAW_CONFIG.backup"
    
    # Update AI providers
    jq '
    .models.providers.openai.baseUrl = "'"$url"'"
    | .models.providers.openai.apiKey = "'"$token"'"
    | .models.providers.openai.model = "'"$model"'"
    ' "$OPENCLAW_CONFIG" > "$OPENCLAW_CONFIG.tmp"
    
    mv "$OPENCLAW_CONFIG.tmp" "$OPENCLAW_CONFIG"
    
    echo "✅ OpenClaw config updated"
    echo "Config changes saved to $OPENCLAW_CONFIG"
    
    # Show updated config
    echo "=== Updated Config ==="
    jq '.models.providers.openai' "$OPENCLAW_CONFIG"
}

# Test current OpenClaw config
test_config() {
    echo "=== Current OpenClaw Config ==="
    jq '.models.providers.openai' "$OPENCLAW_CONFIG"
}

# Show all APIs
show_apis() {
    echo "=== Available APIs ==="
    jq '.apis[]' "$CONFIG_FILE"
}

# Show current API
show_current() {
    local current_api=$(cat "$HOME/.openclaw/workspace/api-config/current-api.txt")
    echo "=== Current API ==="
    echo "API Name: $current_api"
    jq ".apis[] | select(.name == \"$current_api\")" "$CONFIG_FILE"
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
            test_config
            ;;
        "apis")
            show_apis
            ;;
        "current")
            show_current
            ;;
        *)
            echo "Usage: openclaw-update <update|test|apis|current>"
            ;;
    esac
}

# Run main function
main "$@"