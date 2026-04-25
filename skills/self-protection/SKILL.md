---
name: self-protection
description: Self-protection system for OpenClaw agent to prevent frequent crashes, implement load balancing, hourly heartbeat self-check, and automatic recovery.
read_when:
  - Agent is experiencing frequent crashes
  - System needs load balancing
  - Hourly health check is required
  - Memory or process monitoring needed
metadata: {"clawdbot":{"emoji":"🛡️","requires":{"bins":["ps","top","uptime","curl"]}}}
---

# Self Protection System

This skill provides self-protection mechanisms for OpenClaw agent to ensure stable operation and prevent frequent crashes.

## Features

### 1. Load Balancing
- Monitor system resource usage
- Limit concurrent operations
- Queue management for heavy tasks
- Automatic throttling based on load

### 2. Hourly Heartbeat Self-Check
- System health monitoring
- Memory usage checks
- Process health verification
- External service connectivity tests

### 3. Crash Prevention
- Early warning detection
- Automatic recovery procedures
- Crash logging and analysis
- Fallback mechanisms

### 4. Performance Monitoring
- CPU usage tracking
- Memory usage monitoring
- Disk space checks
- Network connectivity verification

### 5. Automatic Recovery
- Failed operation retry logic
- Graceful degradation
- Resource cleanup
- State restoration

## Quick Commands

### Health Check
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

### Start Hourly Heartbeat
```bash
self-protection heartbeat start
```

### Stop Hourly Heartbeat
```bash
self-protection heartbeat stop
```

### Crash Analysis
```bash
self-protection crash-log
```

### Recovery Procedures
```bash
self-protection recover
```

## Implementation Details

### Load Balancing Algorithm
1. Monitor system load using `uptime`, `top`, `ps`
2. Track concurrent operations count
3. Implement operation queue with priority
4. Throttle new requests when load > 70%

### Heartbeat Check Schedule
1. Run hourly (via cron or scheduler)
2. Check:
   - System uptime and stability
   - OpenClaw service status
   - Memory usage and limits
   - External dependencies (API connectivity)
3. Log results to health log file
4. Alert if thresholds exceeded

### Crash Prevention Measures
1. Rate limiting for external API calls
2. Memory usage monitoring (set thresholds)
3. Process watchdog for critical services
4. Graceful shutdown on signal
5. Automatic cleanup of orphaned processes

### Performance Thresholds
- CPU usage: >80% triggers throttling
- Memory usage: >85% triggers cleanup
- Disk space: <10% free triggers alert
- Network: latency >500ms triggers fallback

## Implementation Files

The skill includes:
1. `scripts/self-protection.sh` - Main protection script
2. `scripts/load-balancer.sh` - Load balancing algorithm
3. `scripts/heartbeat.sh` - Hourly heartbeat check
4. `scripts/recovery.sh` - Crash recovery procedures
5. `references/thresholds.json` - Resource thresholds
6. `references/crash-log.md` - Crash analysis log
7. `cache/health-status.json` - Current health status
8. `cache/system-metrics.log` - System metrics history

## Usage Examples

### Basic Health Check
```bash
self-protection check
```

### Start Hourly Monitoring
```bash
self-protection heartbeat start
```

### Load Balancing Setup
```bash
self-protection load setup
```

### Crash Recovery
```bash
self-protection recover --force
```

### Analyze Recent Crash
```bash
self-protection crash-log --last
```

## Integration with OpenClaw

This skill integrates with:
- OpenClaw's own health monitoring
- System cron for heartbeat scheduling
- Memory monitoring tools
- Process management utilities

## Installation Requirements

- `ps` - Process monitoring
- `top` - System load monitoring
- `uptime` - System uptime
- `curl` - API connectivity tests
- `jq` - JSON processing (optional)
- `awk` - Text processing (optional)