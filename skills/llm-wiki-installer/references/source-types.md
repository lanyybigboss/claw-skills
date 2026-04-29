# llm-wiki Source Types

llm-wiki supports various source types with different processing methods.

## Core Source Types

These sources can be processed directly without external dependencies:

### 1. Text Content
**Format**: Plain text, markdown
**Processing**: Direct ingestion
**Example**: `bash digest.sh "This is some text" ~/knowledge-base`

### 2. Local Files
**Supported Formats**:
- PDF files (`*.pdf`)
- Markdown files (`*.md`)
- Text files (`*.txt`)
- HTML files (`*.html`)

**Processing**: Content extraction
**Example**: `bash digest.sh "~/documents/article.pdf" ~/knowledge-base`

### 3. Paste Content
**Format**: Any text copied and pasted
**Processing**: Direct ingestion
**Example**: Paste article text into the script

## Optional Source Types (Extractors Required)

These sources require optional extractors:

### 1. Web Articles
**Extractor**: `baoyu-url-to-markdown`
**Requirements**: `node` or `bun`
**Example**: `bash digest.sh "https://example.com/article" ~/knowledge-base`

### 2. X/Twitter
**Extractor**: `baoyu-url-to-markdown`
**Requirements**: `node` or `bun`
**Note**: May require Chrome debugging port 9222 for login-based content
**Example**: `bash digest.sh "https://twitter.com/user/status/1234567890" ~/knowledge-base`

### 3. YouTube
**Extractor**: `youtube-transcript`
**Requirements**: `node` or `python`
**Processing**: Extracts subtitles/transcripts
**Example**: `bash digest.sh "https://youtube.com/watch?v=video_id" ~/knowledge-base`

### 4. Zhihu (知乎)
**Extractor**: `baoyu-url-to-markdown`
**Requirements**: `node` or `bun`
**Processing**: Extracts Zhihu article content
**Example**: `bash digest.sh "https://zhihu.com/question/123456789" ~/knowledge-base`

### 5. WeChat Articles (微信公众号)
**Extractor**: `wechat-article-to-markdown`
**Requirements**: `uv`
**Processing**: Extracts WeChat article content
**Example**: `bash digest.sh "https://mp.weixin.qq.com/article_url" ~/knowledge-base`

## Manual Processing Sources

### 1. Xiaohongshu (小红书)
**Processing**: Manual paste only
**Current Status**: No automatic extractor available
**Workflow**: Copy content manually, then use text ingestion

### 2. Sensitive Content
**Processing**: Manual verification and sanitization
**Workflow**: Check for sensitive information before processing

## Source Processing Flow

```bash
# Step 1: Source identification
bash source-registry.sh identify <source-url>

# Step 2: Extractor availability check
bash adapter-state.sh check <source-id>

# Step 3: Content extraction
bash extract.sh <source-url> <source-id>

# Step 4: Knowledge extraction
bash knowledge-extract.sh <extracted-content>

# Step 5: Wiki page generation
bash generate-wiki.sh <knowledge-data>
```

## Installation of Optional Extractors

```bash
# Install all optional extractors
bash install.sh --platform openclaw --with-optional-adapters

# Individual extractor installation (if needed)
npm install baoyu-url-to-markdown
pip install youtube-transcript
uv install wechat-article-to-markdown
```

## Troubleshooting Extraction

### Common Issues

**1. Web Article Extraction Failures**
- Check if website blocks scraping
- Try alternative extraction methods
- Use manual paste if necessary

**2. YouTube Transcript Extraction**
- Ensure video has captions
- Check YouTube API availability
- Use manual transcript if available

**3. WeChat Article Extraction**
- Ensure article is publicly accessible
- Check WeChat API status
- Use manual copy if extraction fails

**4. Zhihu Content Extraction**
- Zhihu may have strict anti-scraping measures
- Consider using official API if available
- Manual paste as fallback

### Fallback Strategies

```bash
# If extraction fails, use manual process
# 1. Copy content manually
# 2. Save to text file
# 3. Process text file

echo "Copied content from website" > content.txt
bash digest.sh content.txt ~/knowledge-base
```

## Source Quality Guidelines

### High-Quality Sources
1. **Academic papers** - PDF format with clear structure
2. **Technical documentation** - Official documentation sites
3. **Blog articles** - Professional blogs with structured content
4. **News articles** - Reputable news sources

### Medium-Quality Sources
1. **Social media posts** - Structured posts with valuable content
2. **Forum discussions** - Technical forums with expert opinions
3. **YouTube videos** - Educational content with transcripts

### Low-Quality Sources
1. **Random web pages** - Unstructured, poorly formatted
2. **Advertisement pages** - Content mixed with ads
3. **Anonymous sources** - No authorship or verification

## Content Classification

### Confidence Levels
- **EXTRACTED**: Directly from source (highest confidence)
- **INFERRED**: Derived or interpreted (medium confidence)
- **AMBIGUOUS**: Uncertain or contradictory (low confidence)
- **UNVERIFIED**: Requires verification (no confidence)

### Content Categories
1. **Technical**: Programming, engineering, science
2. **Business**: Economics, finance, marketing
3. **Creative**: Arts, design, writing
4. **Personal**: Journals, diaries, reflections
5. **Educational**: Tutorials, guides, courses

## Maintenance Guidelines

### Regular Audits
1. Monthly health checks
2. Quarterly source quality reviews
3. Annual confidence re-evaluation

### Source Updates
1. Update outdated sources
2. Remove deprecated content
3. Add new relevant sources

### Cross-Reference Management
1. Ensure bidirectional links are maintained
2. Update references when content changes
3. Remove broken links promptly