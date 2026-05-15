# Agent 路径速查

## Claude Code

### 项目级记忆
```
~/.claude/projects/<project-fingerprint>/memory/
```
- `MEMORY.md` — 记忆索引（引用其他 .md）
- `YYYY-MM-DD.md` — 每日记忆文件
- 其他 `.md` 文件 — 专项记忆（如 `api-design-choices.md`）

### 项目级 CLAUDE.md
位于项目根目录：
```
<project-root>/CLAUDE.md
```

### 全局 CLAUDE.md（跨项目规则）
```
~/.claude/CLAUDE.md
```

## OpenAI Codex

### 项目级 AGENTS.md
位于项目根目录：
```
<project-root>/AGENTS.md
```

### 全局 AGENTS.md（跨项目规则）
```
~/.codex/AGENTS.md
```

### 记忆系统
Codex 通常使用 `AGENTS.md` 内的 `## Memory` 章节或相邻的 `memory/` 目录，但无统一路径。实践中：
- 检查项目根 `memory/` 目录
- 检查 `AGENTS.md` 内的记忆段落

## OpenCode

### 项目级配置
```
<project-root>/.opencode/config.json
<project-root>/.opencode/memory/（若存在）
```

### 全局配置
```
~/.opencode/config.json
```

## OpenClaw

### 项目级 AGENTS.md
位于项目根目录：
```
<project-root>/AGENTS.md
```

### 全局配置
```
~/.openclaw/CLAUDE.md（历史遗留名，实际同 AGENTS.md）
~/.openclaw/workspace/AGENTS.md
```

### 记忆系统
```
~/.openclaw/workspace/memory/
```
- `MEMORY.md` — 长期记忆索引
- `YYYY-MM-DD.md` — 每日记忆
- 其他 `.md` — 专项记忆

## Cursor / Windsurf / Cline

### 项目级配置
通常为项目根目录下的：
```
.cursor/rules/（Cursor）
.windsurf/（Windsurf）
.cline/（Cline）
```

### 记忆
通常使用项目根 `memory/` 或嵌入在配置文件的记忆章节。

## 通用检查步骤

当不确定当前 Agent 的记忆路径时：

1. **检查项目根**：
   ```bash
   ls -la | grep -E "(CLAUDE|AGENTS|\.opencode|\.cursor|\.windsurf|memory)"
   ```

2. **检查全局配置目录**：
   ```bash
   ls ~/.claude/ 2>/dev/null || true
   ls ~/.codex/ 2>/dev/null || true
   ls ~/.opencode/ 2>/dev/null || true
   ls ~/.openclaw/ 2>/dev/null || true
   ```

3. **通过环境变量推断**：
   ```bash
   echo $AGENT_TYPE  # 可能为 CLAUDE_CODE, CODEX, OPENCLAW 等
   ```

4. **询问用户**（最后手段）：
   "你用的是什么 Agent（Claude Code / Codex / OpenClaw / 其他）？"

## 记忆文件格式

### Claude Code 记忆索引示例（MEMORY.md）
```markdown
# Memory

## 项目事实
- 使用 SQLite 本地开发，生产用 PostgreSQL
- 前端用 React + Vite，后端用 Express

## 设计决策
- [api-design-choices.md](api-design-choices.md) — 2026-04-10 的 API 版本设计

## 待办
- [ ] 迁移到 pnpm（2026-04-29）
```

### OpenClaw 记忆索引示例（MEMORY.md）
```markdown
# 长期记忆

## 个人偏好
- 喜欢用 `const` 而非 `let` 除非必须重赋值
- 函数不超过 30 行

## 项目事实
- 本项目使用 TypeScript 严格模式
- 部署在 Fly.io，应用名 `myapp-prod`

## 事件
- 2026-04-28：修复了数据库连接池泄漏问题
```

## 注意事项

1. **不要假设路径**：不同版本、不同安装方式可能导致路径差异
2. **优先读现有文件**：如果发现记忆文件，先读它的结构，再决定如何编辑
3. **找不到时不创建**：如果当前 Agent 明显没有独立记忆系统（如某些 CLI-only 工具），跳过记忆层，专注 docs
4. **平台标识**：用户常说"Codex"可能指 OpenAI Codex 或 Claude Code，通过路径判断