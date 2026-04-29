---
name: llm-wiki-installer
description: Install and manage llm-wiki personal knowledge base system based on Karpathy's methodology. Use when user wants to build a structured wiki for personal knowledge management with AI assistance. Supports multiple platforms (OpenClaw, Claude Code, Codex, Hermes) and various content sources (web articles, PDFs, Twitter/X, YouTube, WeChat articles).
---

# llm-wiki Installer Skill

This skill helps install and manage the llm-wiki personal knowledge base system, a tool for organizing fragmented information into a continuously growing, interconnected knowledge repository.

## What is llm-wiki?

llm-wiki is a personal knowledge base system based on Andrej Karpathy's methodology. It transforms scattered information into a structured wiki that AI helps maintain and grow over time.

### Key Features

- **AI-powered organization**: AI extracts core knowledge from various sources and organizes it into interconnected wiki pages
- **Continuous growth**: Knowledge base accumulates and improves with each use, not starting fresh every time
- **Local storage**: All content is stored as local markdown files, compatible with Obsidian or any editor
- **Multi-platform**: Supports OpenClaw, Claude Code, Codex, and Hermes
- **Multiple sources**: Web articles, PDFs, X/Twitter, WeChat articles, YouTube, Zhihu, Xiaohongshu (Red Book), and local files

## Installation Guide

### Basic Installation (OpenClaw)

To install llm-wiki for OpenClaw:

```bash
# Clone the repository
git clone https://github.com/sdyckjq-lab/llm-wiki-skill.git

# Navigate to the repository
cd llm-wiki-skill

# Install for OpenClaw
bash install.sh --platform openclaw
```

Default installation location: `~/.openclaw/skills/llm-wiki`

### Installation with Optional Extractors

For full support of web articles, X/Twitter, YouTube, Zhihu, and WeChat articles:

```bash
bash install.sh --platform openclaw --with-optional-adapters
```

### Custom Installation Directory

If your OpenClaw skills directory is different:

```bash
bash install.sh --platform openclaw --target-dir <your-skill-directory>/llm-wiki
```

## Usage Guide

### 1. Initialize Knowledge Base

Tell the AI:
> "帮我初始化一个知识库"

This creates the basic structure:
```
knowledge-base/
├── raw/                    # Raw materials (immutable)
│   ├── articles/           # Web articles
│   ├── tweets/             # X/Twitter
│   ├── wechat/             # WeChat articles
│   ├── xiaohongshu/        # Xiaohongshu
│   ├── zhihu/             # Zhihu
│   ├── pdfs/              # PDFs
│   ├── notes/             # Notes
│   └── assets/            # Images and attachments
├── wiki/                   # AI-generated knowledge base
│   ├── entities/          # Entity pages (people, concepts, tools)
│   ├── topics/            # Topic pages
│   ├── sources/           # Source summaries
│   ├── comparisons/       # Comparative analysis
│   ├── synthesis/         # Synthetic analysis
│   │   └── sessions/      # Dialogue crystallization pages
│   └── queries/           # Saved query results
├── purpose.md              # Research direction and goals
├── index.md               # Index
├── log.md                 # Operation log
├── .wiki-schema.md        # Configuration
└── .wiki-cache.json       # Source deduplication cache
```

### 2. Digest Materials

Give the AI a link or file:
> "帮我消化这篇：<URL or file path>"

AI will extract core knowledge and create structured wiki pages with bidirectional links `[[bidirectional links]]`.

### 3. Interactive Knowledge Graph

The system generates a self-contained HTML knowledge graph with Chinese landscape style design:

```bash
# View the knowledge graph
open knowledge-base/wiki-graph.html
```

Features:
- **Three-column layout**: Chinese landscape style with mountain-water background
- **Interactive canvas**: Drag, zoom, search, filter
- **Node hierarchy**: Location names, index tags, annotations
- **Learning queue**: Left-side panel with community, focus, search, learning queue
- **Offline operation**: No server dependency

### 4. Confidence Annotation

Content is marked with confidence levels:
- **EXTRACTED**: Directly extracted from source
- **INFERRED**: Derived/inferred content
- **AMBIGUOUS**: Ambiguous content
- **UNVERIFIED**: Content requiring verification

## Core Advantages

