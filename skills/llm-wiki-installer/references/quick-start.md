# llm-wiki Quick Start Guide

This guide provides quick examples for using llm-wiki with OpenClaw.

## Installation

### 1. Clone the Repository

```bash
# Clone the original llm-wiki-skill repository
git clone https://github.com/sdyckjq-lab/llm-wiki-skill.git
cd llm-wiki-skill

# Install for OpenClaw
bash install.sh --platform openclaw

# For full support of web/X/YouTube/WeChat/Zhihu extraction
bash install.sh --platform openclaw --with-optional-adapters
```

### 2. Or Use Simplified Installer

```bash
# Use simplified installer (no external dependencies required)
bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/install.sh --name my-knowledge-base
```

Default location: `~/.openclaw/workspace/knowledge-base/my-knowledge-base`

## Basic Usage

### Initialize Knowledge Base

Tell OpenClaw:
> "帮我初始化一个知识库"

This creates:
```
~/.openclaw/workspace/knowledge-base/my-knowledge-base/
├── purpose.md
├── index.md
├── log.md
├── .wiki-schema.md
├── .wiki-cache.json
├── raw/                    # Raw materials (immutable)
├── wiki/                   # AI-generated knowledge base
```

### Add Content

#### Web Article
```bash
bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/digest.sh \
  "https://example.com/article" \
  ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

#### PDF File
```bash
bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/digest.sh \
  "~/Downloads/document.pdf" \
  ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

#### Text Content
```bash
bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/digest.sh \
  "This is important information about quantum computing." \
  ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

### Health Check

```bash
bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/health-check.sh \
  ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

## Example Workflows

### Workflow 1: Build Research Knowledge Base

```bash
# Initialize
bash install.sh --name quantum-computing-research --path ~/research/knowledge-base

# Add key papers
bash digest.sh "https://arxiv.org/abs/quantum-paper.pdf" ~/research/knowledge-base
bash digest.sh "~/Downloads/quantum-experiment.pdf" ~/research/knowledge-base

# Add notes
bash digest.sh "Quantum entanglement basics and applications" ~/research/knowledge-base

# Health check
bash health-check.sh ~/research/knowledge-base
```

### Workflow 2: Project Documentation

```bash
# Initialize
bash install.sh --name project-docs --path ~/projects/docs

# Add project documentation
bash digest.sh "https://docs.project.com/api-reference" ~/projects/docs
bash digest.sh "~/project/README.md" ~/projects/docs
bash digest.sh "Team meeting notes about API design" ~/projects/docs

# Regular maintenance
bash health-check.sh ~/projects/docs
```

### Workflow 3: Learning Repository

```bash
# Initialize
bash install.sh --name learning-materials --path ~/learning/knowledge-base

# Add learning resources
bash digest.sh "https://tutorial.com/advanced-python" ~/learning/knowledge-base
bash digest.sh "~/books/python-book.pdf" ~/learning/knowledge-base
bash digest.sh "My Python learning journey" ~/learning/knowledge-base

# Track progress
bash health-check.sh ~/learning/knowledge-base
```

## Integration with AI

### OpenAI/ChatGPT Integration

```python
# Example: Use AI to analyze content
import openai
import json

def analyze_with_ai(content):
    response = openai.ChatCompletion.create(
        model="gpt-4",
        messages=[
            {"role": "system", "content": "You are a knowledge base analyzer."},
            {"role": "user", "content": f"Analyze this content and identify key entities and topics:\n{content}"}
        ]
    )
    return response.choices[0].message.content

# Save AI analysis to knowledge base
def save_analysis(content, kb_path):
    analysis = analyze_with_ai(content)
    
    with open(f"{kb_path}/wiki/ai-analysis.md", "w") as f:
        f.write(f"# AI Analysis\n\n{analysis}")
```

### Claude Integration

```python
# Example: Use Claude for knowledge extraction
import anthropic

client = anthropic.Anthropic()

def extract_knowledge(content):
    response = client.messages.create(
        model="claude-3",
        max_tokens=1000,
        messages=[
            {"role": "user", "content": f"Extract key knowledge from this content and organize into entities and topics:\n{content}"}
        ]
    )
    return response.content[0].text
```

## Advanced Features

### Batch Processing

Process multiple files at once:
```bash
# Process all PDFs in a directory
for pdf in ~/Downloads/pdfs/*.pdf; do
    bash digest.sh "$pdf" ~/.openclaw/workspace/knowledge-base/my-knowledge-base
done
```

### Scheduled Updates

Set up cron job for regular updates:
```bash
# Weekly health check
crontab -e
# Add: 0 9 * * 1 bash ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/health-check.sh ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

### Integration with Obsidian

llm-wiki generates standard markdown files that work with Obsidian:
```bash
# Open knowledge base in Obsidian
open ~/.openclaw/workspace/knowledge-base/my-knowledge-base/wiki/
```

### Custom Templates

Create custom templates for specific domains:
```bash
# Create technology template
cat > ~/.openclaw/workspace/skills/llm-wiki-installer/templates/technology.md << EOF
# Technology Entity Template

## Technology
[[technology-name.md]]

## Category
- Software
- Hardware
- Protocol
- Framework

## Status
- Active
- Deprecated
- Experimental

## Related Topics
[[topics.md]]

## Confidence
EXTRACTED
EOF
```

## Tips and Best Practices

### 1. Start Small
Begin with a single topic or project, then expand gradually.

### 2. Regular Updates
Schedule regular digestions and health checks.

### 3. Consistent Structure
Follow the standard wiki structure for consistency.

### 4. Confidence Levels
Use appropriate confidence levels:
- EXTRACTED: Directly from source
- INFERRED: Derived/inferred
- AMBIGUOUS: Ambiguous
- UNVERIFIED: Needs verification

### 5. Bidirectional Links
Use `[[entity]]` and `[[topic]]` links to create interconnected knowledge.

### 6. Version Control
Use Git to track changes:
```bash
cd ~/.openclaw/workspace/knowledge-base/my-knowledge-base
git init
git add .
git commit -m "Initial knowledge base"
```

### 7. Backup Strategy
Regular backups ensure knowledge preservation:
```bash
# Create backup
tar -czf knowledge-base-backup.tar.gz ~/.openclaw/workspace/knowledge-base/my-knowledge-base
```

## Troubleshooting

### Missing Dependencies
If scripts fail, check dependencies:
```bash
# Check Python
python3 --version

# Check Node.js
node --version

# Check Git
git --version
```

### Permission Issues
Ensure proper permissions:
```bash
chmod +x ~/.openclaw/workspace/skills/llm-wiki-installer/scripts/*.sh
```

### Encoding Issues
For Windows PowerShell users:
```powershell
chcp 65001
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$env:PYTHONIOENCODING = 'utf-8'
bash install.sh --name my-knowledge-base
```

## Next Steps

After initial setup:
1. Add more content sources
2. Review health check results
3. Customize templates for your needs
4. Integrate with AI tools for advanced analysis
5. Share knowledge base with team members