#!/bin/bash
# llm-wiki installer script for OpenClaw

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

check_dependencies() {
    local dependencies=("git" "bash" "python3" "node")
    local missing=()
    
    for dep in "${dependencies[@]}"; do
        if ! command -v "$dep" >/dev/null 2>&1; then
            missing+=("$dep")
        fi
    done
    
    if [[ ${#missing[@]} -gt 0 ]]; then
        print_error "Missing dependencies: ${missing[*]}"
        echo "Please install the missing dependencies first."
        exit 1
    fi
}

setup_knowledge_base() {
    local kb_name="$1"
    local kb_path="$2"
    
    print_info "Setting up knowledge base: $kb_name at $kb_path"
    
    mkdir -p "$kb_path"
    
    # Create basic structure
    mkdir -p "$kb_path/raw/articles"
    mkdir -p "$kb_path/raw/tweets"
    mkdir -p "$kb_path/raw/wechat"
    mkdir -p "$kb_path/raw/xiaohongshu"
    mkdir -p "$kb_path/raw/zhihu"
    mkdir -p "$kb_path/raw/pdfs"
    mkdir -p "$kb_path/raw/notes"
    mkdir -p "$kb_path/raw/assets"
    
    mkdir -p "$kb_path/wiki/entities"
    mkdir -p "$kb_path/wiki/topics"
    mkdir -p "$kb_path/wiki/sources"
    mkdir -p "$kb_path/wiki/comparisons"
    mkdir -p "$kb_path/wiki/synthesis/sessions"
    mkdir -p "$kb_path/wiki/queries"
    
    # Create purpose.md template
    cat > "$kb_path/purpose.md" << 'EOF'
# Research Purpose

This knowledge base is designed to systematically organize and maintain information on:

## Primary Research Areas
1. [Topic 1]
2. [Topic 2]
3. [Topic 3]

## Secondary Interests
- [Interest 1]
- [Interest 2]
- [Interest 3]

## Methodological Approach
- Systematic organization with entity and topic pages
- Confidence annotations (EXTRACTED/INFERRED/AMBIGUOUS/UNVERIFIED)
- Bidirectional linking for cross-references
- Regular health checks and updates

## Goals
- Build a comprehensive personal knowledge base
- Enable quick retrieval and reference
- Facilitate continuous learning and synthesis
EOF
    
    # Create index.md template
    cat > "$kb_path/index.md" << 'EOF'
# Knowledge Base Index

This index serves as the central navigation point for the knowledge base.

## Core Categories
- **Entities**: People, organizations, concepts, tools
- **Topics**: Broad thematic areas
- **Sources**: Original materials and summaries
- **Analyses**: Comparative and synthetic analyses

## Quick Navigation
[[purpose.md|Purpose]]
[[log.md|Activity Log]]

## Recent Additions
* No entries yet. Add materials to populate the knowledge base.

## Statistics
- Entities: 0
- Topics: 0
- Sources: 0
- Analyses: 0
EOF
    
    # Create log.md template
    cat > "$kb_path/log.md" << 'EOF'
# Activity Log

This log tracks all operations performed on the knowledge base.

## 2026-04-29 - Knowledge Base Created
- Created knowledge base structure
- Initialized purpose.md and index.md
EOF
    
    # Create .wiki-schema.md template
    cat > "$kb_path/.wiki-schema.md" << 'EOF'
# Wiki Schema Configuration

## Page Types
- **entity**: People, organizations, concepts, tools
- **topic**: Broad thematic areas
- **source**: Original material summaries
- **comparison**: Comparative analysis between entities/topics
- **synthesis**: Synthetic analysis combining multiple sources
- **query**: Saved query results

## Confidence Levels
- EXTRACTED: Directly extracted from source
- INFERRED: Derived/inferred content
- AMBIGUOUS: Ambiguous content
- UNVERIFIED: Content requiring verification

## Bidirectional Link Syntax
- `[[page-name|display-text]]` for links with custom display text
- `[[page-name]]` for simple links

## Auto-generation Rules
- Source digest: Creates source page + entity/topic pages
- Entity mention: Links to existing entity page
- Topic mention: Links to existing topic page
EOF
    
    # Create .wiki-cache.json template
    cat > "$kb_path/.wiki-cache.json" << 'EOF'
{
  "cache": {},
  "last_update": "2026-04-29",
  "version": "1.0.0"
}
EOF
    
    print_success "Knowledge base setup complete"
}

main() {
    print_info "llm-wiki installer for OpenClaw"
    
    # Check dependencies
    check_dependencies
    
    # Parse arguments
    local kb_name="my-knowledge-base"
    local kb_path=""
    local target_dir="$HOME/.openclaw/workspace/knowledge-base"
    
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --name)
                kb_name="$2"
                shift 2
                ;;
            --path)
                kb_path="$2"
                shift 2
                ;;
            --target-dir)
                target_dir="$2"
                shift 2
                ;;
            *)
                print_error "Unknown option: $1"
                exit 1
                ;;
        esac
    done
    
    # Set default path if not specified
    if [[ -z "$kb_path" ]]; then
        kb_path="$target_dir/$kb_name"
    fi
    
    # Setup knowledge base
    setup_knowledge_base "$kb_name" "$kb_path"
    
    print_info "Knowledge base ready at: $kb_path"
    print_info "To add content, use: 'bash $SKILL_DIR/scripts/digest.sh <source> $kb_path'"
    print_info "Or tell your AI assistant: '帮我消化这篇: <source-url-or-file>'"
}

# Run main function
main "$@"