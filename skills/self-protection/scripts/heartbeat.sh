#!/bin/bash

# Heartbeat Script for Hourly Self-Check
# This script performs comprehensive health checks

CACHE_DIR="$HOME/.openclaw/workspace/skills/self-protection/cache"
HEARTBEAT_LOG="$CACHE_DIR/heartbeat.log"
THRESHOLDS_FILE="$HOME/.openclaw/workspace/skills/self-protection/references/thresholds.json"

# Load thresholds
load_thresholds() {
    if [ -f "$THRESHOLDS_FILE" ]; then
        CPU_THRESHOLD=$(grep '"cpu_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        MEMORY_THRESHOLD=$(grep '"memory_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        DISK_THRESHOLD=$(grep '"disk_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        LOAD_THRESHOLD=$(grep '"load_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]\.?[0-9]*' | head -1)
        NETWORK_THRESHOLD=$(grep '"network_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
    else
        CPU_THRESHOLD=80
        MEMORY_THRESHOLD=85
        DISK_THRESHOLD=90
        LOAD_THRESHOLD=2.5
        NETWORK_THRESHOLD=500
    fi
}

# Perform heartbeat check
heartbeat_check() {
    load_thresholds
    
    echo "=== Hourly Heartbeat Check ==="
    echo "Time: $(date)"
    
    # Check system resources
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)
    SYSTEM_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    
    echo "CPU: ${CPU_USAGE}%"
    echo "Memory: ${MEMORY_USAGE}%"
    echo "Disk: ${DISK_USAGE}%"
    echo "Load: ${SYSTEM_LOAD}"
    
    # Check OpenClaw services
    OPENCLAW_STATUS=$(ps aux | grep openclaw | grep -v grep | wc -l)
    echo "OpenClaw Processes: ${OPENCLAW_STATUS}"
    
    # Check external connectivity
    NETWORK_TEST=$(ping -c 1 -W 1 docs.openclaw.ai 2>/dev/null | grep "time=" | awk -F'=' '{print $4}' | cut -d' ' -f1)
    if [ -n "$NETWORK_TEST" ]; then
        echo "Network Latency: ${NETWORK_TEST}ms"
    else
        echo "Network Connectivity: FAILED"
    fi
    
    # Log to heartbeat log
    echo "$(date) | CPU:${CPU_USAGE}% | MEM:${MEMORY_USAGE}% | DISK:${DISK_USAGE}% | LOAD:${SYSTEM_LOAD} | OPENCLAW:${OPENCLAW_STATUS}" >> "$HEARTBEAT_LOG"
    
    # Check thresholds
    ALERT=""
    if [ "${CPU_USAGE}" -gt "${CPU_THRESHOLD}" ]; then
        ALERT="CPU usage exceeds ${CPU_THRESHOLD}%"
    fi
    
    if [ "${MEMORY_USAGE}" -gt "${MEMORY_THRESHOLD}" ]; then
        ALERT="Memory usage exceeds ${MEMORY_THRESHOLD}%"
    fi
    
    if [ "${DISK_USAGE}" -gt "${DISK_THRESHOLD}" ]; then
        ALERT="Disk usage exceeds ${DISK_THRESHOLD}%"
    fi
    
    if [ -n "$NETWORK_TEST" ] && [ "$NETWORK_TEST" -gt "$NETWORK_THRESHOLD" ]; then
        ALERT="Network latency exceeds ${NETWORK_THRESHOLD}ms"
    fi
    
    if [ -n "$ALERT" ]; then
        echo "⚠️  ALERT: ${ALERT}"
        
        # Add alert to crash log
        echo "Heartbeat Alert: $(date) - ${ALERT}" >> "$HOME/.openclaw/workspace/skills/self-protection/references/crash-log.md"
        
        # Recommended actions
        if [ "${CPU_USAGE}" -gt "${CPU_THRESHOLD}" ]; then
            echo "Recommendation: Reduce CPU-intensive tasks"
        fi
        
        if [ "${MEMORY_USAGE}" -gt "${MEMORY_THRESHOLD}" ]; then
            echo "Recommendation: Clear cache, restart services"
        fi
        
        if [ "${DISK_USAGE}" -gt "${DISK_THRESHOLD}" ]; then
            echo "Recommendation: Clean up disk space"
        fi
        
        if [ -n "$NETWORK_TEST" ] && [ "$NETWORK_TEST" -gt "$NETWORK_THRESHOLD" ]; then
            echo "Recommendation: Check network connectivity"
        fi
    else
        echo "✓ All systems healthy"
    fi
    
    # Check for crash indicators
    check_crash_indicators
    
    echo "=== Heartbeat Complete ==="
}

# Check for crash indicators
check_crash_indicators() {
    # Check for recent crashes
    CRASH_COUNT=$(grep -c "Crash" "$HEARTBEAT_LOG" 2>/dev/null)
    
    # Check for process restarts
    RESTART_COUNT=$(grep -c "Restart" "$HEARTBEAT_LOG" 2>/dev/null)
    
    # Check for error messages
    ERROR_COUNT=$(grep -c "ERROR" "$HEARTBEAT_LOG" 2>/dev/null)
    
    if [ "$CRASH_COUNT" -gt 0 ] || [ "$RESTART_COUNT" -gt:0 ] || [ "$ERROR_COUNT" -gt 0 ]; then
        echo "⚠️  Crash Indicators Detected"
        echo "Crashes: ${CRASH_COUNT}"
        echo "Restarts: ${RESTART_COUNT}"
        echo "Errors: ${ERROR_COUNT}"
        
        # Log crash indicators
        echo "Crash Indicators: $(date) - Crashes:${CRASH_COUNT} Restarts:${RESTART_COUNT} Errors:${ERROR_COUNT}" >> "$HOME/.openclaw/workspace/skills/self-protection/references/crash-log.md"
    fi
}

# Process queue check
check_process_queue() {
    echo "=== Process Queue Check ==="
    
    # Check OpenClaw process count
    OPENCLAW_PROCESSES=$(ps aux | grep openclaw | grep -v grep | wc -l)
    echo "OpenClaw Processes: ${OPENCLAW_PROCESSES}"
    
    # Check for orphaned processes
    ORPHANED_PROCESSES=$(ps aux | grep -E "python|node|bash" | grep -v grep | grep -E "defunct|orphaned" | wc -l)
    echo "Orphaned Processes: ${ORPHANED_PROCESSES}"
    
    if [ "$ORPHANED_PROCESSES" -gt 0 ]; then
        echo "⚠️  Found orphaned processes"
        echo "Recommendation: Clean up orphaned processes"
        
        # Log orphaned processes
        echo "Orphaned Processes: $(date) - Count:${ORPHANED_PROCESSES}" >> "$HEARTBEAT_LOG"
    fi
    
    echo "=== Process Queue Complete ==="
}

# Main function
main() {
    local command="$1"
    
    case "$command" in
        "check")
            heartbeat_check
            check_process_queue
            ;;
        "log")
            if [ -f "$HEARTBEAT_LOG" ]; then
                echo "=== Heartbeat Log ==="
                tail -50 "$HEARTBEAT_LOG"
            else
                echo "No heartbeat log found"
            fi
            ;;
        *)
            echo "Usage: heartbeat <check|log>"
            ;;
    esac
}

# Run main function
main "$@"