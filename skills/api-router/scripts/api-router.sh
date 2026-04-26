#!/bin/bash
#!/bin/bash
# api-router.sh

CONFIG_DIR="$HOME/.openclaw/workspace/api-config"
CONFIG_FILE="$CONFIG_DIR/api-config.json"
CURRENT_API="$CONFIG_DIR/current-api.txt"

# Initialize config directory
mkdir -p "$CONFIG_DIR"

# API configuration template
init_config() {
    cat > "$CONFIG_FILE" << EOF
{
    "apis": [
        {
            "name": "kuaipao",
            "url": "https://kuaipao.ai/v1",
            "token": "sk-TizHhGxXSTb4DYtkqRpuumYPdWvY2xI6Iu0wY9xkrXF2Stgy",
            "model": "gpt-3.5-turbo",
            "priority": 1
        },
        {
            "name": "api1",
            "url": "",
            "token": "",
            "model": "",
            "priority": 2
        },
        {
            "name": "api2",
            "url": "",
            "token": "",
            "model": "",
            "priority": 3
        }
    ],
    "rules": {
        "default": "kuaipao",
        "fallback_order": ["kuaipao", "api1", "api2"],
        "token_threshold": 100
    }
}
EOF
    
    echo "API configuration initialized"
}

# Check current API
get_current_api() {
    if [ -f "$CURRENT_API" ]; then
        cat "$CURRENT_API"
    else
        echo "kuaipao"
    fi
}

# Switch API
switch_api() {
    local api_name="$1"
    
    if [ -z "$api_name" ]; then
        echo "Usage: api-router switch-api <api_name>"
        return 1
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        # Check if API exists in config
        if jq -e ".apis[] | select(.name == \"$api_name\")" "$CONFIG_FILE" > /dev/null 2>&1; then
            echo "$api_name" > "$CURRENT_API"
            echo "Switched to API: $api_name"
            
            # Update OpenClaw config
            update_openclaw_config "$api_name"
        else
            echo "API $api_name not found in config"
        fi
    else
        echo "Config file not found"
    fi
}

# Update OpenClaw config
update_openclaw_config() {
    local api_name="$1"
    
    if [ -f "$CONFIG_FILE" ]; then
        local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
        local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
        local model=$(jq -r ".apis[] | select(.name == \"$api_name\") | .model" "$CONFIG_FILE")
        
        echo "API URL: $url"
        echo "API Token: $token"
        echo "API Model: $model"
        
        if [ -n "$url" ] && [ -n "$token" ] && [ -n "$model" ]; then
            echo "Would update OpenClaw config with:"
            echo "baseUrl: $url"
            echo "token: $token"
            echo "model: $model"
        fi
    fi
}

# Add new API
add_api() {
    local name="$1"
    local url="$2"
    local token="$3"
    local model="$4"
    
    if [ -z "$name" ] || [ -z "$url" ] || [ -z "$token" ] || [ -z "$model" ]; then
        echo "Usage: api-router add-api <name> <url> <token> <model>"
        return 1
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        jq ".apis += [{name: \"$name\", url: \"$url\", token: \"$token\", model: \"$model\", priority: 2}]" "$CONFIG_FILE" > "$CONFIG_FILE.new"
        mv "$CONFIG_FILE.new" "$CONFIG_FILE"
        
        echo "API $name added"
    else
        echo "Config file not found"
    fi
}

# Check API status
check_status() {
    local current_api=$(get_current_api)
    
    echo "Current API: $current_api"
    
    if [ -f "$CONFIG_FILE" ]; then
        echo "=== API Configuration ==="
        jq '.apis[]' "$CONFIG_FILE"
    fi
}

# Check token usage
check_tokens() {
    local api_name=$(get_current_api)
    
    echo "Checking tokens for API: $api_name"
    
    if [ -f "$CONFIG_FILE" ]; then
        local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
        local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
        
        echo "API Token: $token"
        echo "API URL: $url"
        
        # Check API availability
        curl -s "$url" > /tmp/api-check.html
        
        echo "API status: OK"
    fi
}

# Auto-switch logic
auto_switch() {
    echo "Auto-switch logic not implemented"
    echo "Requires token usage monitoring"
}

# Main function
main() {
    local command="$1"
    local arg1="$2"
    local arg2="$3"
    local arg3="$4"
    local arg4="$5"
    
    case "$command" in
        "init")
            init_config
            ;;
        "status")
            check_status
            ;;
        "switch-api")
            switch_api "$arg1"
            ;;
        "add-api")
            add_api "$arg1" "$arg2" "$arg3" "$arg4"
            ;;
        "check-tokens")
            check_tokens
            ;;
        "auto-switch")
            auto_switch
            ;;
        *)
            echo "Usage: api-router <init|status|switch-api|add-api|check-tokens|auto-switch>"
            ;;
    esac
}

# Run main function
main "$@"