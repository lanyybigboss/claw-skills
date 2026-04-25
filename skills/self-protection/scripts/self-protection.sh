#!/bin/bash

# Self Protection System for OpenClaw Agent
# Provides load balancing, heartbeat checks, and crash prevention

CACHE_DIR="$HOME/.openclaw/workspace/skills/self-protection/cache"
STATUS_FILE="$CACHE_DIR/health-status.json"
LOG_FILE="$CACHE_DIR/system-metrics.log"
THRESHOLDS_FILE="$HOME/.openclaw/workspace/skills/self-protection/references/thresholds.json"
CRASH_LOG="$HOME/.openclaw/workspace/skills/self-protection/references/crash-log.md"

# Initialize directories
mkdir -p "$CACHE_DIR"

# Resource thresholds
if [ ! -f "$THRESHOLDS_FILE" ]; then
    cat > "$THRESHOLDS_FILE" << EOF
{
    "cpu_threshold": 80,
    "memory_threshold": 85,
    "disk_threshold": 90,
    "load_threshold": 2.5,
    "network_threshold": 500,
    "max_concurrent": 3,
    "queue_max_size": 10
}
EOF
fi

# Load thresholds
load_thresholds() {
    if [ -f "$THRESHOLDS_FILE" ]; then
        CPU_THRESHOLD=$(grep '"cpu_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        MEMORY_THRESHOLD=$(grep '"memory_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        DISK_THRESHOLD=$(grep '"disk_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        LOAD_THRESHOLD=$(grep '"load_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]\.?[0-9]*' | head -1)
        NETWORK_THRESHOLD=$(grep '"network_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        MAX_CONCURRENT=$(grep '"max_concurrent"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        QUEUE_MAX_SIZE=$(grep '"queue_max_size"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
    else
        # Default thresholds
        CPU_THRESHOLD=80
        MEMORY_THRESHOLD=85
        DISK_THRESHOLD=90
        LOAD_THRESHOLD=2.5
        NETWORK_THRESHOLD=500
        MAX_CONCURRENT=3
        QUEUE_MAX_SIZE=10
    fi
}

# Check system health
check_health() {
    load_thresholds
    
    echo "=== System Health Check ==="
    echo "Timestamp: $(date)"
    
    # CPU usage
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    echo "CPU Usage: ${CPU_USAGE}%"
    
    # Memory usage
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
    echo "Memory Usage: ${MEMORY_USAGE}%"
    
    # Disk usage
    DISK_USAGE=$(df / | grep / | awk '{print $5}' | cut -d'%' -f1)
    echo "Disk Usage (root): ${DISK_USAGE}%"
    
    # System load
    SYSTEM_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    echo "System Load: ${SYSTEM_LOAD}"
    
    # Process count
    PROCESS_COUNT=$(ps -e | wc -l)
    echo "Process Count: ${PROCESSION_COUNT}"
    
    # OpenClaw status
    OPENCLAW_STATUS=$(systemctl status openclaw 2>/dev/null || ps aux | grep openclaw | wc -l)
    echo "OpenClaw Status: ${OPENCLAW_STATUS}"
    
    # Log to health status
    cat > "$STATUS_FILE" << EOF
{
    "timestamp": "$(date)",
    "cpu_usage": "${CPU_USAGE}",
    "memory_usage": "${MEMORY_USAGE}",
    "disk_usage": "${DISK_USAGE}",
    "system_load": "${SYSTEM_LOAD}",
    "process_count": "${PROCESS_COUNT}",
    "openclaw_status": "${OPENCLAW_STATUS}",
    "thresholds": {
        "cpu_threshold": "${CPU_THRESHOLD}",
        "memory_threshold": "${MEMORY_THRESHOLD}",
        "disk_threshold": "${DISK_THRESHOLD}",
        "load_threshold": "${LOAD_THRESHOLD}"
    }
}
EOF
    
    # Check thresholds
    if [ "${CPU_USAGE%.*}" -gt "${CPU_THRESHOLD}" ]; then
        echo "⚠️  CPU usage exceeds threshold (${CPU_THRESHOLD}%)"
    fi
    
    if [ "${MEMORY_USAGE%.*}" -gt "${MEMORY_THRESHOLD}" ]; then
        echo "⚠️  Memory usage exceeds threshold (${MEMORY_THRESHOLD}%)"
    fi
    
    if [ "${DISK_USAGE}" -gt "${DISK_THRESHOLD}" ]; then
        echo "⚠️  Disk usage exceeds threshold (${DISK_THRESHOLD}%)"
    fi
    
    # Log metrics
    echo "$(date) | CPU:${CPU_USAGE}% | MEM:${MEMORY_USAGE}% | DISK:${DISK_USAGE}% | LOAD:${SYSTEM_LOAD}" >> "$LOG_FILE"
    
    echo "=== Check Complete ==="
}

# Load balancing check
load_monitoring() {
    load_thresholds
    
    echo "=== Load Monitoring ==="
    echo "Maximum concurrent operations: ${MAX_CONCURRENT}"
    echo "Queue maximum size: ${QUEUE_MAX_SIZE}"
    
    # Check current load
    CURRENT_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
    echo "Current Load: ${CURRENT_LOAD}"
    
    if (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD" | bc -l) )); then
        echo "⚠️  System load exceeds threshold (${LOAD_THRESHOLD})"
        echo "Recommendation: Reduce concurrent operations"
    else
        echo "✓ System load is acceptable"
    fi
    
    # Check operation queue
    if [ -f "$CACHE_DIR/operation-queue.json" ]; then
        QUEUE_SIZE=$(wc -l "$CACHE_DIR/operation-queue.json" | awk '{print $1}')
        echo "Current Queue Size: ${QUEUE_SIZE}"
        
        if [ "${QUEUE_SIZE}" -gt "${QUEUE_MAX_SIZE}" ]; then
            echo "⚠️  Operation queue exceeds maximum size (${QUEUE_MAX_SIZE})"
            echo "Recommendation: Process backlog or increase throttle"
        fi
    else
        echo "Operation queue file not found"
        echo "Current Queue Size: 0"
    fi
    
    echo "=== Load Monitoring Complete ==="
}

# Heartbeat management
heartbeat_management() {
    local action="$1"
    
    case "$action" in
        "start")
            echo "Starting hourly heartbeat monitoring..."
            # Create cron job for hourly checks
            crontab -l | grep -q "self-protection heartbeat check"
            if [ $? -ne 0 ]; then
                echo "Adding hourly heartbeat check to cron..."
                (crontab -l 2>/dev/null; echo "0 * * * * $HOME/.openclaw/workspace/skills/self-protection/scripts/heartbeat.sh check") | crontab -
            fi
            echo "Hourly heartbeat monitoring started"
            ;;
        "stop")
            echo "Stopping hourly heartbeat monitoring..."
            crontab -l | grep "self-protection heartbeat check" >/dev/null 2>&1
            if [ $? -eq 0 ]; then
                crontab -l | grep -v "self-protection heartbeat check" | crontab -
                echo "Hourly heartbeat monitoring stopped"
            else
                echo "No heartbeat cron job found"
            fi
            ;;
        "check")
            echo "Running heartbeat check..."
            "$HOME/.openclaw/workspace/skills/self-protection/scripts/heartbeat.sh" check
            ;;
        *)
            echo "Usage: self-protection heartbeat <start|stop|check>"
            ;;
    esac
}

