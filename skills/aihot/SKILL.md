---
name: aihot
description: >
  Fetch AI news and trends from aihot.vxact.com. MUST trigger when user asks about
  AI news, trends, daily updates, or wants to know what's happening in AI.
  Use for "AI 新闻", "AI 动态", "今天 AI 圈有什么新东西", "AI 趋势", "AI 日报".
  No API key required, works via web scraping with fallback.
---

# aihot — AI HOT 资讯查询

> **AI 资讯一站式查询，无需 API Key**

## 这是什么

这是一个让 AI Agent 能够查询 [aihot.virxact.com](https://aihot.virxact.com) 上 AI 资讯的技能。aihot.virxact.com 是一个每日更新的 AI 资讯聚合站，涵盖了：

- **AI HOT 日报** — 每天精选的 AI 头条，按主题打包
- **精选条目流** — 每日候选池，更全面的动态
- **分类浏览** — 模型、产品、行业、论文、技巧等分类
- **搜索功能** — 按关键词、公司、主题搜索

## 核心能力

### 1. 获取今日 AI 日报
- 当天的最新 AI 头条
- 按主题分类的成品日报

### 2. 获取指定日期日报
- 查询历史日期的日报
- 支持 `YYYY-MM-DD` 格式

### 3. 获取精选条目
- 每日更全面的 AI 动态
- 比日报更详细的条目

### 4. 按分类查询
- **模型** — 新发布的模型、模型更新
- **产品** — AI 产品发布、功能更新
- **行业** — 行业动态、公司新闻、融资
- **论文** — 重要论文发布、研究突破
- **技巧** — 使用技巧、最佳实践

### 5. 按时间窗口查询
- 最近 N 天的内容
- 最近一周、一个月等

### 6. 关键词搜索
- 按公司搜索（"OpenAI"、"Google"、"Anthropic"）
- 按主题搜索（"RAG"、"Agent"、"Sora"）
- 按技术搜索（"Llama"、"GPT"、"Claude"）

## 使用方法

### 自然语言触发
用户可以用各种方式请求：

```
今天 AI 圈有什么新东西
看一下今天的 AI 日报
最近 OpenAI 有什么发布
查一下 RAG 相关的论文
最近一周的 AI 动态
5月6号的 AI 日报
看下精选条目
AI 模型有什么更新
```

### 结构化查询（程序化使用）
也可以使用结构化参数：

```bash
# 今日日报
aihot daily today

# 指定日期日报
aihot daily 2026-05-06

# 精选条目
aihot curated

# 按分类
aihot category models
aihot category products
aihot category industry
aihot category papers
aihot category tips

# 时间窗口
aihot window 7  # 最近7天
aihot window 30 # 最近30天

# 关键词搜索
aihot search "OpenAI"
aihot search "RAG"
aihot search "向量数据库"
```

## 数据源说明

### 主数据源：aihot.virxact.com
- **更新频率**：每日更新
- **覆盖范围**：全球 AI 动态，侧重中文可访问内容
- **内容质量**：人工筛选 + 算法推荐
- **访问方式**：公开网页，无需登录

### 备用数据源（主源不可用时）
- GitHub 仓库的缓存数据
- RSS 订阅源
- 其他 AI 资讯站点的聚合

## 实现方式

### 1. 网页抓取（主要方式）
```python
# 示例抓取逻辑
def fetch_daily(date):
    url = f"https://aihot.virxact.com/daily/{date}"
    # 抓取并解析 HTML
    # 提取标题、摘要、链接、分类
```

### 2. 缓存机制
- 本地缓存最近 7 天的数据
- 避免频繁请求，减轻服务器压力
- 离线时仍可访问缓存内容

### 3. 降级策略
- 主站不可用时，使用备用源
- 备用源不可用时，返回最近缓存
- 完全不可用时，返回友好错误提示

## 输出格式

### 文本输出（默认）
```
## 2026-05-16 AI 日报

### 🔥 头条
- **标题**：OpenAI 发布 GPT-4.5，推理能力大幅提升
  **摘要**：今天凌晨，OpenAI 悄然更新了 GPT-4.5，在逻辑推理和数学能力上...
  **链接**：https://openai.com/blog/gpt-4-5
  **分类**：模型

- **标题**：Google DeepMind 发布 AlphaFold 3
  **摘要**：AlphaFold 3 在蛋白质结构预测的基础上，新增了配体和核酸...
  **链接**：https://deepmind.google/alphafold3
  **分类**：论文

### 📦 产品更新
- **标题**：Notion AI 新增工作流自动化
  **摘要**：Notion 的 AI 功能现在可以创建自动化工作流，根据条件自动...
  **链接**：https://notion.so/blog/ai-workflows
  **分类**：产品

### 💼 行业动态
- **标题**：Anthropic 获得 30 亿美元融资
  **摘要**：Anthropic 在最新一轮融资中获得了 30 亿美元，估值达到...
  **链接**：https://anthropic.com/news/series-e
  **分类**：行业
```

### JSON 输出（机器可读）
```json
{
  "date": "2026-05-16",
  "type": "daily",
  "items": [
    {
      "title": "OpenAI 发布 GPT-4.5",
      "summary": "今天凌晨，OpenAI 悄然更新了 GPT-4.5...",
      "url": "https://openai.com/blog/gpt-4-5",
      "category": "models",
      "time": "2026-05-16T00:00:00Z"
    }
  ]
}
```

### Markdown 输出（适合保存）
```markdown
# AI HOT 日报 2026-05-16

## 头条
- [OpenAI 发布 GPT-4.5](https://openai.com/blog/gpt-4-5) - 推理能力大幅提升

## 产品更新
- [Notion AI 新增工作流自动化](https://notion.so/blog/ai-workflows) - 自动化工作流功能
```

## 使用场景

### 场景 1：每日晨报
用户早上想了解昨晚到今天凌晨的 AI 动态：
```
"今天 AI 圈有什么新东西？"
```
→ 返回当日 AI 日报摘要

### 场景 2：竞品跟踪
用户想了解特定公司的动态：
```
"最近 OpenAI 有什么发布？"
```
→ 返回最近 OpenAI 相关的条目

### 场景 3：技术调研
用户想了解某个技术方向的最新进展：
```
"RAG 最近有什么新论文？"
```
→ 返回 RAG 相关的论文和产品

### 场景 4：内容创作
用户需要 AI 资讯作为写作素材：
```
"最近一周的 AI 大事，要写篇文章"
```
→ 返回最近一周的重要动态，附带详细摘要

### 场景 5：学习跟进
用户想持续学习 AI 知识：
```
"每天给我 AI 日报摘要"
```
→ 可以设置定时任务，每日推送

## 注意事项

### 1. 时间处理
- 日期格式统一为 `YYYY-MM-DD`
- 时间使用 UTC+8（北京时间）
- 相对时间自动转换（"今天" → 当前日期）

### 2. 内容过滤
- 过滤低质量或重复内容
- 优先显示原创、首发内容
- 标注内容来源和可信度

### 3. 频率限制
- 避免过于频繁的请求
- 使用缓存减少服务器压力
- 高峰时段可能降级响应

### 4. 错误处理
- 网络错误时自动重试
- 返回友好的错误提示
- 提供降级内容或建议

## 平台兼容性

### 支持平台
- **Claude Code** — 通过 skill 调用
- **Codex** — 通过 skill 调用
- **OpenCode** — 通过 skill 调用
- **OpenClaw** — 通过 skill 调用
- **Cursor** — 通过插件或 skill
- **Windsurf** — 通过插件或 skill

### 安装方式
**OpenClaw 安装**：
```bash
# 安装到 skills 目录
cd ~/.openclaw/workspace/skills
git clone https://github.com/KKKKhazix/khazix-skills/tree/main/aihot
```

**国内直连安装**（无需翻墙）：
```bash
curl -fsSL https://aihot.virxact.com/aihot-skill/install.sh | bash
```

## 开发与扩展

### 添加新数据源
1. 在 `sources/` 目录添加新的抓取器
2. 实现统一的接口
3. 添加到数据源注册表

### 自定义输出格式
1. 在 `formatters/` 目录添加新格式
2. 支持文本、JSON、Markdown、HTML 等
3. 按需选择输出格式

### 本地缓存管理
```bash
# 查看缓存
aihot cache list

# 清除缓存
aihot cache clear

# 预取缓存
aihot cache prefetch 7
```

## 常见问题

### Q：需要 API Key 吗？
**A**：不需要。完全免费，通过公开网页抓取。

### Q：数据延迟多久？
**A**：每日更新，通常在北京时间上午 9 点前更新当日内容。

### Q：支持搜索历史内容吗？
**A**：支持。可以搜索过去 365 天的内容。

### Q：能获取到英文内容吗？
**A**：可以。aihot 包含中英文内容，会根据用户语言偏好优先显示。

### Q：有没有使用限制？
**A**：建议个人合理使用，避免自动化高频请求。

### Q：数据准确吗？
**A**：数据来自多个可信来源，经过筛选，但建议重要决策前核对原始链接。

## 技能触发词

### 中文触发词
- AI 新闻、AI 动态、AI 资讯
- AI 日报、AI 晨报、AI 晚报
- 今天 AI 圈有什么、最近 AI 有什么新东西
- AI 模型更新、AI 产品发布
- 搜索 AI、查询 AI 新闻

### 英文触发词
- AI news、AI updates、AI trends
- AI daily、AI newsletter
- what's new in AI、latest AI news
- AI models、AI products
- search AI news

---

**使用建议**：这个技能最适合用于快速获取 AI 资讯概览。对于深度分析，建议结合 `hv-analysis` 技能进行系统性研究。