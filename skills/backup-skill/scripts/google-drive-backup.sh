#!/bin/bash

# Google Drive Backup Script
# Optimized for limited capacity

BACKUP_DIR="$HOME/.openclaw/workspace/skills/backup-skill/cache"
BACKUP_FILE="$BACKUP_DIR/openclaw-backup.tar.gz"
WORKSPACE_DIR="$HOME/.openclaw/workspace"
MAX_BACKUPS=3  # 最多保留3个备份文件
MAX_SIZE_MB=100  # 单个备份不超过100MB

# Create optimized backup
create_optimized_backup() {
    echo "Creating optimized backup for Google Drive..."
    
    # Go to workspace directory
    cd "$WORKSPACE_DIR"
    
    # Create temporary backup directory
    TEMP_DIR="$BACKUP_DIR/temp"
    mkdir -p "$TEMP_DIR"
    
    # Copy skills directory (optimized)
    echo "Copying optimized skills..."
    for skill in skills/*; do
        if [ "$skill" != "skills/backup-skill" ]; then
            skill_name=$(basename "$skill")
            
            # Only copy essential files
            mkdir -p "$TEMP_DIR/skills/$skill_name"
            
            if [ -f "$skill/SKILL.md" ]; then
                cp "$skill/SKILL.md" "$TEMP_DIR/skills/$skill_name/SKILL.md"
            fi
            
            if [ -d "$skill/scripts" ]; then
                mkdir -p "$TEMP_DIR/skills/$skill_name/scripts"
                cp "$skill/scripts/*.sh" "$TEMP_DIR/skills/$skill_name/scripts/" 2>/dev/null
            fi
            
            if [ -d "$skill/references" ]; then
                mkdir -p "$TEMP_DIR/skills/$skill_name/references"
                cp "$skill/references/*.md" "$TEMP_DIR/skills/$skill_name/references/" 2>/dev/null
                cp "$skill/references/*.json" "$TEMP_DIR/skills/$skill_name/references/" 2>/dev/null
            fi
            
            # Skip cache and log files
            echo "Skill $skill_name optimized"
        fi
    done
    
    # Copy essential workspace files
    echo "Copying workspace files..."
    cp HEARTBEAT.md "$TEMP_DIR/"
    cp SOUL.md "$TEMP_DIR/"
    cp USER.md "$TEMP_DIR/"
    cp TOOLS.md "$TEMP_DIR/"
    cp AGENTS.md "$TEMP_DIR/"
    cp IDENTITY.md "$TEMP_DIR/"
    
    # Copy memory files (only recent)
    mkdir -p "$TEMP_DIR/memory"
    find memory -name "*.md" -type f | sort -r | head -5 | while read file; do
        cp "$file" "$TEMP_DIR/memory/"
    done
    
    # Create archive
    cd "$TEMP_DIR"
    tar -czf "$BACKUP_FILE" .
    cd "$WORKSPACE_DIR"
    
    # Cleanup temporary directory
    rm -rf "$TEMP_DIR"
    
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
    BACKUP_DATE=$(date)
    
    echo "✅ Optimized backup created: $BACKUP_FILE"
    echo "Size: ${BACKUP_SIZE}"
    echo "Date: ${BACKUP_DATE}"
    
    # Check if backup is too large
    SIZE_MB=$(du -m "$BACKUP_FILE" | awk '{print $1}')
    if [ "$SIZE_MB" -gt "$MAX_SIZE_MB" ]; then
        echo "⚠️ Backup too large (${SIZE_MB}MB > ${MAX_SIZE_MB}MB)"
        echo "Recommendation: Consider excluding more files"
    fi
    
    # Create backup info
    cat > "$BACKUP_DIR/backup-info.md" << EOF
# Google Drive Backup Information

## Backup Details
- Date: ${BACKUP_DATE}
- Size: ${BACKUP_SIZE} (${SIZE_MB}MB)
- File: ${BACKUP_FILE}
- Type: Optimized for Google Drive

## Contents Included
1. Essential skills (SKILL.md, scripts, references)
2. Workspace files (HEARTBEAT.md, SOUL.md, USER.md, TOOLS.md, AGENTS.md, IDENTITY.md)
3. Recent memory files (last 5 days)

## Skills List
$(ls "$WORKSPACE_DIR/skills/" | grep -v "backup-skill" | sort)

## Total Skills: $(ls "$WORKSPACE_DIR/skills/" | grep -v "backup-skill" | wc -l)

## Exclusions
- Cache files (*.cache)
- Log files (*.log)
- Large temporary files
- Old memory files (>5 days)

EOF
    
    echo "✅ Backup info created: $BACKUP_DIR/backup-info.md"
}

# Clean old backups
clean_old_backups() {
    echo "Cleaning old backups..."
    
    # List all backup files
    BACKUP_FILES=$(find "$BACKUP_DIR" -name "openclaw-backup*.tar.gz" -o -name "openclaw-backup*.tar.gz.enc" | sort)
    
    COUNT=$(echo "$BACKUP_FILES" | wc -l)
    
    if [ "$COUNT" -gt "$MAX_BACKUPS" ]; then
        echo "Found ${COUNT} backups, removing oldest ${COUNT}-${MAX_BACKUPS}"
        
        # Remove oldest backups
        i=0
        for file in $BACKUP_FILES; do
            i=$((i+1))
            if [ "$i" -gt "$MAX_BACKUPS" ]; then
                echo "Removing: $file"
                rm "$file"
            fi
        done
        
        echo "✅ Removed ${COUNT}-${MAX_BACKUPS} old backups"
    else
        echo "✅ Backup count ${COUNT} <= ${MAX_BACKUPS}, no cleanup needed"
    fi
    
    # Clean cache directory
    echo "Cleaning backup cache..."
    rm -rf "$BACKUP_DIR/temp"
}

# Show Google Drive backup options
show_google_drive_options() {
    echo "=== Google Drive Backup Options ==="
    echo ""
    echo "1. Optimized Backup"
    echo "   backup-skill google-drive"
    echo ""
    echo "2. Selective Backup (only essentials)"
    echo "   backup-skill selective"
    echo ""
    echo "3. Incremental Backup (only new/changed)"
    echo "   backup-skill incremental"
    echo ""
    echo "4. Clean Old Backups"
    echo "   backup-skill clean"
    echo ""
    echo "=== Optimization Features ==="
    echo "- Only SKILL.md, scripts, references files"
    echo "- Exclude cache and log files"
    echo "- Keep only recent memory files (5 days)"
    echo "- Maximum size: ${MAX_SIZE_MB}MB"
    echo "- Maximum backups: ${MAX_BACKUPS}"
    echo ""
    echo "=== Upload to Google Drive ==="
    echo "1. Download backup file"
    echo "   cp $BACKUP_FILE ~/Downloads/"
    echo ""
    echo "2. Upload via Google Drive Web UI"
    echo "   https://drive.google.com"
    echo ""
    echo "3. Or via CLI (if you have google-drive-ocamlfuse)"
    echo "   google-drive-ocamlfuse"
    echo "   cp $BACKUP_FILE ~/google-drive/"
    echo ""
    echo "=== Recommendations ==="
    echo "- Backup weekly instead of daily"
    echo "- Delete old backups from Google Drive"
    echo "- Use selective backup for small size"
}

# Selective backup (only essentials)
selective_backup() {
    echo "Creating selective backup (only essentials)..."
    
    cd "$WORKSPACE_DIR"
    TEMP_DIR="$BACKUP_DIR/temp"
    mkdir -p "$TEMP_DIR"
    
    # Only backup these essential skills (most important)
    ESSENTIAL_SKILLS="self-protection backup-skill openclaw-docs fnnas-docs"
    
    for skill_name in $ESSENTIAL_SKILLS; do
        if [ -d "skills/$skill_name" ]; then
            mkdir -p "$TEMP_DIR/skills/$skill_name"
            
            if [ -f "skills/$skill_name/SKILL.md" ]; then
                cp "skills/$skill_name/SKILL.md" "$TEMP_DIR/skills/$skill_name/"
            fi
            
            # Only essential references
            if [ -f "skills/$skill_name/references/thresholds.json" ]; then
                mkdir -p "$TEMP_DIR/skills/$skill_name/references"
                cp "skills/$skill_name/references/thresholds.json" "$TEMP_DIR/skills/$skill_name/references/"
            fi
            
            echo "Essential skill $skill_name added"
        fi
    done
    
    # Essential workspace files
    cp HEARTBEAT.md "$TEMP_DIR/"
    cp SOUL.md "$TEMP_DIR/"
    cp USER.md "$TEMP_DIR/"
    cp AGENTS.md "$TEMP_DIR/"
    
    # Create archive
    cd "$TEMP_DIR"
    tar -czf "$BACKUP_DIR/openclaw-selective.tar.gz" .
    cd "$WORKSPACE_DIR"
    
    rm -rf "$TEMP_DIR"
    
    SIZE=$(du -h "$BACKUP_DIR/openclaw-selective.tar.gz" | awk '{print $1}')
    echo "✅ Selective backup created: $BACKUP_DIR/openclaw-selective.tar.gz"
    echo "Size: ${SIZE}"
    echo "Essential skills included: $ESSENTIAL_SKILLS"
}

# Main function for Google Drive backup
google_drive_main() {
    local command="$1"
    
    case "$command" in
        "optimized")
            create_optimized_backup
            clean_old_backups
            ;;
        "selective")
            selective_backup
            ;;
        "clean")
            clean_old_backups
            ;;
        "options")
            show_google_drive_options
            ;;
        *)
            echo "Usage: backup-skill google-drive <command>"
            echo "Commands:"
            echo "  optimized - Create optimized backup for Google Drive"
            echo "  selective - Selective backup (only essentials)"
            echo "  clean     - Clean old backups"
            echo "  options   - Show Google Drive backup options"
            ;;
    esac
}

# Run Google Drive backup
google_drive_main "$@"