# Recovery procedures
recovery_procedures() {
    local force="$1"
    
    echo "=== Recovery Procedures ==="
    
    # Check if OpenClaw is running
    OPENCLAW_RUNNING=$(ps aux | grep openclaw | grep -v grep | wc -l)
    if [ "$OPENCLAW_RUNNING" -eq 0 ]; then
        echo "OpenClaw is not running"
        if [ "$force" = "--force" ]; then
            echo "Starting OpenClaw..."
            # Try to start OpenClaw (this depends on your installation)
            systemctl start openclaw 2>/dev/null || \
            openclaw gateway start 2>/dev/null || \
            echo "OpenClaw start command unknown"
        fi
    else
        echo "✓ OpenClaw is running"
    fi
    
    # Cleanup temporary files
    echo "Cleaning temporary files..."
    rm -f "$HOME/.openclaw/tmp/*" 2>/dev/null
    rm -f "$HOME/.openclaw/cache/*.tmp" 2>/dev/null
    
    # Restart failed processes (if known)
    echo "Checking for orphaned processes..."
    ps aux | grep -E "openclaw|claw" | grep -v grep
    
    echo "=== Recovery Complete ==="
}

# Crash log analysis
crash_log_analysis() {
    local action="$1"
    
    case "$action" in
        "last")
            echo "=== Last Crash Analysis ==="
            if [ -f "$CRASH_LOG" ]; then
                tail -20 "$CRASH_LOG"
            else
                echo "No crash logs found"
                echo "To enable crash logging, add this to HEARTBEAT.md:"
                echo "# Crash detection"
                echo "self-protection check"
            fi
            ;;
        "all")
            echo "=== All Crash History ==="
            if [ -f "$CRASH_LOG" ]; then
                cat "$CRASH_LOG"
            else
                echo "No crash logs found"
            fi
            ;;
        *)
            echo "Usage: self-protection crash-log <last|all>"
            ;;
    esac
}

# Resource report
resource_report() {
    echo "=== Resource Report ==="
    echo "Timestamp: $(date)"
    
    # CPU info
    CPU_INFO=$(lscpu | grep -E "Model name|CPU(s)" | head -2)
    echo "CPU Info:"
    echo "$CPU_INFO"
    
    # Memory info
    MEMORY_INFO=$(free -h | grep Mem)
    echo "Memory Info: ${MEMORY_INFO}"
    
    # Disk info
    DISK_INFO=$(df -h /)
    echo "Disk Info:"
    echo "$DISK_INFO"
    
    # Network info
    NETWORK_INFO=$(ip addr | grep -E "inet " | head -3)
    echo "Network Info:"
    echo "$NETWORK_INFO"
    
    # Thresholds
    load_thresholds
    echo "Thresholds:"
    echo "CPU: ${CPU_THRESHOLD}%"
    echo "Memory: ${MEMORY_THRESHOLD}%"
    echo "Disk: ${DISK_THRESHOLD}%"
    echo "Load: ${LOAD_THRESHOLD}"
    echo "Network Latency: ${NETWORK_THRESHOLD}ms"
    echo "Max Concurrent: ${MAX_CONCURRENT}"
    echo "Queue Max Size: ${QUEUE_MAX_SIZE}"
    
    echo "=== Report Complete ==="
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "check")
            check_health
            ;;
        "load")
            load_monitoring
            ;;
        "resources")
            resource_report
            ;;
        "heartbeat")
            heartbeat_management "$arg"
            ;;
        "recover")
            recovery_procedures "$arg"
            ;;
        "crash-log")
            crash_log_analysis "$arg"
            ;;
        *)
            echo "Usage: self-protection <command>"
            echo "Commands:"
            echo "  check      - Run system health check"
            echo "  load       - Monitor system load"
            echo "  resources  - Show resource report"
            echo "  heartbeat  - Manage hourly heartbeat (start|stop|check)"
            echo "  recover    - Run recovery procedures"
            echo "  crash-log  - Analyze crash logs (last|all)"
            ;;
    esac
}

# Run main function
main "$@"