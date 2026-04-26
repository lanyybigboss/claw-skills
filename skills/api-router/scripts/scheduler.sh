#!/bin/bash
#!/bin/bash
# scheduler.sh

CONFIG_FILE="$HOME/.openclaw/workspace/api-config/api-config.json"
LOG_FILE="$HOME/.openclaw/workspace/api-config/api-scheduler.log"

# Daily scheduler
daily_scheduler() {
    echo "=== Daily API Scheduler ==="
    
    # Reset yuanbao tokens daily at midnight
    echo "Resetting yuanbao tokens..."
    
    /root/.openclaw/workspace/skills/api-router/scripts/yuanbao-token-check.sh reset
    
    # Switch to yuanbao (free API)
    echo "yuanbao" > "$HOME/.openclaw/workspace/api-config/current-api.txt"
    
    echo "✅ Daily scheduler complete"
}

# Hourly token check
hourly_token_check() {
    echo "=== Hourly Token Check ==="
    
    local current_api=$(cat "$HOME/.openclaw/workspace/api-config/current-api.txt")
    echo "Current API: $current_api"
    
    if [ "$current_api" = "yuanbao" ]; then
        echo "Checking yuanbao free tokens..."
        
        local free_tokens=$(jq -r ".apis[] | select(.name == \"yuanbao\") | .free_tokens" "$CONFIG_FILE")
        
        if [ "$free_tokens" -lt 100 ]; then
            echo "⚠️ Yuanbao free tokens low: $free_tokens"
            echo "Switching to kuaipao..."
            
            echo "kuaipao" > "$HOME/.openclaw/workspace/api-config/current-api.txt"
            
            /root/.openclaw/workspace/skills/api-router/scripts/smart-router-with-yuanbao.sh
        fi
    fi
    
    # Check API health
    /root/.openclaw/workspace/skills/api-router/scripts/simple-health-check.sh check "$current_api"
}

# Usage scheduler
usage_scheduler() {
    echo "=== Usage Scheduler ==="
    
    # Monitor token usage
    /root/.openclaw/workspace/skills/api-router/scripts/yuanbao-token-check.sh simulate 10
    
    # Smart routing
    /root/.openclaw/workspace/skills/api-router/scripts/free-first-router.sh route
    
    # Log scheduling
    echo "Scheduler run complete at $(date)" >> "$LOG_FILE"
}

# Show schedule
show_schedule() {
    echo "=== API Routing Schedule ==="
    echo ""
    echo "Daily Schedule:"
    echo "00:00 - Reset yuanbao tokens"
    echo "00:01 - Switch to yuanbao"
    echo ""
    echo "Hourly Schedule:"
    echo "Every hour - Check token usage"
    echo "If yuanbao tokens < 100 - Switch to kuaipao"
    echo ""
    echo "Usage Pattern:"
    echo "1. Start day with yuanbao free tokens"
    echo "2. Use yuanbao until tokens exhausted"
    echo "3. Switch to kuaipao for remainder"
    echo "4. Next day reset"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "daily")
            daily_scheduler
            ;;
        "hourly")
            hourly_token_check
            ;;
        "usage")
            usage_scheduler
            ;;
        "schedule")
            show_schedule
            ;;
        *)
            echo "Usage: scheduler <daily|hourly|usage|schedule>"
            ;;
    esac
}

# Run main function
main "$@"