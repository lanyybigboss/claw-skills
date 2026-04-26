#!/bin/bash
#!/bin/bash
# smart-router.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
CURRENT_API="$HOME/.openclaw/workspace/api-config/current-api.txt"
LOG_FILE="$HOME/.openclaw/workspace/api-config/api-log.json"

# Initialize files
mkdir -p "$HOME/.openclaw/workspace/api-config"

# Token usage monitoring
monitor_tokens() {
    local api_name="$1"
    local usage="$2"
    
    echo "Monitoring API: $api_name"
    echo "Usage: $usage"
    
    # Log usage
    if [ -f "$LOG_FILE" ]; then
        jq ".$api_name += $usage" "$LOG_FILE" > "$LOG_FILE.new"
        mv "$LOG_FILE.new" "$LOG_FILE"
    else
        echo "{}" > "$LOG_FILE"
    fi
}

# Check if should switch
should_switch() {
    local current_api=$(get_current_api)
    
    # Simple logic: check if we should switch
    # In real implementation, check token balance
    
    echo "Current API: $current_api"
    
    # For now, always use current API
    return 0
}

# Smart routing
route_request() {
    local request_type="$1"
    local api_name=$(get_current_api)
    
    echo "Routing $request_type to API: $api_name"
    
    # Future: implement smart routing based on:
    # 1. Token balance
    # 2. API cost
    # 3. Response time
    # 4. Quality
    
    return "$api_name"
}

# Get current API
get_current_api() {
    if [ -f "$CURRENT_API" ]; then
        cat "$CURRENT_API"
    else
        echo "kuaipao"
    fi
}

# Switch to best API
switch_to_best() {
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found"
        return 1
    fi
    
    # Get API priority list
    local priority_order=$(jq -r '.rules.fallback_order[]' "$CONFIG_FILE")
    
    for api in $priority_order; do
        local url=$(jq -r ".apis[] | select(.name == \"$api\") | .url" "$CONFIG_FILE")
        local token=$(jq -r ".apis[] | select(.name == \"$api\") | .token" "$CONFIG_FILE")
        
        if [ -n "$url" ] && [ -n "$token" ]; then
            echo "Switching to API: $api"
            echo "$api" > "$CURRENT_API"
            return 0
        fi
    fi
    
    echo "No available APIs"
    return 1
}

# API health check
health_check() {
    local api_name="$1"
    
    if [ ! -f "$CONFIG_FILE" ]; then
        echo "Config file not found"
        return 1
    fi
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    
    if [ -z "$url" ]; then
        echo "API not found"
        return 1
    fi
    
    # Test API health
    curl -s "$url" > /tmp/api-health.html
    
    echo "API $api_name health: OK"
    return 0
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "monitor")
            monitor_tokens "$arg" "$3"
            ;;
        "route")
            route_request "$arg"
            ;;
        "switch")
            switch_to_best
            ;;
        "health")
            health_check "$arg"
            ;;
        *)
            echo "Usage: smart-router <monitor|route|switch|health>"
            ;;
    esac
}

# Run main function
main "$@"