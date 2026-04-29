#!/bin/bash
# Health check script for llm-wiki knowledge base

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

check_structure() {
    local kb_path="$1"
    
    print_info "Checking knowledge base structure..."
    
    # Check required directories
    local required_dirs=("raw/articles" "raw/notes" "wiki/entities" "wiki/topics" "wiki/sources")
    
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$kb_path/$dir" ]]; then
            print_warning "Missing directory: $kb_path/$dir"
            mkdir -p "$kb_path/$dir"
        fi
    done
    
    # Check required files
    local required_files=("purpose.md" "index.sd" "log.md" ".wiki-schema.md" ".wiki-cache.json")
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$kb_path/$file" ]]; then
            print_warning "Missing file: $kb_path/$file"
            # Create default file
            case "$file" in
                "purpose.md")
                    cat > "$kb_path/purpose.md" << 'EOF'
# Research Purpose

This knowledge base needs a purpose document. Please define your research goals.
EOF
                    ;;
                "index.md")
                    cat > "$kb_path/index.md" << 'EOF'
# Knowledge Base Index

This index serves as the central navigation point for the knowledge base.

## Core Categories
- Entities: People, organizations, concepts, tools
- Topics: Broad thematic areas
- Sources: Original materials and summaries
- Analyses: Comparative and synthetic analyses

## Quick Navigation
[[purpose.md|Purpose]]
[[log.md|Activity Log]]

## Recent Additions
* No entries yet. Add materials to populate the knowledge base.

## Statistics
Entities: 0
Topics: 0
Sources: 0
Analyses: 0
EOF
                    ;;
                "log.md")
                    cat > "$kb_path/log.md" << 'EOF'
# Activity Log

This log tracks all operations performed on the knowledge base.

## Creation Date - Knowledge Base Created
Created knowledge base structure
Initialized purpose.md and index.md
EOF
                    ;;
                ".wiki-schema.md")
                    cat > "$kb_path/.wiki-schema.md" << 'EOF'
# Wiki Schema Configuration

## Page Types
- entity: People, organizations, concepts, tools
- topic: Broad thematic areas
- source: Original material summaries
- comparison: Comparative analysis between entities/topics
- synthesis: Synthetic analysis combining multiple sources
- query: Saved query results

## Confidence Levels
- EXTRACTED: Directly extracted from source
- INFERRED: Derived/inferred content
- AMBIGUOUS: Ambiguous content
- UNVERIFIED: Content requiring verification

## Bidirectional Link Syntax
- [[page-name|display-text]] for links with custom display text
- [[page-name]] for simple links

## Auto-generation Rules
- Source digest: Creates source page + entity/topic pages
- Entity mention: Links to existing entity page
- Topic mention: Links to existing topic page
EOF
                    ;;
                ".wiki-cache.json")
                    cat > "$kb_path/.wiki-cache.json" << 'EOF'
{
  "cache": {},
  "last_update": "2026-04-29",
  "version": "1.0.0"
}
EOF
                    ;;
            esac
        fi
    done
    
    print_success "Structure check complete"
}

