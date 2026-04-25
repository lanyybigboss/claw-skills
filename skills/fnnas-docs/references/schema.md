# FenNAS (飞牛NAS) Documentation Schema

## Project Overview

FenNAS (飞牛NAS) is a NAS (Network Attached Storage) solution developed by Iron Blade Technology (铁刃科技). This skill aims to crawl and extract documentation from their GitHub repositories.

## Documentation Structure (Expected)

Based on typical NAS documentation patterns:

### 1. Installation Documentation
- Hardware requirements
- Software installation steps
- Initial setup and configuration
- Network configuration
- Storage initialization

### 2. Administration Guide
- User management
- Storage management
- Network services
- Security configuration
- Backup setup
- Monitoring and alerts

### 3. API Documentation
- REST API endpoints
- Authentication methods
- Request/response formats
- Error codes
- Example usage

### 4. CLI Documentation
- Command-line interface commands
- Scripting examples
- Automation guides
- Troubleshooting commands

### 5. Advanced Features
- Virtualization support
- Container deployment
- Plugin system
- Third-party integrations
- Performance tuning

## Search Strategy

Since FenNAS GitHub repository needs to be identified, we will use multiple approaches:

### 1. GitHub Search Methods
- Search for "fennas"
- Search for "iron-blade"
- Search for "iron blade technology"
- Search for "飞牛NAS"
- Search for Chinese NAS repositories

### 2. Documentation Sources
- GitHub README files
- GitHub Wiki pages
- GitHub Issues (troubleshooting)
- GitHub Discussions
- Official website (ironbladetech.com)

### 3. Chinese Tech Platforms
- Chinese tech forums
- Chinese NAS community sites
- Iron Blade Technology official site

## Caching Strategy

### Cache Location
`~/.openclaw/workspace/skills/fnnas-docs/cache/`

### Cache Files
- `fnnas-repo-info.json` - Repository information
- `fnnas-docs.txt` - Documentation extract
- `github-search-results.json` - GitHub search results
- `api-docs.json` - API documentation (if found)

### Cache Expiry
- Repository info: 7 days
- Documentation: 30 days
- Search results: 1 day

## Usage Examples

### Search Documentation
```bash
# Search for installation guides
fnnas-docs search "install"

# Search for configuration guides
fnnas-docs search "config"

# Search for API documentation
fnnas-docs search "api"

# Search for storage management
fnnas-docs search "storage"
```

### Get Repository Info
```bash
# Get repository information
fnnas-docs info
```

### Download Documentation
```bash
# Download documentation (when repo is identified)
fnnas-docs download
```

## Integration Pattern

This skill should be used when:
1. User asks about FenNAS setup or configuration
2. User needs NAS operation guidance
3. User needs Iron Blade Technology product documentation
4. User asks about network storage solutions

## Expected Repository Features

Based on NAS product patterns:

### 1. Repository Structure
```
/ (root)
├── README.md          # Main documentation
├── docs/             # Documentation directory
├── api/              # API specifications
├── examples/         # Usage examples
├── scripts/          # Installation scripts
└── wiki/            # GitHub wiki (if enabled)
```

### 2. Documentation Files
```
docs/
├── installation.md
├── administration.md
├── api.md
├── cli.md
├── troubleshooting.md
├── advanced.md
└── faq.md
```

### 3. API Structure
```
api/
├── authentication.md
├── system.md
├── storage.md
├── network.md
├── users.md
└── examples/
```

## Fallback Documentation

Until FenNAS repository is identified, we provide:

### 1. General NAS Documentation
- Installation basics
- Storage management fundamentals
- Network service setup
- Security best practices
- Backup strategies

### 2. Iron Blade Technology Profile
- Company information
- Product portfolio
- Support channels
- Community resources

### 3. Common NAS APIs
- REST API patterns
- Authentication methods
- Error handling
- Performance monitoring