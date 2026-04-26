#!/bin/bash
#!/bin/bash
# api-config-template.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"

# Generate config template
generate_template() {
    cat > "$CONFIG_FILE" << EOF
{
    "apis": [
        {
            "name": "kuaipao",
            "url": "https://kuaipao.ai/v1",
            "token": "sk-TizHhGxXSTb4DYtkqRpuumYPdWvY2xI6Iu0wY9xkrXF2Stgy",
            "model": "gpt-3.5-turbo",
            "cost": 0.01,
            "priority": 1
        },
        {
            "name": "api1",
            "url": "YOUR_BASE_URL_1",
            "token": "YOUR_TOKEN_1",
            "model": "gpt-3.5-turbo",
            "cost": 0.02,
            "priority": 2
        },
        {
            "name": "api2",
            "url": "YOUR_BASE_URL_2",
            "token": "YOUR_TOKEN_2",
\f            "model": "gpt-3.5-turbo",
            "cost": 0.02,
            "priority": 3
        },
        {
            "name": "api3",
            "url": "YOUR_BASE_URL_3",
            "token": "YOUR_TOKEN_3",
            "model": "gpt-4",
            "cost": 0.05,
            "priority": 4
        }
    ],
    "rules": {
        "default": "kuaipao",
        "fallback_order": ["kuaipao", "api1", "api2", "api3"],
        "token_threshold": 100,
        "cost_threshold": 0.03,
        "smart_routing": true,
        "monitor_tokens": true
    }
}
EOF
    
    echo "Config template created"
    echo "Please update YOUR_BASE_URL and YOUR_TOKEN"
}

# Show config
show_config() {
    if [ -f "$CONFIG_FILE" ]; then
        echo "=== API Configuration ==="
        jq '.' "$CONFIG_FILE"
    else
        echo "Config file not found"
    fi
}

# Add API
add_api() {
    local name="$1"
    local url="$2"
    local token="$3"
    local model="$4"
    local cost="$5"
    local priority="$6"
    
    if [ -z "$name" ] || [ -z "$url" ] || [ -z "$token" ] || [ -z "$model" ]; then
        echo "Usage: api-config add-api <name> <url> <token> <model> <cost> <priority>"
        return 1
    fi
    
    if [ -f "$CONFIG_FILE" ]; then
        jq ".apis += [{name: \"$name\", url: \"$url\", token: \"$token\", model: \"$model\", cost: $cost, priority: $priority}]" "$CONFIG_FILE" > "$CONFIG_FILE.new"
        mv "$CONFIG_FILE.new" "$CONFIG_FILE"
        
        echo "API $name added"
        echo "URL: $url"
        echo "Token: $token"
        echo "Model: $model"
        echo "Cost: $cost"
        echo "Priority: $priority"
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
        
        echo "=== OpenClaw Config Update ==="
        echo "API Name: $api_name"
        echo "Base URL: $url"
        echo "Token: $token"
        echo "Model: $model"
        
        # Update config
        echo "OpenClaw配置需要更新："
        echo "aiProviders.openai.baseUrl: $url"
        echo "aiProviders.openai.token: $token"
        echo "aiProviders.openai.model: $model"
    else
        echo "Config file not found"
    fi
}

# Main function
main() {
    local command="$1"
    local arg1="$2"
    local arg2="$3"
    local arg3="$4"
    local arg4="$5"
    local arg5="$6"
    local arg6="$7"
    
    case "$command" in
        "template")
            generate_template
            ;;
        "show")
            show_config
            ;;
        "add-api")
            add_api "$arg1" "$arg2" "$arg3" "$arg4" "$arg5" "$arg6"
            ;;
        "update-openclaw")
            update_openclaw_config "$arg1"
            ;;
        *)
            echo "Usage: api-config <template|show|add-api|update-openclaw>"
            ;;
    esac
}

# Run main function
main "$@"