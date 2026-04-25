# Google Drive备份操作指南

## 📋 备份步骤

### 1. 创建优化备份
```bash
backup-skill google-drive optimized
```

### 2. 查看备份文件
```bash
ls -lh ~/.openclaw/workspace/skills/backup-skill/cache/
```

你会看到：
```
openclaw-backup.tar.gz      # 优化备份 (约45KB)
backup-info.md              # 备份信息文档
```

### 3. 下载备份文件
```bash
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/
```

### 4. 上传到Google Drive
打开 https://drive.google.com
点击"新建" → "文件上传"
选择你下载的备份文件

## 🗂️ 备份文件说明

### 优化备份文件
文件名：`openclaw-backup.tar.gz`
大小：约45KB
内容：所有技能的核心文件（排除缓存和日志）

### 备份信息文件
文件名：`backup-info.md`
内容：备份日期、大小、包含的技能列表

## ⏰ 自动备份设置

你可以设置自动备份，每周创建新的备份文件：

### 设置每周备份
```bash
# 添加到crontab
(crontab -l 2>/dev/null; echo "0 3 * * 0 $HOME/.openclaw/workspace/skills/backup-skill/scripts/backup-skill.sh google-drive optimized") | crontab -
```

### 设置备份提醒
```bash
# 每周提醒你上传备份
(crontab -l 2>/dev/null; echo "0 4 * * 0 echo '请上传本周的OpenClaw备份到Google Drive'") | crontab -
```

## 🔄 备份清理

### 自动清理旧备份
```bash
backup-skill google-drive clean
```

默认保留3个备份，自动删除旧的备份文件。

### 查看当前备份
```bash
backup-skill info
```

## 📱 手机上传（备用方案）

如果你不方便使用电脑，可以：

1. **使用手机下载备份**
   - 通过浏览器下载备份文件
   - 保存到手机存储

2. **使用手机上传到Google Drive**
   - 安装Google Drive应用
   - 上传备份文件

## 🛠️ 快速脚本

这里是一个快速备份和上传脚本：

```bash
#!/bin/bash
# backup-and-upload.sh

# 创建备份
echo "创建备份..."
backup-skill google-drive optimized

# 复制到下载目录
echo "复制备份文件..."
cp ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz ~/Downloads/

# 备份信息
echo "备份信息："
ls -lh ~/.openclaw/workspace/skills/backup-skill/cache/openclaw-backup.tar.gz
echo "备份文件已准备好，请上传到Google Drive"
```

## 📊 备份大小对比

| 备份类型 | 大小 | 适合场景 |
|---------|------|----------|
| 选择性备份 | 12KB | 日常快速备份 |
| 优化备份 | 45KB | 每周完整备份 |
| 标准备份 | 1.1MB | 每月完整备份 |

## 💾 存储建议

1. **Google Drive**: 存放优化备份 (45KB)
2. **本地存储**: 存放标准备份 (1.1MB)
3. **GitHub**: 存放选择性备份 (12KB)

## 🆘 问题解决

### 备份文件太大？
```bash
# 使用选择性备份
backup-skill google-drive selective
# 只有12KB
```

### 备份太频繁？
```bash
# 减少备份频率
backup-skill google-drive clean
# 清理旧备份
```

### 忘记上传？
```bash
# 查看备份文件
backup-skill info
# 确认备份存在
```

## 📌 重要提示

- **备份频率**: 建议每周备份一次
- **备份大小**: 优化备份约45KB，适合Google Drive
- **上传方式**: 手动上传最简单安全
- **存储位置**: Google Drive + 本地NAS双重存储

**注意**: 由于安全限制，我无法直接访问你的Google Drive，需要你手动上传备份文件。