# Self Protection System - README

## Overview

This skill provides comprehensive self-protection mechanisms for OpenClaw agent to prevent crashes, implement load balancing, perform hourly heartbeat checks, and enable automatic recovery.

## Why Self Protection is Needed

OpenClaw agents can experience:
- **Frequent crashes** due to resource exhaustion
- **Memory leaks** from long-running operations
- **CPU overload** from concurrent requests
- **Disk space depletion** from cache and logs
- **Network issues** affecting external API calls
- **Process conflicts** causing dead processes

## Features

### 1. Load Balancing
- **Operation Queue**: Manage concurrent operations with priority queue
- **Throttling**: Limit operations based on system load
- **Rate Limiting**: Control API calls and network requests
- **Graceful Degradation**: Reduce functionality under high load

### 2. Hourly Heartbeat Checks
- **System Monitoring**: CPU, memory, disk usage
- **Process Health**: OpenClaw service status
- **Network Connectivity**: External API availability
- **Resource Thresholds**: Alert when thresholds exceeded

### 3. Crash Prevention
- **Early Detection**: Detect issues before they cause crashes
- **Alert System**: Notify when thresholds exceeded
- **Graceful Handling**: Handle failures gracefully
- **Automatic Recovery**: Self-recover from failures

### 4. Performance Monitoring
- **Real-time Metrics**: Monitor system performance
- **Historical Data**: Track performance trends
- **Threshold Analysis**: Analyze threshold violations
- **Pattern Detection**: Detect recurring issues

### 5. Automatic Recovery
- **Memory Recovery**: Clear cache when memory high
- **Disk Recovery**: Clean logs when disk full
- **Process Recovery**: Restart failed processes
- **Network Recovery**: Fallback to offline mode

## File Structure

```
self-protection/
├── SKILL.md                    # Skill configuration
├── scripts/
│   ├── self-protection.sh      # Main script
│   ├── heartbeat.sh            # Hourly heartbeat checks
│   ├── load-balancer.sh        # Load balancing
│   └── recovery.sh             # Crash recovery
├── references/
│   ├── thresholds.json         # Resource thresholds
│   ├── crash-log.md            # Crash history log
│   ├── examples.md             # Usage examples
│   └── README.md               # This file
├── cache/
│   ├── health-status.json      # Current health status
│   ├── operation-queue.json    # Operation queue
│   ├── heartbeat.log           # Heartbeat log
│   └── system-metrics.log      # System metrics
```

## Usage Examples

### Basic Health Check
```bash
self-protection check
```

### Load Monitoring
```bash
self-protection load
```

### Resource Report
```bash
self-protection resources
```

### Heartbeat Management
```bash
self-protection heartbeat start  # Start hourly checks
self-protection heartbeat stop   # Stop hourly checks
self-protection heartbeat check  # Run heartbeat check
```

### Recovery Procedures
```bash
self-protection recover          # Standard recovery
self-protection recover --force  # Force recovery
self-protection crash-log last   # View last crash
self-protection crash-log all    # View all crashes
```

## Thresholds Configuration

Default thresholds (configurable in `thresholds.json`):
- CPU: 80%
- Memory: 85%
- Disk: 90%
- Load Average: 2.5
- Network Latency: 500ms
- Max Concurrent Operations: 3
- Queue Max Size: 10

## Scheduling

### Hourly Heartbeat Checks
The system will automatically perform hourly checks if scheduled:

```bash
# Add to cron
self-protection heartbeat start
```

### Automatic Recovery
When thresholds exceeded:
1. Clean cache when memory >85%
2. Delete old logs when disk >90%
3. Restart services when CPU >80%
4. Fallback when network >500ms latency

## Integration with OpenClaw

This skill integrates with:
- **OpenClaw Health Monitoring**: Uses OpenClaw's own health checks
- **System Cron**: Hourly heartbeat checks via cron
- **System Tools**: Uses ps, top, uptime, curl, etc.
- **Logging**: Logs to OpenClaw's own logs
- **Cache**: Uses OpenClaw's cache directory

## Best Practices

### For Load Balancing
1. **Queue Operations**: Use operation queue for heavy tasks
2. **Throttle Intelligently**: Adjust throttling based on load
3. **Prioritize Tasks**: Prioritize critical operations
4. **Graceful Degradation**: Reduce functionality under load

### For Crash Prevention
1. **Monitor Regularly**: Hourly heartbeat checks
2. **Early Detection**: Detect issues early
3. **Graceful Handling**: Handle failures gracefully
4. **Automatic Recovery**: Self-recover automatically

### For Performance Monitoring
1. **Track Metrics**: Monitor performance trends
2. **Analyze Patterns**: Detect recurring issues
3. **Adjust Thresholds**: Configure appropriate thresholds
4. **Log History**: Keep historical data for analysis

## Customization

You can customize:
- **Thresholds**: Edit `thresholds.json`
- **Heartbeat Schedule**: Adjust cron job schedule
- **Recovery Actions**: Modify `recovery.sh`
- **Queue Settings**: Edit queue parameters
- **Monitoring Frequency**: Adjust heartbeat interval

## Getting Started

1. **Install Skill**: Ensure skill is in `~/.openclaw/workspace/skills/`
2. **Test Functions**: Run `self-protection check` to test
3. **Schedule Heartbeat**: Run `self-protection heartbeat start`
4. **Set Up Load Balancing**: Run `load-balancer setup`
5. **Configure Thresholds**: Edit `thresholds.json`

## Troubleshooting

### Common Issues
1. **Skill not found**: Ensure skill is in correct directory
2. **Command not found**: Ensure scripts have execute permissions
3. **Permission issues**: Check user permissions for cron jobs
4. **Cron not running**: Check cron service status

### Solutions
1. **Check skill location**: `ls ~/.openclaw/workspace/skills/`
2. **Check permissions**: `chmod +x scripts/*.sh`
3. **Check cron status**: `systemctl status cron`
4. **Check logs**: `cat cache/heartbeat.log`

## Support

For issues or questions:
1. **Check logs**: `cat cache/heartbeat.log`
2. **Check status**: `self-protection check`
3. **View crash history**: `self-protection crash-log all`
4. **Review thresholds**: `cat references/thresholds.json`