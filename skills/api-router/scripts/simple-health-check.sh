#!/bin/bash
#!/bin/bash
# simple-health-check.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"

# Check API health
check_api() {
    local api_name="$1"
    
    echo "Checking API: $api_name"
    
    local url=$(jq -r ".apis[] | select(.name == \"$api_name\") | .url" "$CONFIG_FILE")
    local token=$(jq -r ".apis[] | select(.name == \"$api_name\") | .token" "$CONFIG_FILE")
    
    if [ -z "$url" ] || [ -z "$token" ]; then
        echo "API $api_name not configured"
        return 1
    fi
    
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
        echo "✅ API $api_name is healthy"
        return 0
    else
        echo "❌ API $api_name is unhealthy"
        return 1
    fi
}

# Get current API
get_current_api() {
    cat "$HOME/.openclaw/workspace/api-config/current-api.txt"
}

# Switch API
switch_api() {
    local api_name="$1"
    
    echo "Switching to API: $api_name"
    
    # Update current API
    echo "$api_name" > "$HOME/.openclaw/workspace/api-config/current-api.txt"
    
    echo "✅ Current API: $api_name"
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "check")
            check_api "$arg"
            ;;
        "current")
            get_current_api
            ;;
        "switch")
            switch_api "$arg"
            ;;
        *)
            echo "Usage: simple-health-check <check|current|switch>"
            ;;
    esac
}

# Run main function
main "$@"