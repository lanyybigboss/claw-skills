# Self Protection System Examples

## Basic Usage

### Health Check
```bash
# Check system health
self-protection check

# Check system load
self-protection load

# Check resources
self-protection resources
```

### Heartbeat Monitoring
```bash
# Start hourly heartbeat monitoring
self-protection heartbeat start

# Run heartbeat check
self-protection heartbeat check

# View heartbeat log
heartbeat log
```

### Load Balancing
```bash
# Setup load balancing
load-balancer setup

# Check system load
load-balancer check

# Process operation queue
load-balancer queue

# Add operation to queue
load-balancer add "download" "low"
```

### Recovery Procedures
```bash
# Execute recovery
self-protection recover

# Force recovery
self-protection recover --force

# Analyze crash patterns
recovery analyze

# Log a crash
recovery log "memory" "Memory usage exceeded threshold"
```

## Integration Examples

### Hourly Heartbeat Schedule
Add to cron for hourly monitoring:
```bash
# Add hourly heartbeat to cron
(crontab -l 2>/dev/null; echo "0 * * * * $HOME/.openclaw/workspace/skills/self-protection/scripts/heartbeat.sh check") | crontab -
```

### Load Balancing in Operations
```bash
# Check system load before heavy operation
if [ "$(load-balancer check)" != "Normal Load" ]; then
    echo "⚠️  System load high, throttling operation"
    add_to_queue "operation" "low"
else
    echo "✓ System load normal, proceeding with operation"
    perform_operation
fi
```

### Graceful Degradation
```bash
# Example of graceful degradation
if [ "$(self-protection check | grep "CPU Usage" | awk '{print $3}' | cut -d'%' -f1)" -gt 80 ]; then
    echo "⚠️  CPU usage high, using simplified response"
    provide_simplified_response
else
    provide_full_response
fi
```

## Threshold Configuration

### Default Thresholds
```json
{
    "cpu_threshold": 80,
    "memory_threshold": 85,
    "disk_threshold": 90,
    "load_threshold": 2.5,
    "network_threshold": 500,
    "max_concurrent": 3,
    "queue_max_size": 10
}
```

### Adjusting Thresholds
```bash
# Edit thresholds.json
cat > "$HOME/.openclaw/workspace/skills/self-protection/references/thresholds.json" << EOF
{
    "cpu_threshold": 75,
    "memory_threshold": 80,
    "disk_threshold": 85,
    "load_threshold": 2.0,
    "network_threshold": 300,
    "max_concurrent": 5,
    "queue_max_size": 15
}
EOF
```

## Crash Prevention Examples

### Memory Prevention
```bash
# Check memory before operation
MEMORY_USAGE=$(free | grep Mem | awk '{print $3/$2 * 100}')
if [ "$MEMORY_USAGE" -gt 85 ]; then
    echo "⚠️  Memory usage high, cleaning cache"
    rm -f "$HOME/.openclaw/cache/*.tmp"
    rm -f "$HOME/.openclaw/tmp/*"
fi
```

### CPU Prevention
```bash
# Check CPU before operation
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)
if [ "$CPU_USAGE" -gt 80 ]; then
    echo "⚠️  CPU usage high, implementing throttling"
    # Reduce concurrent operations
    MAX_CONCURRENT=1
fi
```

### Network Prevention
```bash
# Check network latency before external call
NETWORK_TEST=$(ping -c 1 -W 1 api.example.com 2>/dev/null | grep "time=" | awk -F'=' '{print $4}' | cut -d' ' -f1)
if [ -z "$NETWORK_TEST" ]; then
    echo "⚠️  Network connectivity issue, using offline mode"
    use_offline_data
else
    use_online_data
fi
```

## Recovery Examples

### Memory Recovery
```bash
# When memory threshold exceeded
if [ "$MEMORY_USAGE" -gt "$MEMORY_THRESHOLD" ]; then
    echo "Executing memory recovery..."
    # Clean cache
    rm -f "$HOME/.openclaw/cache/*.tmp"
    rm -f "$HOME/.openclaw/tmp/*"
    # Restart services
    systemctl restart openclaw 2>/dev/null || openclaw gateway restart
fi
```

### Process Recovery
```bash
# When OpenClaw process not found
OPENCLAW_STATUS=$(ps aux | grep openclaw | grep -v grep | wc -l)
if [ "$OPENCLAW_STATUS" -eq 0 ]; then
    echo "OpenClaw not running, attempting recovery..."
    systemctl start openclaw 2>/dev/null || \
    openclaw gateway start 2>/dev/null || \
    echo "Unable to start OpenClaw"
fi
```

## Advanced Features

### Automatic Cleanup Schedule
```bash
# Schedule daily cleanup
(crontab -l 2>/dev/null; echo "0 1 * * * $HOME/.openclaw/workspace/skills/self-protection/scripts/recovery.sh execute") | crontab -
```

### Multi-level Throttling
```bash
# Multi-level throttling based on load
LOAD=$(uptime | awk -F'load average:' '{print $2}' | awk '{print $1}')
if (( $(echo "$LOAD > 3.0" | bc -l) )); then
    THROTTLE_LEVEL=3
elif (( $(echo "$LOAD > 2.0" | bc -l) )); then
    THROTTLE_LEVEL=2
elif (( $(echo "$LOAD > 1.0" | bc -l) )); then
    THROTTLE_LEVEL=1
else
    THROTTLE_LEVEL=0
fi
```

### Notification System
```bash
# Send notifications for critical alerts
if [ "$ALERT" = "critical" ]; then
    # Send email notification
    if [ "$email_notifications" = "true" ]; then
        send_email "Critical Alert: ${ALERT_MESSAGE}"
    fi
    # Send Slack notification
    if [ "$slack_notifications" = "true" ]; then
        send_slack "Critical Alert: ${ALERT_MESSAGE}"
    fi
fi
```