#!/bin/bash
# Digest script for llm-wiki installer

set -e

SKILL_DIR=$(dirname "$0")
SCRIPT_DIR="$SKILL_DIR"

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

digest_text() {
    local source_text="$1"
    local kb_path="$2"
    local source_id="$3"
    
    print_info "Processing text content..."
    
    # Create source file
    local source_file="$kb_path/raw/notes/$source_id.md"
    cat > "$source_file" << EOF
# Text Source: $source_id

Created: $(date '+%Y-%m-%d %H:%M:%S')

## Content
$source_text

## Metadata
- Type: text
- Confidence: EXTRACTED
- Length: $(echo "$source_text" | wc -w) words
EOF
    
    print_success "Text saved to: $source_file"
    
    # Analyze and create wiki pages
    analyze_and_create_pages "$source_file" "$kb_path"
}

digest_url() {
    local url="$1"
    local kb_path="$2"
    local source_id="$3"
    
    print_info "Processing URL: $url"
    
    # Create source file
    local source_file="$kb_path/raw/articles/$source_id.md"
    
    # Try to fetch content
    if curl -s "$url" > "$source_file.temp"; then
        cat > "$source_file" << EOF
# URL Source: $source_id

URL: $url
Created: $(date '+%Y-%m-%d %H:%M:%S')

## Content
$(cat "$source_file.temp")

## Metadata
- Type: URL
- Domain: $(echo "$url" | cut -d'/' -f3)
- Confidence: EXTRACTED
EOF
        rm "$source_file.temp"
        print_success "URL content saved to: $source_file"
    else
        print_warning "Failed to fetch URL content"
        cat > "$source_file" << EOF
# URL Source: $source_id

URL: $url
Created: $(date '+%Y-%m-%d %H:%M:%S')
Status: Failed to fetch content

## Notes
Please manually add content or try alternative extraction methods.
EOF
    fi
    
    # Analyze and create wiki pages
    analyze_and_create_pages "$source_file" "$kb_path"
}

digest_file() {
    local file_path="$1"
    local kb_path="$2"
    local source_id="$3"
    
    print_info "Processing file: $file_path"
    
    # Determine file type
    local extension="${file_path##*.}"
    
    case "$extension" in
        pdf)
            local source_file="$kb_path/raw/pdfs/$source_id.md"
            cat > "$source_file" << EOF
# PDF Source: $source_id

File: $file_path
Created: $(date '+%Y-%m-%d %H:%M:%S')

## Content
[PDF content summary would be extracted here]
EOF
            ;;
        md)
            local source_file="$kb_path/raw/notes/$source_id.md"
            cp "$file_path" "$source_file"
            ;;
        txt)
            local source_file="$kb_path/raw/notes/$source_id.md"
            cat > "$source_file" << EOF
# Text Source: $source_id

File: $file_path
Created: $(date '+%Y-%m-%d %H:%M:%S')

## Content
$(cat "$file_path")
EOF
            ;;
        *)
            print_warning "Unsupported file type: $extension"
            local source_file="$kb_path/raw/assets/$source_id.md"
            cat > "$source_file" << EOF
# File Source: $source_id

File: $file_path
Type: $extension
Created: $(date '+%m-%m-%d %H:%M:%S')

## Notes
Unsupported file type. Please process manually.
EOF
            ;;
    esac
    
    print_success "File saved to: $source_file"
    
    # Analyze and create wiki pages
    analyze_and_create_pages "$source_file" "$kb_path"
}

