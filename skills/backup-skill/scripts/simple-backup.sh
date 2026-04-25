#!/bin/bash

# Simple Backup Script
# Creates backup archive and shows backup options

BACKUP_DIR="$HOME/.openclaw/workspace/skills/backup-skill/cache"
BACKUP_FILE="$BACKUP_DIR/openclaw-backup.tar.gz"
WORKSPACE_DIR="$HOME/.openclaw/workspace"

# Initialize backup directory
mkdir -p "$BACKUP_DIR"

# Create backup archive
create_archive() {
    echo "Creating backup archive..."
    
    # Go to workspace directory
    cd "$WORKSPACE_DIR"
    
    # Create temporary backup directory
    TEMP_DIR="$BACKUP_DIR/temp"
    mkdir -p "$TEMP_DIR"
    
    # Copy skills directory (except backup-skill itself)
    for skill in skills/*; do
        if [ "$skill" != "skills/backup-skill" ]; then
            cp -r "$skill" "$TEMP_DIR/skills/"
        fi
    done
    
    # Copy important files
    cp -r memory "$TEMP_DIR/memory"
    cp HEARTBEAT.md "$TEMP_DIR/"
    cp SOUL.md "$TEMP_DIR/"
    cp USER.md "$TEMP_DIR/"
    cp TOOLS.md "$TEMP_DIR/"
    cp AGENTS.md "$TEMP_DIR/"
    cp IDENTITY.md "$TEMP_DIR/"
    
    # Copy .openclaw directory if exists
    if [ -d ".openclaw" ]; then
        cp -r .openclaw "$TEMP_DIR/.openclaw"
    fi
    
    # Create archive
    cd "$TEMP_DIR"
    tar -czf "$BACKUP_FILE" .
    cd "$WORKSPACE_DIR"
    
    # Cleanup
    rm -rf "$TEMP_DIR"
    
    BACKUP_SIZE=$(du -h "$BACKUP_FILE" | awk '{print $1}')
    BACKUP_DATE=$(date)
    
    echo "✅ Backup created: $BACKUP_FILE"
    echo "Size: ${BACKUP_SIZE}"
    echo "Date: ${BACKUP_DATE}"
    
    # Create backup info
    cat > "$BACKUP_DIR/backup-info.md" << EOF
# Backup Information

## Backup Details
- Date: ${BACKUP_DATE}
- Size: ${BACKUP_SIZE}
- File: ${BACKUP_FILE}

## Contents Included
1. All skills directory (~/.openclaw/workspace/skills/)
2. Workspace files:
   - HEARTBEAT.md
   - SOUL.md
   - USER.md
   - TOOLS.md
   - AGENTS.md
   - IDENTITY.md
3. Memory files (~/.openclaw/workspace/memory/)
4. Configuration (~/.openclaw/.openclaw/)

## Skills List
$(ls "$WORKSPACE_DIR/skills/" | grep -v "backup-skill" | sort)

## Total Skills: $(ls "$WORKSPACE_DIR/skills/" | grep -v "backup-skill" | wc -l)

## Recent Skills Created
$(find "$WORKSPACE_DIR/skills/" -type f -name "SKILL.md" | sed 's|.*/skills/||' | sed 's|/SKILL.md||' | grep -v "backup-skill" | sort)
EOF
    
    echo "✅ Backup info created: $BACKUP_DIR/backup-info.md"
}

# Show backup options
show_options() {
    echo "=== Backup Options ==="
    echo ""
    echo "1. Archive Backup (local)"
    echo "   backup-skill archive"
    echo ""
    echo "2. Encrypted Backup"
    echo "   backup-skill encrypt"
    echo "   backup-skill encrypt --password <password>"
    echo ""
    echo "3. Backup Info"
    echo "   backup-skill info"
    echo ""
    echo "=== Backup Contents ==="
    echo "Archive includes:"
    echo "- Skills directory (all skills)"
    echo "- Workspace files (HEARTBEAT.md, SOUL.md, etc.)"
    echo "- Memory files"
    echo "- Configuration files"
    echo ""
    echo "Total skills: $(ls "$WORKSPACE_DIR/skills/" | grep -v "backup-skill" | wc -l)"
    echo "Skills size: $(du -sh "$WORKSPACE_DIR/skills/" | awk '{print $1}')"
}

# Create encrypted backup
create_encrypted() {
    local password="$1"
    
    echo "Creating encrypted backup..."
    create_archive
    
    if [ -z "$password" ]; then
        echo "Creating encrypted backup without password..."
        openssl enc -aes-256-cbc -salt -in "$BACKUP_FILE" -out "$BACKUP_FILE.enc" -k ""
        ENCRYPTED_SIZE=$(du -h "$BACKUP_FILE.enc" | awk '{print $1}')
        
        echo "✅ Encrypted backup created: $BACKUP_FILE.enc"
        echo "Size: ${ENCRYPTED_SIZE}"
        echo "To decrypt: openssl enc -aes-256-cbc -d -in $BACKUP_FILE.enc -out openclaw-backup.tar.gz -k \"\""
    else
        echo "Creating encrypted backup with password..."
        openssl enc -aes-256-cbc -salt -in "$BACKUP_FILE" -out "$BACKUP_FILE.enc" -pass pass:"$password"
        ENCRYPTED_SIZE=$(du -h "$BACKUP_FILE.enc" | awk '{print $1}')
        
        echo "✅ Encrypted backup created: $BACKUP_FILE.enc"
        echo "Size: ${ENCRYPTED_SIZE}"
        echo "Password: $password"
        echo "To decrypt: openssl enc -aes-256-cbc -d -in $BACKUP_FILE.enc -out openclaw-backup.tar.gz -pass pass:\"$password\""
    fi
}

# Show backup info
show_info() {
    if [ -f "$BACKUP_DIR/backup-info.md" ]; then
        echo "=== Backup Information ==="
        cat "$BACKUP_DIR/backup-info.md"
        
        echo ""
        echo "=== Backup Files ==="
        ls -lh "$BACKUP_DIR/" | grep -E "backup|enc"
        
        echo ""
        echo "=== Backup History ==="
        find "$BACKUP_DIR" -name "*.tar.gz" -o -name "*.tar.gz.enc" | sort
        
        echo ""
        echo "=== Download Instructions ==="
        echo "To download backup file, use:"
        echo "cp $BACKUP_FILE ~/backup/"
        echo "or"
        echo "scp $BACKUP_FILE user@remote:/path/to/backup/"
    else
        echo "No backup information found."
        echo "Run: backup-skill archive"
    fi
}

# Main function
main() {
    local command="$1"
    local arg="$2"
    
    case "$command" in
        "archive")
            create_archive
            ;;
        "encrypt")
            create_encrypted "$arg"
            ;;
        "info")
            show_info
            ;;
        "options")
            show_options
            ;;
        *)
            echo "Usage: backup-skill <command>"
            echo "Commands:"
            echo "  archive    - Create backup archive"
            echo "  encrypt    - Encrypted backup (optional password)"
            echo "  info       - Show backup information"
            echo "  options    - Show backup options"
            ;;
    esac
}

# Run main function
main "$@"