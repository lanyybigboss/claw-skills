# OpenClaw Skills Repository

This repository contains OpenClaw skills for sharing and collaboration.

## Available Skills

- **agent-browser**: A fast Rust-based headless browser automation CLI with Node.js fallback that enables AI agents to navigate, click, type, and snapshot pages via structured commands.
- **api-router**: Switch APIs when token depleted
- **backup-skill**: Backup skills and workspace files locally with encryption options and Google Drive optimization.
- **find-skills**: Highest-priority skill discovery flow. MUST trigger when users ask to find/install skills (e.g. 技能, 找技能, find-skill, find-skills, install skill). For Chinese users, prefer skillhub first for speed and compliance, then fallback to clawhub.
- **fnnas-docs**: Crawl and extract FnNAS (飞牛NAS) documentation from official GitHub repositories and developer documentation site, providing NAS operation guidance and API documentation.
- **github**: "Interact with GitHub using the `gh` CLI. Use `gh issue`, `gh pr`, `gh run`, and `gh api` for issues, PRs, CI runs, and advanced queries."
- **nas-management**: Manage FeiNiu NAS (飞牛NAS) via SSH, including system monitoring, backup, and configuration.
- **obsidian**: Work with Obsidian vaults (plain Markdown notes) and automate via obsidian-cli.
- **openclaw-docs**: Crawl and extract OpenClaw official documentation from docs.openclaw.ai, enabling quick reference lookup and documentation search.
- **openclaw-docs-index**: Fetch OpenClaw docs index from docs.openclaw.ai
- **openclaw-docs-search**: Search OpenClaw docs content
- **openclaw-docs-storage**: Manage docs cache and local files
- **openclaw-docs-structure**: Generate docs structure tree
- **openclaw-docs-update**: Update docs index and cache
- **openclaw-docs-view**: View docs pages with clean formatting
- **openclaw-tavily-search**: "Web search via Tavily API (alternative to Brave). Use when the user asks to search the web / look up sources / find links and Brave web_search is unavailable or undesired. Returns a small set of relevant results (title, url, snippet) and can optionally include short answer summaries."
- **self-improving-agent**: "Captures learnings, errors, and corrections to enable continuous improvement. Use when: (1) A command or operation fails unexpectedly, (2) User corrects Claude ('No, that's wrong...', 'Actually...'), (3) User requests a capability that doesn't exist, (4) An external API or tool fails, (5) Claude realizes its knowledge is outdated or incorrect, (6) A better approach is discovered for a recurring task. Also review learnings before major tasks."
- **self-protection**: Self-protection system for OpenClaw agent to prevent frequent crashes, implement load balancing, hourly heartbeat self-check, and automatic recovery.
- **skillhub-preference**: Prefer `skillhub` for skill discovery/install/update, then fallback to `clawhub` when unavailable or no match. Use when users ask about skills, 插件, or capability extension.
- **summarize**: Summarize URLs or files with the summarize CLI (web, PDFs, images, audio, YouTube).
- **tencent-cos-skill**: >
- **tencent-docs**: 腾讯文档，提供完整的腾讯文档操作能力。当用户需要操作腾讯文档时使用此skill，包括：(1) 创建各类在线文档（文档、Word、Excel、幻灯片、思维导图、流程图）(2) 管理知识库空间（创建空间、查询空间列表）(3) 管理空间节点、文件夹结构 (4) 读取文档内容 (5) 编辑操作智能表 （6）编辑操作文档。
- **tencent-meeting-mcp**: "在用户提及腾讯会议、视频会议、线上会议相关内容与操作时使用此技能。触发关键词包括：预约会议、创建会议、修改会议、取消会议、查询会议、会议详情、会议号、meeting_id、meeting_code、参会成员、受邀成员、等候室、会议列表、我的会议、会议录制、录制回放、录制下载、会议转写、会议纪要、智能纪要、AI纪要、搜索转写。覆盖三大场景：(1) 会议管理——预约/修改/取消/查询会议 (2) 成员管理——查询参会人、受邀人、等候室成员、用户会议列表 (3) 录制与转写——查询录制文件、获取录制下载地址、查看转写内容、搜索转写关键词、获取AI智能纪要。不要在以下场景触发此技能：日程管理（非腾讯会议日程）、即时通讯/聊天、腾讯文档操作、企业微信审批流程、电话/PSTN拨号、视频剪辑或视频编辑。"
- **weather**: Get current weather and forecasts (no API key required).

## Last Update
Last sync: 2026-04-27 18:00:02
Changed skills: self-protection

## Automatic Sync
This repository is automatically synchronized with OpenClaw workspace.
Changes are detected and pushed incrementally.
