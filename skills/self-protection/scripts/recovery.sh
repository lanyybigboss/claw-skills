#!/bin/bash

# Recovery Script for Crash Recovery

CACHE_DIR="$HOME/.openclaw/workspace/skills/self-protection/cache"
CRASH_LOG="$HOME/.openclaw/workspace/skills/self-protection/references/crash-log.md"

# Log crash
log_crash() {
    local crash_type="$1"
    local crash_message="$2"
    
    echo "=== Crash Detected ==="
    echo "Time: $(date)"
    echo "Type: ${crash_type}"
    echo "Message: ${crash_message}"
    
    # Log to crash log
    echo "Crash: $(date) - Type: ${crash_type} - Message: ${crash_message}" >> "$CRASH_LOG"
    
    # Create recovery plan
    create_recovery_plan "$crash_type" "$crash_message"
}

# Create recovery plan
create_recovery_plan() {
    local crash_type="$1"
    local crash_message="$2"
    
    RECOVERY_FILE="$CACHE_DIR/recovery-plan-$(date +%Y%m%d%H%M%S).md"
    
    echo "=== Recovery Plan ===" > "$RECOVERY_FILE"
    echo "Crash Type: ${crash_type}" >> "$RECOVERY_FILE"
    echo "Crash Message: ${crash_message}" >> "$RECOVERY_FILE"
    echo "Timestamp: $(date)" >> "$RECOVERY_FILE"
    
    case "$crash_type" in
        "memory")
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Clear cache and temporary files" >> "$RECOVERY_FILE"
            echo "2. Restart OpenClaw services" >> "$RECOVERY_FILE"
            echo "3. Reduce memory-intensive operations" >> "$RECOVERY_FILE"
            ;;
        "cpu")
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Check for CPU-intensive processes" >> "$RECOVERY_FILE"
            echo "2. Implement throttling" >> "$RECOVERY_FILE"
            echo "3. Reduce concurrent operations" >> "$RECOVERY_FILE"
            ;;
        "disk")
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Clean up disk space" >> "$RECOVERY_FILE"
            echo "2. Delete old cache files" >> "$RECOVERY_FILE"
            echo "3. Move logs to external storage" >> "$RECOVERY_FILE"
            ;;
        "network")
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Check network connectivity" >> "$RECOVERY_FILE"
            echo "2. Implement fallback to local cache" >> "$RECOVERY_FILE"
            echo "3. Reduce external API calls" >> "$RECOVERY_FILE"
            ;;
        "process")
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Clean up orphaned processes" >> "$RECOVERY_FILE"
            echo "2. Restart failed processes" >> "$RECOVERY_FILE"
            echo "3. Implement process monitoring" >> "$RECOVERY_FILE"
            ;;
        *)
            echo "Recommended Actions:" >> "$RECOVERY_FILE"
            echo "1. Check system logs" >> "$RECOVERY_FILE"
            echo "2. Monitor resource usage" >> "$RECOVERY_FILE"
            echo "3. Implement stricter thresholds" >> "$RECOVERY_FILE"
            ;;
    esac
    
    echo "=== Recovery Plan Created ==="
    echo "Plan file: ${RECOVERY_FILE}"
}

# Execute recovery plan
execute_recovery() {
    local force="$1"
    
    echo "=== Executing Recovery ==="
    
    # Check current system state
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)
    
    echo "System State:"
    echo "CPU Usage: ${CPU_USAGE}%"
    echo "Memory Usage: ${MEMORY_USAGE}%"
    echo "Disk Usage: ${DISK_USAGE}%"
    
    # Check OpenClaw status
    OPENCLAW_STATUS=$(ps aux | grep openclaw | grep -v grep | wc -l)
    echo "OpenClaw Processes: ${OPENCLAW_STATUS}"
    
    # Recovery actions
    echo "Recovery Actions:"
    
    # Memory recovery
    if [ "${MEMORY_USAGE}" -gt 85 ]; then
        echo "1. Cleaning cache..."
        rm -f "$HOME/.openclaw/cache/*.tmp" 2>/dev/null
        rm -f "$HOME/.openclaw/tmp/*" 2>/dev/null
        echo "Cache cleaned"
    fi
    
    # Disk recovery
    if [ "${DISK_USAGE}" -gt 90 ]; then
        echo "2. Cleaning disk space..."
        find "$HOME/.openclaw/logs" -name "*.log" -mtime +7 -delete 2>/dev/null
        find "$HOME/.openclaw/workspace/skills/*/cache" -name "*.json" -mtime +7 -delete 2>/dev/null
        echo "Old logs deleted"
    fi
    
    # Process recovery
    if [ "${OPENCLAW_STATUS}" -eq 0 ] || [ "$force" = "--force" ]; then
        echo "3. Checking OpenClaw processes..."
        
        # Try to restart OpenClaw services
        systemctl restart openclaw 2>/dev/null || \
        openclaw gateway restart 2>/dev/null || \
        echo "OpenClaw restart command unknown"
        
        echo "OpenClaw services restarted"
    fi
    
    # Resource monitoring restart
    echo "4. Restarting heartbeat monitoring..."
    "$HOME/.openclaw/workspace/skills/self-protection/scripts/heartbeat.sh" check
    
    # Load balancing reset
    echo "5. Resetting load balancing..."
    "$HOME/.openclaw/workspace/skills/self-protection/scripts/load-balancer.sh" setup
    
    echo "=== Recovery Complete ==="
}

