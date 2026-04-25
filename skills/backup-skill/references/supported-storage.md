# Supported Backup Storage Options

## 1. GitHub/GitLab/Gitee

### Requirements
- Git installed (`git`)
- Repository URL
- Access token (for private repositories)

### Setup Steps
1. Create a repository on GitHub/GitLab/Gitee
2. Clone locally:
```bash
git clone https://github.com/username/repository.git
```

3. Copy backup files:
```bash
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz repository/
```

4. Push to remote:
```bash
cd repository
git add openclaw-backup.tar.gz
git commit -m "OpenClaw backup $(date)"
git push
```

### Advantages
- Version control (track changes)
- Free (public repositories)
- Easy to share
- Automatic backup scripts available

## 2. Cloud Storage (阿里云OSS/腾讯云COS)

### Requirements
- Cloud storage account
- Access key and secret key
- Bucket created

### Setup Steps

#### Aliyun OSS
1. Install ossutil:
```bash
wget https://ossutil-release.aliyuncs.com/ossutil
chmod +x ossutil
```

2. Configure ossutil:
```bash
ossutil config
```

3. Upload backup:
```bash
ossutil cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz oss://bucket-name/
```

#### Tencent COS
1. Install coscmd:
```bash
pip install coscmd
```

2. Configure coscmd:
```bash
coscmd config -a access-key -s secret-key -b bucket-name -r region
```

3. Upload backup:
```bash
coscmd upload ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz /
```

### Advantages
- High availability
- Automatic scaling
- Multiple regions
- Secure storage

## 3. Webhook

### Requirements
- Webhook URL (from webhook.site, requestbin, etc.)
- HTTP access (curl)

### Setup Steps
1. Get webhook URL from:
   - https://webhook.site
   - https://requestbin.com
   - Custom webhook endpoint

2. Upload backup:
```bash
curl -X POST -F "file=@openclaw-backup.tar.gz" https://webhook.site/your-webhook-id
```

### Advantages
- Simple to set up
- No account required
- Real-time notifications
- Easy to integrate

## 4. Email Attachment

### Requirements
- Email client (mailx, sendmail, etc.)
- SMTP server credentials

### Setup Steps
1. Install mail tools:
```bash
apt-get install mailutils
```

2. Send email with attachment:
```bash
mail -s "OpenClaw Backup" -a openclaw-backup.tar.gz recipient@example.com
```

### Advantages
- Direct delivery
- Easy to access
- Personal storage
- Quick recovery

## 5. Encrypted Archive + Sharing

### Requirements
- Encryption tools (openssl)
- File sharing service (Google Drive, Dropbox, etc.)

### Setup Steps
1. Create encrypted archive:
```bash
openssl aes-256-cbc -in openclaw-backup.tar.gz -out openclaw-backup.tar.gz.enc -pass pass:yourpassword
```

2. Upload to sharing service:
   - Google Drive: https://drive.google.com
   - Dropbox: https://dropbox.com
   - OneDrive: https://onedrive.live.com

3. Share link with encryption password

### Advantages
- Secure (encrypted)
- Shareable link
- Multiple recipients
- Password protection

## 6. Self-hosted Solutions

### Requirements
- Self-hosted server or NAS
- SSH/rsync access

### Setup Steps
1. Set up SSH access:
```bash
ssh user@nas-server mkdir -p /backup/openclaw/
```

2. Copy via rsync:
```bash
rsync -avz ~/.openclaw/workspace/skills/ user@nas-server:/backup/openclaw/skills/
```

### Advantages
- Complete control
- Custom backup schedule
- Local storage
- Fast recovery

## 7. Automatic Backup Scheduling

### Cron Job Setup
```bash
# Daily backup at 3 AM
(crontab -l 2>/dev/null; echo "0 3 * * * $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh archive") | crontab -

# Weekly encrypted backup
(crontab -l 2>/dev/null; echo "0 4 * * 0 $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh encrypt") | crontab -
```

### Advantages
- Automated backup
- Scheduled retention
- Regular snapshots
- Disaster recovery

## Recommendation

For OpenClaw skills backup, I recommend:

1. **Start with archive backup**: Simple and quick
2. **Then encrypted backup**: Secure for sharing
3. **Consider GitHub**: Version control and history
4. **Add webhook backup**: Easy integration

### Backup Strategy
- Daily archive backup (local)
- Weekly encrypted backup (for sharing)
- Monthly GitHub backup (for history)
- Emergency webhook backup (for quick transfer)