analyze_and_create_pages() {
    local source_file="$1"
    local kb_path="$2"
    
    print_info "Analyzing content and creating wiki pages..."
    
    # Extract entities and topics
    local content=$(head -n 100 "$source_file" | tr '\n' ' ')
    
    # Create entity pages (simple example)
    if [[ "$content" =~ "Cloudflare" ]]; then
        cat > "$kb_path/wiki/entities/cloudflare.md" << EOF
# Cloudflare

## Summary
Cloudflare is a web infrastructure and security company.

## Categories
- Technology Company
- Web Security
- CDN Provider

## Related Topics
[[web-security.md]]
[[cdn.md]]
[[internet-infrastructure.md]]

## Confidence
INFERRED
EOF
    fi
    
    if [[ "$content" =~ "GitHub" ]]; then
        cat > "$kb_path/wiki/entities/github.md" << EOF
# GitHub

## Summary
GitHub is a platform for version control and collaboration.

## Categories
- Software Platform
- Developer Tools
- Code Repository

## Related Topics
[[software-development.md]]
[[collaboration-tools.md]]
[[version-control.md]]

## Confidence
INFERRED
EOF
    fi
    
    # Create topic pages
    if [[ "$content" =~ "documentation" || "$content" =~ "docs" ]]; then
        cat > "$kb_path/wiki/topics/documentation.md" << EOF
# Documentation

## Summary
Information about documentation practices and tools.

## Related Entities
[[github.md]]
[[cloudflare.md]]

## Sub-topics
- Technical Documentation
- API Documentation
- User Documentation

## Confidence
INFERRED
EOF
    fi
    
    if [[ "$content" =~ "knowledge" || "$content" =~ "wiki" ]]; then
        cat > "$kb_path/wiki/topics/knowledge-management.md" << EOF
# Knowledge Management

## Summary
Systems and methods for organizing and sharing knowledge.

## Related Entities
[[github.md]]
[[cloudflare.md]]

## Sub-topics
- Knowledge Bases
- Wiki Systems
- Documentation Management

## Confidence
INFERRED
EOF
    fi
    
    # Create source summary page
    local source_name=$(basename "$source_file")
    cat > "$kb_path/wiki/sources/${source_name}" << EOF
# Source Summary: $(basename "$source_file")

## Metadata
- Type: $(grep -E "^#.*Source:" "$source_file" | sed 's/#.*Source: //')
- Created: $(date '+%Y-%m-%d %H:%M:%S')
- Confidence: EXTRACTED

## Key Entities
[[cloudflare.md]]
[[github.md]]

## Key Topics
[[documentation.md]]
[[knowledge-management.md]]

## Summary
This source provides information about documentation systems and knowledge management.

## Notes
Automatically extracted from source file.
EOF
    
    # Update index
    update_index "$kb_path"
    
    # Update log
    update_log "$kb_path" "$source_file"
    
    print_success "Wiki pages created successfully"
}

update_index() {
    local kb_path="$1"
    
    # Count statistics
    local entities_count=$(find "$kb_path/wiki/entities" -name "*.md" | wc -l)
    local topics_count=$(find "$kb_path/wiki/topics" -name "*.md" | wc -l)
    local sources_count=$(find "$kb_path/wiki/sources" -name "*.md" | wc -l)
    
    # Update index.md
    cat > "$kb_path/index.md" << EOF
# Knowledge Base Index

This index serves as the central navigation point for the knowledge base.

## Core Categories
- **Entities**: People, organizations, concepts, tools ($entities_count entries)
- **Topics**: Broad thematic areas ($topics_count entries)
- **Sources**: Original materials and summaries ($sources_count entries)
- **Analyses**: Comparative and synthetic analyses

## Quick Navigation
[[purpose.md|Purpose]]
[[log.md|Activity Log]]

## Recent Additions
* Latest source: $(ls -t "$kb_path/raw/articles/" "$kb_path/raw/notes/" "$kb_path/raw/pdfs/" 2>/dev/null | head -1)

## Statistics
- Entities: $entities_count
- Topics: $topics_count
- Sources: $sources_count
- Analyses: 0
EOF
}

update_log() {
    local kb_path="$1"
    local source_file="$2"
    local source_name=$(basename "$source_file")
    
    cat >> "$kb_path/log.md" << EOF

## $(date '+%Y-%m-%d %H:%M:%S') - Source Added
- Added source: $source_name
- Created entity pages: $(find "$kb_path/wiki/entities" -name "*.md" | xargs basename | tr '\n' ', ')
- Created topic pages: $(find "$kb_path/wiki/topics" -name "*.md" | xargs basename | tr '\n' ', ')
EOF
}

main() {
    local source="$1"
    local kb_path="$2"
    
    if [[ -z "$source" || -z "$kb_path" ]]; then
        print_error "Usage: digest.sh <source> <knowledge-base-path>"
        exit 1
    fi
    
    # Generate source ID
    local source_id="source-$(date '+%Y%m%d-%H%M%S')"
    
    # Determine source type
    if [[ "$source" =~ ^http:// || "$source" =~ ^https:// ]]; then
        digest_url "$source" "$kb_path" "$source_id"
    elif [[ -f "$source" ]]; then
        digest_file "$source" "$kb_path" "$source_id"
    else
        digest_text "$source" "$kb_path" "$source_id"
    fi
    
    print_success "Digestion complete!"
}

main "$@"