---
name: NAS Management
description: Manage FeiNiu NAS (飞牛NAS) via SSH, including system monitoring, backup, and configuration.
read_when:
  - Need to manage NAS system
  - Need NAS backup scripts
  - Need NAS configuration guidance
metadata: {"clawdbot":{"emoji":"📦","requires":{"bins":["sshpass","ssh","tar","curl"]}}}
---

# FeiNiu NAS Management

## SSH Connection Commands

### Basic Connection
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun
```

### IPv6 Connection
```bash
sshpass -p "claw114514" ssh claw@2408:825c:2022:2942:2e0:70ff:fea6:8173
```

### System Information
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "uname -a"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "df -h"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "free -h"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "top -bn1"
```

### Service Management
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "systemctl list-units | grep nas"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "systemctl status nas-service"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "systemctl restart nas-service"
```

### Backup Commands
```bash
# Data backup
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tar czf /tmp/nas-data-backup.tar.gz /data"

# Config backup
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tar czf /tmp/nas-config-backup.tar.gz /etc/nas"

# Apps backup
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tar czf /tmp/nas-apps-backup.tar.gz /opt/apps"

# Logs backup
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tar czf /tmp/nas-logs-backup.tar.gz /var/log/nas"
```

### File Management
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "ls -la /data"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "du -sh /data/*"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "find /data -name '*.tar.gz' -size +100M"
```

### Logs and Monitoring
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "journalctl -u nas-service"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "cat /var/log/nas/app.log"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tail -f /var/log/nas/error.log"
```

### Network Configuration
```bash
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "ip a"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "cat /etc/netplan/config.yaml"
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "ping -c 2 google.com"
```

## NAS Address Information
- Domain: fast.lanyybigboss.fun
- IPv4: 182.89.87.22
- IPv6: 2408:825c:2022:2942:2e0:70ff:fea6:8173
- SSH Port: 22
- User: claw
- Password: claw114514

## Connection Test Script
```bash
sshpass -p "claw114514" ssh -o StrictHostKeyChecking=no claw@fast.lanyybigboss.fun "echo SSH连接成功!"
sshpass -p "claw114514" ssh -o StrictHostKeyChecking=no claw@2408:825c:2022:2942:2e0:70ff:fea6:8173 "echo SSH连接成功!"
```

## Daily Backup Script
```bash
#!/bin/bash
#!/bin/bash
# NAS每日备份脚本

NAS_USER="claw"
NAS_PASSWORD="claw114514"
NAS_HOST="fast.lanyybigboss.fun"

DATE=$(date '+%Y-%m-%d')
BACKUP_DIR="/root/.openclaw/backups"

mkdir -p "$BACKUP_DIR"

echo "📦 NAS每日备份: $DATE"

# 备份数据
sshpass -p "$NAS_PASSWORD" ssh "$NAS_USER@$NAS_HOST" "tar czf /tmp/nas-data-$DATE.tar.gz /data"

# 备份配置
sshpass -p "$NAS_PASSWORD" ssh "$NAS_USER@$NAS_HOST" "tar czf /tmp/nas-config-$DATE.tar.gz /etc/nas"

# 下载备份到本地
sshpass -p "$NAS_PASSWORD" scp "$NAS_USER@$NAS_HOST:/tmp/nas-data-$DATE080c157a1.000z" "$BACKUP_DIR/"
sshpass -p "$NAS_PASSWORD" scp "$NAS_USER@$NAS_HOST:/tmp/nas-config-$DATE.tar.gz" "$BACKUP_DIR/"

# 清理NAS上的临时备份
sshpass -p "$NAS_PASSWORD" ssh "$NAS_USER@$NAS_HOST" "rm /tmp/nas-data-$DATE.tar.gz /tmp/nas-config-$DATE.tar.gz"

echo "✅ 备份完成"
echo "本地备份位置: $BACKUP_DIR"
```

## Troubleshooting
### Network Issues
```bash
# DNS resolution
nslookup fast.lanyybigboss.fun

# Ping test
ping -c 2 fast.lanyybigboss.fun
ping -c 2 182.89.87.22

# SSH connection test
sshpass -p "claw114514" ssh -v claw@fast.lanyybigboss.fun

# Port test
nc -zv fast.lanyybigboss.fun 22
nc -zv 182.89.87.22 22
```

### SSH Issues
```bash
# SSH verbose mode for debugging
sshpass -p "claw114514" ssh -vvv claw@fast.lanyybigboss.fun

# Check SSH service
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "systemctl status ssh"

# Check firewall
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "iptables -L"
```

### Alternative Connection Methods
```bash
# IPv4 connection
sshpass -p "claw114514" ssh claw@182.89.87.22

# IPv6 connection
sshpass -p "claw114514" ssh claw@2408:825c:2022:2942:2e0:70ff:fea6:8173

# With timeout
sshpass -p "claw114514" ssh -o ConnectTimeout=10 claw@fast.lanyybigboss.fun
```

## Integration with GitHub Skills Repository
### Backup NAS Skills to GitHub
```bash
# Clone NAS skills from NAS
sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "tar czf /tmp/nas-skills.tar.gz /root/.openclaw/workspace/skills"

# Download and sync to GitHub
sshpass -p "claw114514" scp claw@fast.lanyybigboss.fun:/tmp/nas-skills.tar.gz /tmp/
tar xzf /tmp/nas-skills.tar.gz -C /tmp/claw-skills/skills/
./skill-sync.sh
```

### Schedule NAS Backups
```bash
# Cron job for daily NAS backup
0 2 * * * /root/.openclaw/workspace/nas-backup-daily.sh

# Cron job for hourly NAS monitoring
0 * * * * sshpass -p "claw114514" ssh claw@fast.lanyybigboss.fun "df -h && free -h > /tmp/nas-status.log"
```

## Notes
- NAS is at fast.lanyybigboss.fun
- SSH port is 22
- IPv6 address: 2408:825c:2022:2942:2e0:70ff:fea6:8173
- IPv4 address: 182.89.87.22
- User: claw, Password: claw114514
- Connection may need network configuration adjustments