check_isolation() {
    local kb_path="$1"
    
    print_info "Checking for isolated pages..."
    
    local isolated_files=()
    
    # Check wiki files for cross-references
    for wiki_dir in "entities" "topics" "sources"; do
        for file in "$kb_path/wiki/$wiki_dir"/*.md; do
            if [[ -f "$file" ]]; then
                local content=$(cat "$file")
                
                # Check if file contains bidirectional links
                if ! [[ "$content" =~ \[\[.*\]\] ]]; then
                    isolated_files+=("$file")
                fi
            fi
        done
    done
    
    if [[ ${#isolated_files[@]} -gt 0 ]]; then
        print_warning "Found isolated files without bidirectional links:"
        for file in "${isolated_files[@]}"; do
            echo "  - $(basename "$file")"
        done
    else
        print_success "No isolated files found"
    fi
}

check_broken_links() {
    local kb_path="$1"
    
    print_info "Checking for broken links..."
    
    local broken_links=()
    
    # Find all wiki files
    local wiki_files=$(find "$kb_path/wiki" -name "*.md")
    
    for file in $wiki_files; do
        if [[ -f "$file" ]]; then
            local content=$(cat "$file")
            
            # Extract all links
            local links=$(echo "$content" | grep -o '\[\[.*\]\]' | sed 's/\[\[\(.*\)\]\]/\1/' | sed 's/.*|//')
            
            for link in $links; do
                # Check if linked file exists
                local linked_file=$(find "$kb_path/wiki" -name "$link.md" 2>/dev/null)
                
                if [[ -z "$linked_file" ]]; then
                    broken_links+=("$file -> $link.md")
                fi
            done
        fi
    done
    
    if [[ ${#broken_links[@]} -gt 0 ]]; then
        print_warning "Found broken links:"
        for link in "${broken_links[@]}"; do
            echo "  - $link"
        done
    else
        print_success "No broken links found"
    fi
}

check_index_consistency() {
    local kb_path="$1"
    
    print_info "Checking index consistency..."
    
    local index_file="$kb_path/index.md"
    
    if [[ -f "$index_file" ]]; then
        local index_content=$(cat "$index_file")
        
        # Check statistics section
        local stats_match=$(echo "$index_content" | grep -o "Entities:.*Topics:.*Sources:.*Analyses:" | wc -l)
        
        if [[ $stats_match -eq 0 ]]; then
            print_warning "Index missing statistics section"
        fi
        
        # Check if index contains navigation links
        local links_match=$(echo "$index_content" | grep -o '\[\[.*\]\]' | wc -l)
        
        if [[ $links_match -eq 0 ]]; then
            print_warning "Index missing navigation links"
        fi
    else
        print_error "Index file missing"
    fi
    
    print_success "Index check complete"
}

check_cross_references() {
    local kb_path="$1"
    
    print_info "Checking cross-references..."
    
    local entity_files=$(find "$kb_path/wiki/entities" -name "*.md")
    local topic_files=$(find "$kb_path/wiki/topics" -name "*.md")
    
    # Count files
    local entity_count=$(echo "$entity_files" | wc -l)
    local topic_count=$(echo "$topic_files" | wc -l)
    
    print_info "Found $entity_count entity files and $topic_count topic files"
    
    # Check if entities reference topics
    local entity_with_topic_refs=0
    for file in $entity_files; do
        if [[ -f "$file" ]]; then
            local content=$(cat "$file")
            if [[ "$content" =~ topics ]]; then
                entity_with_topic_refs=$((entity_with_topic_refs + 1))
            fi
        fi
    done
    
    # Check if topics reference entities
    local topic_with_entity_refs=0
    for file in $topic_files; do
        if [[ -f "$file" ]]; then
            local content=$(cat "$file")
            if [[ "$content" =~ entities ]]; then
                topic_with_entity_refs=$((topic_with_entity_refs + 1))
            fi
        fi
    done
    
    print_info "Entities referencing topics: $entity_with_topic_refs/$entity_count"
    print_info "Topics referencing entities: $topic_with_entity_refs/$topic_count"
    
    print_success "Cross-reference check complete"
}

check_cache() {
    local kb_path="$1"
    
    print_info "Checking cache..."
    
    local cache_file="$kb_path/.wiki-cache.json"
    
    if [[ -f "$cache_file" ]]; then
        local cache_size=$(jq '.cache | length' "$cache_file" 2>/dev/null || echo "0")
        local last_update=$(jq -r '.last_update' "$cache_file" 2>/dev/null || echo "unknown")
        local version=$(jq -r '.version' "$cache_file" 2>/dev/null || echo "unknown")
        
        print_info "Cache size: $cache_size entries"
        print_info "Last update: $last_update"
        print_info "Version: $version"
    else
        print_warning "Cache file missing"
    fi
    
    print_success "Cache check complete"
}

generate_report() {
    local kb_path="$1"
    
    print_info "Generating health report..."
    
    local report_file="$kb_path/health-report.md"
    
    cat > "$report_file" << EOF
# Knowledge Base Health Report

Generated: $(date '+%Y-%m-%d %H:%M:%S')
Knowledge Base: $(basename "$kb_path")

## Structure Status
$(check_structure "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]|\[WARNING\]|\[ERROR\]" | sed 's/^.*\[.*\]//')

## Isolation Status
$(check_isolation "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]|\[WARNING\]" | sed 's/^.*\[.*\]//')

## Broken Links Status
$(check_broken_links "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]|\[WARNING\]" | sed 's/^.*\[.*\]//')

## Index Consistency Status
$(check_index_consistency "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]|\[WARNING\]|\[ERROR\]" | sed 's/^.*\[.*\]//')

## Cross-Reference Status
$(check_cross_references "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]" | sed 's/^.*\[.*\]//')

## Cache Status
$(check_cache "$kb_path" 2>&1 | grep -E "\[INFO\]|\[SUCCESS\]|\[WARNING\]" | sed 's/^.*\[.*\]//')

## Recommendations
1. Review isolated files and add appropriate links
2. Fix broken links by creating missing pages
3. Update index.md with current statistics
4. Ensure cache is properly maintained

## Statistics
- Total files: $(find "$kb_path/wiki" -name "*.md" | wc -l)
- Entity files: $(find "$kb_path/wiki/entities" -name "*.md" | wc -l)
- Topic files: $(find "$kb_path/wiki/topics" -name "*.md" | wc -l)
- Source files: $(find "$kb_path/wiki/sources" -name "*.md" | wc -l)
EOF
    
    print_success "Health report generated: $report_file"
}

main() {
    local kb_path="$1"
    
    if [[ -z "$kb_path" ]]; then
        print_error "Usage: health-check.sh <knowledge-base-path>"
        exit 1
    fi
    
    # Run all checks
    check_structure "$kb_path"
    check_isolation "$kb_path"
    check_broken_links "$kb_path"
    check_index_consistency "$kb_path"
    check_cross_references "$kb_path"
    check_cache "$kb_path"
    
    # Generate report
    generate_report "$kb_path"
    
    print_success "Health check completed successfully!"
}

main "$@"