| Advantage | Description |
|---|---|
| **Digital Landscape Knowledge Graph** | Interactive HTML graph with Chinese landscape design |
| **Graph Reading Experience** | Nodes categorized by location names, index tags, annotations |
| **Local Reading Path** | Integrated community, focus, search, learning queue |
| **Zero-config Initialization** | One sentence creates complete knowledge base |
| **Structured Wiki** | Auto-generated entity pages, topic pages, source summaries |
| **Confidence Annotation** | EXTRACTED/INFERRED/AMBIGUOUS/UNVERIFIED classification |
| **Smart Cache** | SHA256 deduplication + write-as-update + self-healing |
| **Dialogue Crystallization** | Convert valuable dialogue content into knowledge pages |
| **Auto Context Injection** | SessionStart hook makes AI automatically aware of knowledge base |
| **Multi-format Analysis** | Deep reports, comparison tables, timelines |

## Supported Content Sources

| Category | Source | Processing Method |
|---|---|---|
| Core | PDF, Markdown, text, HTML, plain text paste | Direct digestion, no external dependencies |
| Optional | Web articles, X/Twitter, WeChat articles, YouTube, Zhihu | Automatic extraction; manual fallback if extraction fails |
| Manual | Xiaohongshu (Red Book) | Currently only manual paste support |

Optional extractors require explicit installation:
```bash
bash install.sh --platform openclaw --with-optional-adapters
```

## Health Check

Run periodic health checks:
```bash
bash ${SKILL_DIR}/scripts/health-check.sh
```

Checks for:
- Isolated pages
- Broken links
- Index consistency
- AI-level contradiction detection
- Cross-reference validation

## Windows Users

Windows PowerShell 5.1 has default GB2312 encoding causing issues. Use one of these solutions:

**Option A — Use install.ps1 (Recommended)**

```powershell
powershell -ExecutionPolicy Bypass -File install.ps1 --platform openclaw
```

**Option B — Manually set PowerShell encoding**

```powershell
chcp 65001
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = 'utf-8'
bash install.sh --platform openclaw
```

**Option C — Upgrade to PowerShell 7+**

```powershell
winget install Microsoft.PowerShell
pwsh
bash install.sh --platform openclaw
```

## Upgrading

If already installed:
```bash
bash install.sh --upgrade --platform openclaw
```

For Claude Code users, use: `/llm-wiki-upgrade`

For custom directories:
```bash
bash install.sh --upgrade --platform openclaw --target-dir <your-skill-directory>/llm-wiki
```

## Prerequisites

- **Core**: AI agent capable of executing shell commands and reading/writing local files
- **Graph building and source coverage check**: `jq` + `node`
- **Optional**: WeChat article extraction requires `uv`; web extraction requires `bun` or `npm`
- **Login-based content**: Enable Chrome debugging port 9222

## Quick Commands

```bash
# Initialize knowledge base
bash ${SKILL_DIR}/scripts/init.sh <knowledge-base-name>

# Digest a source
bash ${SKILL_DIR}/scripts/digest.sh <source-url-or-path> <knowledge-base-path>

# Generate knowledge graph
bash ${SKILL_DIR}/scripts/graph.sh <knowledge-base-path>

# Health check
bash ${SKILL_DIR}/scripts/health-check.sh <knowledge-base-path>

# Batch processing
bash ${SKILL_DIR}/scripts/batch.sh <directory-path> <knowledge-base-path>

# Save conversation as knowledge
bash ${SKILL_DIR}/scripts/save-session.sh <conversation-file> <knowledge-base-path>
```

## Troubleshooting

**Common issues:**

1. **Optional extractors missing**: Run with `--with-optional-adapters`
2. **X/Twitter extraction fails**: Ensure Chrome debugging port 9222 is enabled
3. **WeChat extraction fails**: Requires `uv`, reinstall with `--with-optional-adapters`
4. **Windows encoding issues**: Use `install.ps1` or upgrade to PowerShell 7+

## Integration Guide

### With Obsidian

All content is local markdown, directly compatible with Obsidian:
```bash
# Open knowledge base in Obsidian
open knowledge-base/
```

### With Other Editors

Works with any markdown editor:
- VS Code
- Vim/Neovim
- Sublime Text
- Markdown editors

## License

MIT License