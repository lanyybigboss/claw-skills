---
name: backup-skill
description: Backup skills and workspace files locally with encryption options and Google Drive optimization.
read_when:
  - Need to backup skills to prevent data loss
  - Want encrypted backups for secure storage
  - Need optimized backup for Google Drive limited capacity
metadata: {"clawdbot":{"emoji":"📦","requires":{"bins":["tar","openssl"]}}}
---

# Backup Skill

This skill provides backup solutions for OpenClaw skills and workspace files, with encryption options and Google Drive optimization.

## Backup Features

### 1. Archive Backup
- Creates compressed tar.gz archive
- Includes all skills and workspace files
- Easy to copy and share

### 2. Encrypted Backup
- AES-256-CBC encryption
- Optional password protection
- Secure for external storage

### 3. Google Drive Optimized Backup
- Optimized for 15GB free plan
- Selective backup (only essentials)
- Auto cleanup (keep only 3 backups)
- Max 100MB per backup

### 4. Backup Information
- Shows backup file details
- Lists included skills
- Provides download instructions

## Quick Commands

### Create Backup Archive
```bash
backup-skill archive
```

### Create Encrypted Backup
```bash
backup-skill encrypt
backup-skill encrypt --password yourpassword
```

### Google Drive Optimized Backup
```bash
backup-skill google-drive optimized   # Optimized backup
backup-skill google-drive selective   # Minimal backup
backup-skill google-drive clean       # Clean old backups
```

### Show Backup Information
```bash
backup-skill info
```

### Show Backup Options
```bash
backup-skill options
```

## Implementation Files

The skill includes:
1. `scripts/back1. Google Drive Backup (Optimized for limited capacity)
- **Advantages**: Optimized for 15GB free plan
- **Features**: Selective backup, old backups cleanup
up-skill.sh` - Main backup script
2. `scripts/google-drive-backup.sh` - Google Drive optimized backup
3. `references/config.json` - Backup configuration
4. `references/supported-storage.md` - Supported storage options

## Usage Examples

### Archive Skills
```bash
backup-skill archive
```

### Encrypted Backup
```bash
backup-skill encrypt
```

### Encrypted Backup with Password
```bash
backup-skill encrypt --password yourpassword
```

### Google Drive Backup
```bash
backup-skill google-drive optimized   # For limited storage
backup-skill google-drive selective    # Minimal backup
```

### Backup Information
```bash
backup-skill info
```

### Backup Options
```bash
backup-skill options
```

## Backup Contents

This skill will backup:
1. All skills (`~/.openclaw/workspace/skills/*`)
2. Workspace files (`HEARTBEAT.md`, `SOUL.md`, `USER.md`, `TOOLS.md`, `AGENTS.md`, `IDENTITY.md`)
3. Memory files (`~/.openclaw/workspace/memory/`)
4. Configuration files (`~/.openclaw/.openclaw/`)

## Google Drive Optimization

### For Limited Capacity (15GB)
- **Optimized backup**: Excludes cache/log files
- **Selective backup**: Only critical skills (self-protection, openclaw-docs, fnnas-docs)
- **Auto cleanup**: Only 3 recent backups kept
- **Size limit**: Max 100MB per backup

### Google Drive Upload Instructions
```bash
# Create optimized backup
backup-skill google-drive optimized

# Check backup size
ls -lh ~/.openclaw/workspace/skills/backup-skill/cache/

# Copy backup to your downloads
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/

# Then upload to Google Drive via Web UI:
# https://drive.google.com
```

## Installation Requirements

- `tar` - For archive creation
- `openssl` - For encryption (optional)

## Backup Options

### Google Drive Backup Strategy
For limited capacity (15GB free plan):
1. **Optimized backup**: Only essentials, exclude cache files
2. **Selective backup**: Only critical skills
3. **Auto cleanup**: Keep only 3 recent backups
4. **Size limit**: Max 100MB per backup

### Download Instructions
```bash
# Copy backup file to Google Drive
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/

# Or download encrypted backup
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz.enc ~/Downloads/

# Then upload to Google Drive
```

### Storage Recommendations
1. **Google Drive**: Upload optimized backups
2. **Local NAS**: Store encrypted backups
3. **GitHub**: Version control backup
4. **Cloud storage**: Aliyun OSS/Tencent COS

## Encryption Security

- **Algorithm**: AES-256-CBC
- **Password**: Optional password protection
- **Decryption**: Openssl command required
- **Security**: Secure for external storage

## Backup Schedule

For automatic backup, add to cron:
```bash
# Weekly optimized backup for Google Drive
(crontab -l 2>/dev/null; echo "0 3 * * 0 $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh google-drive optimized") | crontab -

# Monthly encrypted backup
(crontab -l 2>/dev/null; echo "0 4 * * 1 $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh encrypt") | crontab -

# Backup info report
(crontab -l 2>/dev/null; echo "0 5 * * 1 $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh info") | crontab -
```