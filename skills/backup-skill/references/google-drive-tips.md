# Google Drive备份技巧

## 📝 Google Drive容量管理（15GB免费版）

### 1. 优化备份大小
- **选择性备份**: 只备份4个核心技能 (12KB)
- **优化备份**: 备份所有技能但排除缓存 (45KB)
- **标准备份**: 完整备份 (1.1MB)

### 2. 备份频率
- **每日**: 选择性备份 (12KB)
- **每周**: 优化备份 (45KB)
- **每月**: 标准备份 + 加密备份 (1.1MB)

### 3. 文件命名建议
```
openclaw-backup-YYYY-MM-DD.tar.gz
例如：openclaw-backup-2026-04-25.tar.gz
```

## 💾 最大化利用Google Drive

### 1. 使用Google Drive压缩功能
Google Drive会自动压缩某些文件，tar.gz已经是压缩格式。

### 2. 定期清理
- 每月删除旧的备份文件
- 保留最近3个月的备份
- 删除超过1年的备份

### 3. 分类存储
```
Google Drive文件夹结构：
└── OpenClaw备份
    ├── 每日备份 (选择性)
    ├── 每周备份 (优化)
    ├── 月度备份 (完整)
```

## 🔧 手动上传步骤

### 步骤1：创建备份
```bash
backup-skill google-drive optimized
```

### 步骤2：查看备份文件
```bash
ls -lh ~/.openclaw/workspace/skills/backup-skill/cache/
```

### 步骤3：复制备份文件
```bash
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/
```

### 步骤4：打开Google Drive
访问：https://drive.google.com

### 步骤5：上传文件
1. 点击左上角的"新建"按钮
2. 选择"文件上传"
3. 选择你下载的备份文件
4. 点击"打开"

## 📅 备份计划建议

### 周一：选择性备份 (12KB)
```bash
# 周一备份（最小）
backup-skill google-drive selective
```

### 周日：优化备份 (45KB)
```bash
# 周日备份（中等）
backup-skill google-drive optimized
```

### 月底：完整备份 (1.1MB)
```bash
# 月底完整备份
backup-skill archive
backup-skill encrypt --password yourpassword
```

## 💡 备份自动化脚本

```bash
#!/bin/bash
# auto-backup.sh

DATE=$(date +%Y-%m-%d)

# 每周备份类型
if [ $(date +%u) -eq 1 ]; then
    # 周一：选择性备份
    backup-skill google-drive selective
    BACKUP_FILE="openclaw-backup-selective-$DATE.tar.gz"
elif [ $(date +%u) -eq 7 ]; then
    # 周日：优化备份
    backup-skill google-drive optimized
    BACKUP_FILE="openclaw-backup-optimized-$DATE.tar.gz"
elif [ $(date +%d) -eq 30 ] || [ $(date +%d) -eq 31 ]; then
    # 月底：完整备份
    backup-skill archive
    backup-skill encrypt --password "monthly-$DATE"
    BACKUP_FILE="openclaw-backup-full-$DATE.tar.gz"
fi

# 复制到下载目录
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/$BACKUP_FILE

# 清理旧备份
backup-skill google-drive clean

echo "备份完成：$BACKUP_FILE"
echo "请上传到Google Drive"
```

## 🆘 常见问题

### Q: 备份文件下载失败？
A: 使用选择性备份，只有12KB：
```bash
backup-skill google-drive selective
```

### Q: Google Drive空间不足？
A: 清理旧的备份文件：
```bash
backup-skill google-drive clean
```

### Q: 忘记了上传？
A: 设置提醒：
```bash
(crontab -l 2>/dev/null; echo "0 4 * * 0 echo '请上传本周的OpenClaw备份到Google Drive'") | crontab -
```

## 📊 存储空间预估

### 备份占用计算
- **每日备份** (12KB × 30天) = 360KB/月
- **每周备份** (45KB × 4周) = 180KB/月
- **每月备份** (1.1MB × 1次) = 1.1MB/月
- **总计**: 约1.5MB/月

### 一年存储需求
- 每月1.5MB × 12月 = 18MB/年
- 加上加密备份 = 约24MB/年

**结论**: Google Drive的15GB容量完全足够！

## 📌 最佳实践

1. **周一**: 选择性备份 (12KB)
2. **周日**: 优化备份 (45KB)
3. **月底**: 完整加密备份 (1.1MB)
4. **清理**: 每月清理旧备份
5. **验证**: 定期下载验证备份文件

**备份文件会自动创建，你只需要手动上传到Google Drive即可。**