# Analyze crash patterns
analyze_crash_patterns() {
    if [ ! -f "$CRASH_LOG" ]; then
        echo "No crash logs found"
        return
    fi
    
    echo "=== Crash Pattern Analysis ==="
    
    # Count crash types
    MEMORY_CRASHES=$(grep -c "memory" "$CRASH_LOG")
    CPU_CRASHES=$(grep -c "cpu" "$CRASH_LOG")
    DISK_CRASHES=$(grep -c "disk" "$CRASH_LOG")
    NETWORK_CRASHES=$(grep -c "network" "$CRASH_LOG")
    PROCESS_CRASHES=$(grep -c "process" "$CRASH_LOG")
    
    echo "Crash Statistics:"
    echo "Memory: ${MEMORY_CRASHES}"
    echo "CPU: ${CPU_CRASHES}"
    echo "Disk: ${DISK_CRASHES}"
    echo "Network: ${NETWORK_CRASHES}"
    echo "Process: ${PROCESS_CRASHES}"
    
    # Find patterns
    echo "Pattern Analysis:"
    
    if [ "${MEMORY_CRASHES}" -gt 5 ]; then
        echo "⚠️  High memory crashes detected"
        echo "Recommendation: Increase memory threshold or implement cleanup"
    fi
    
    if [ "${CPU_CRASHES}" -gt 5 ]; then
        echo "⚠️  High CPU crashes detected"
        echo "Recommendation: Implement throttling or reduce concurrent ops"
    fi
    
    if [ "${DISK_CRASHES}" -gt 3 ]; then
        echo "⚠️  High disk crashes detected"
        echo "Recommendation: Implement automatic disk cleanup"
    fi
    
    if [ "${NETWORK_CRASHES}" -gt 5 ]; then
        echo "⚠️  High network crashes detected"
        echo "Recommendation: Implement network fallback"
    fi
    
    # Time patterns
    echo "Time Patterns:"
    grep "Crash:" "$CRASH_LOG" | awk '{print $2}' | sort | uniq -c
    
    echo "=== Analysis Complete ==="
}

# Preventative measures
preventative_measures() {
    echo "=== Preventative Measures ==="
    
    # Check thresholds
    "$HOME/.openclaw/workspace/skills/self-protection/scripts/self-protection.sh" check
    
    # Check load balancing
    "$HOME/.openclaw/workspace/skills/self-protection/scripts/load-balancer.sh" check
    
    # Check heartbeat status
    "$HOME/.openclaw/workspace/skills/self-protection/scripts/heartbeat.sh" check
    
    # Implement preventative measures
    echo "Recommended Preventative Actions:"
    echo "1. Monitor system resources hourly"
    echo "2. Implement operation queue"
    echo "3. Set reasonable thresholds"
    echo "4. Enable automatic cleanup"
    echo "5. Implement graceful degradation"
    
    echo "=== Preventative Measures Complete ==="
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "log")
            log_crash "$arg" "$3"
            ;;
        "execute")
            execute_recovery "$arg"
            ;;
        "analyze")
            analyze_crash_patterns
            ;;
        "preventative")
            preventative_measures
            ;;
        *)
            echo "Usage: recovery <command>"
            echo "Commands:"
            echo "  log        - Log a crash (type message)"
            echo "  execute    - Execute recovery (--force)"
            echo "  analyze    - Analyze crash patterns"
            echo "  preventative - Apply preventative measures"
            ;;
    esac
}

# Run main function
main "$@"