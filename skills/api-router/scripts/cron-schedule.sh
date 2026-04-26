#!/bin/bash
#!/bin/bash
# cron-schedule.sh

# Setup cron jobs for API routing
setup_cron() {
    echo "=== Setting up Cron Jobs ==="
    
    # Daily scheduler at midnight
    echo "0 0 * * * $HOME/.openclaw/workspace/skills/api-router/scripts/scheduler.sh daily" >> /tmp/cron-schedule
    
    # Hourly token check
    echo "0 * * * * $HOME/.openclaw/workspace/skills/api-router/scripts/scheduler.sh hourly" >> /tmp/cron-schedule
    
    # Usage scheduler every 30 minutes
    echo "30 * * * * $HOME/.openclaw/workspace/skills/api-router/scripts/scheduler.sh usage" >> /tmp/cron-schedule
    
    echo "Cron jobs created"
    
    # Add to crontab
    (crontab -l 2>/dev/null; cat /tmp/cron-schedule) | crontab -
    
    echo "✅ Cron jobs installed"
}

# Remove cron jobs
remove_cron() {
    echo "=== Removing Cron Jobs ==="
    
    # Remove API routing jobs
    crontab -l | grep -v "scheduler.sh" | crontab -
    
    echo "✅ Cron jobs removed"
}

# Show cron jobs
show_cron() {
    echo "=== Current Cron Jobs ==="
    
    crontab -l
    
    echo "=== API Routing Jobs ==="
    crontab -l | grep "scheduler.sh"
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "setup")
            setup_cron
            ;;
        "remove")
            remove_cron
            ;;
        "show")
            show_cron
            ;;
        *)
            echo "Usage: cron-schedule <setup|remove|show>"
            ;;
    esac
}

# Run main function
main "$@"