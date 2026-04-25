#!/bin/bash

# Load Balancer Script
# Implements throttling and queue management

CACHE_DIR="$HOME/.openclaw/workspace/skills/self-protection/cache"
QUEUE_FILE="$CACHE_DIR/operation-queue.json"
THRESHOLDS_FILE="$HOME/.openclaw/workspace/skills/self-protection/references/thresholds.json"

# Load thresholds
load_thresholds() {
    if [ -f "$THRESHOLDS_FILE" ]; then
        CPU_THRESHOLD=$(grep '"cpu_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        MEMORY_THRESHOLD=$(grep '"memory_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        DISK_THRESHOLD=$(grep '"disk_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        LOAD_THRESHOLD=$(grep '"load_threshold"' "$THRESHOLDS_FILE" | grep -o '[0-9]\.?[0-9]*' | head -1)
        MAX_CONCURRENT=$(grep '"max_concurrent"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
        QUEUE_MAX_SIZE=$(grep '"queue_max_size"' "$THRESHOLDS_FILE" | grep -o '[0-9]*')
    else
        CPU_THRESHOLD=80
        MEMORY_THRESHOLD=85
        DISK_THRESHOLD=90
        LOAD_THRESHOLD=2.5
        MAX_CONCURRENT=3
        QUEUE_MAX_SIZE=10
    fi
}

# Add operation to queue
add_to_queue() {
    local operation="$1"
    local priority="$2"
    
    if [ ! -f "$QUEUE_FILE" ]; then
        echo "[]" > "$QUEUE_FILE"
    fi
    
    # Create timestamp
    TIMESTAMP=$(date +%s)
    
    # Add to queue
    echo "$(cat "$QUEUE_FILE" | sed 's/]$/,{"operation":"'$operation'","priority":"'$priority'","timestamp":"'$TIMESTAMP'"}]/')" > "$QUEUE_FILE"
    
    echo "Added operation '$operation' to queue (priority: $priority)"
}

# Process queue
process_queue() {
    load_thresholds
    
    if [ ! -f "$QUEUE_FILE" ]; then
        echo "No operations in queue"
        return
    fi
    
    QUEUE_SIZE=$(cat "$QUEUE_FILE" | grep -o "{" | wc -l)
    echo "Queue Size: ${QUEUE_SIZE}"
    
    # Check system load before processing
    CURRENT_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//g')
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    
    if [ -n "$CURRENT_LOAD" ] && [ -n "$LOAD_THRESHOLD" ]; then
        if (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD" | bc -l 2>/dev/null) )) || [ "${CPU_USAGE%.*}" -gt "${CPU_THRESHOLD}" ]; then
            echo "⚠️  System load too high, throttling queue processing"
            echo "Current Load: ${CURRENT_LOAD}"
            echo "CPU Usage: ${CPU_USAGE}%"
            echo "Processing 1 operation only"
            
            # Process only highest priority operation
            PROCESS_COUNT=1
        else
            # Process based on MAX_CONCURRENT
            PROCESS_COUNT=$MAX_CONCURRENT
            echo "Processing ${PROCESS_COUNT} operations"
        fi
        
        # Process operations
        for i in $(seq 1 $PROCESS_COUNT); do
            if [ $QUEUE_SIZE -gt 0 ]; then
                echo "Processing operation $i"
                # Remove from queue (simplified)
                QUEUE_SIZE=$((QUEUE_SIZE - 1))
            else
                echo "Queue empty"
                break
            fi
        done
        
        echo "Remaining operations in queue: ${QUEUE_SIZE}"
    else
        echo "Unable to determine load level"
    fi
}

# Check system load
check_load() {
    load_thresholds
    
    CURRENT_LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}' | sed 's/,//g')
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
    MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
    
    echo "=== Load Check ==="
    echo "Current Load: ${CURRENT_LOAD}"
    echo "CPU Usage: ${CPU_USAGE}%"
    echo "Memory Usage: ${MEMORY_USAGE}%"
    
    # Determine throttling level
    THROTTLE_LEVEL=0
    
    if [ -n "$CURRENT_LOAD" ] && [ -n "$LOAD_THRESHOLD" ]; then
        if (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD" | bc -l 2>/dev/null) )) || [ "${CPU_USAGE%.*}" -gt "${CPU_THRESHOLD}" ]; then
            THROTTLE_LEVEL=2
            echo "⚠️  High Load - Throttling Level 2"
            echo "Recommendation: Process 1 operation only"
        elif (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD * 0.7" | bc -l 2>/dev/null) )) || [ "${CPU_USAGE%.*}" -gt "${CPU_THRESHOLD}" ]; then
            THROTTLE_LEVEL=1
            echo "⚠️  Moderate Load - Throttling Level 1"
            echo "Recommendation: Process ${MAX_CONCURRENT} operations"
        else
            THROTTLE_LEVEL=0
            echo "✓ Normal Load - No Throttling"
            echo "Recommendation: Process ${MAX_CONCURRENT} operations"
        fi
    else
        echo "Unable to determine load level"
    fi
    
    # Queue status
    if [ -f "$QUEUE_FILE" ]; then
        QUEUE_SIZE=$(cat "$QUEUE_FILE" | grep -o "{" | wc -l)
        echo "Queue Size: ${QUEUE_SIZE}"
        
        if [ "${QUEUE_SIZE}" -gt "${QUEUE_MAX_SIZE}" ]; then
            echo "⚠️  Queue overloaded (${QUEUE_SIZE} > ${QUEUE_MAX_SIZE})"
            echo "Recommendation: Stop accepting new operations until queue clears"
        fi
    else
        echo "Queue Size: 0"
    fi
    
    echo "=== Load Check Complete ==="
}

# Rate limiting
rate_limit() {
    local operation_type="$1"
    local threshold="$2"
    
    # Check operation count
    OPERATION_COUNT=$(cat "$CACHE_DIR/operation-count.log" 2>/dev/null | grep "$operation_type" | wc -l)
    
    if [ "$OPERATION_COUNT" -gt "$threshold" ]; then
        echo "⚠️  Rate limit exceeded for $operation_type"
        echo "Current: ${OPERATION_COUNT}, Limit: ${threshold}"
        echo "Recommendation: Wait before next operation"
        return 1
    else
        echo "✓ Rate limit OK for $operation_type"
        echo "Current: ${OPERATION_COUNT}, Limit: ${threshold}"
        return 0
    fi
}

# Setup load balancing
setup_load_balancing() {
    echo "=== Load Balancing Setup ==="
    
    # Create threshold file
    if [ ! -f "$THRESHOLDS_FILE" ]; then
        load_thresholds
    fi
    
    # Create queue file
    if [ ! -f "$QUEUE_FILE" ]; then
        echo "[]" > "$QUEUE_FILE"
    fi
    
    # Create operation count log
    if [ ! -f "$CACHE_DIR/operation-count.log" ]; then
        echo "# Operation count log" > "$CACHE_DIR/operation-count.log"
    fi
    
    # Create resource log
    if [ ! -f "$CACHE_DIR/resource-log.json" ]; then
        echo "{}" > "$CACHE_DIR/resource-log.json"
    fi
    
    echo "Load balancing setup complete"
    echo "Thresholds: ${CPU_THRESHOLD}% CPU, ${MEMORY_THRESHOLD}% Memory"
    echo "Queue Size: ${QUEUE_MAX_SIZE}"
    echo "Max Concurrent: ${MAX_CONCURRENT}"
    
    echo "=== Setup Complete ==="
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    local arg2="$3"
    
    case "$command" in
        "check")
            check_load
            ;;
        "queue")
            process_queue
            ;;
        "add")
            add_to_queue "$arg" "$arg2"
            ;;
        "setup")
            setup_load_balancing
            ;;
        "rate")
            rate_limit "$arg" "$arg2"
            ;;
        *)
            echo "Usage: load-balancer <command>"
            echo "Commands:"
            echo "  check      - Check system load"
            echo "  queue      - Process queue"
            echo "  add        - Add operation to queue"
            echo "  setup      - Setup load balancing"
            echo "  rate       - Check rate limit"
            ;;
    esac
}

# Run main function
main "$@"