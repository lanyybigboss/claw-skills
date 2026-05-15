# 变更影响矩阵

## 变更类型 → 要改哪些文件

### 新增 / 改动 API 路由
- **项目根 CLAUDE.md / AGENTS.md**：路由速查表
- **docs/integration-guide.md** 或对应外部指南：新增请求示例、响应格式、错误码
- **docs/architecture.md**：系统内新增的交互流程、权限检查
- **docs/runbook.md**：若有相关监控 / 告警需更新
- **handoff.md** / `CHANGELOG.md`：标记为已完成

### 新增 / 改名 环境变量
- **项目根 CLAUDE.md / AGENTS.md**：环境变量表
- **docs/runbook.md**：部署环境所需值、敏感变量说明
- **下游 integration-guide**（若提供给外部项目）：SDK / API 调用所需的认证配置
- **`.env.example`**（若有）：同步默认值 / 说明

### 新增数据库表 / 修改 schema
- **项目根 CLAUDE.md / AGENTS.md**：数据模型简述
- **docs/architecture.md**：Data Model 章节，新增表结构与关联
- **migration 说明**（若有 `docs/migrations.md`）：新增迁移说明

### 新增大特性（跨多个文件 / 模块）
- 以上全部（API + 环境变量 + DB）
- **docs/architecture.md**：新增独立章节，说明模块划分与通信机制
- **README.md**：在"Features"部分简述，引导到详细文档
- **handoff.md**：完整功能清单，含上下游影响

### 项目根新增配置文件（`config/`, `.yaml`, `.json` 等）
- **项目根 CLAUDE.md / AGENTS.md**：配置路径与用途速查
- **docs/runbook.md**：部署时如何覆盖 / 定制
- **integration-guide**（外部项目需要时）：如何通过配置调整行为

### 新增 npm / pip / go module 依赖
- **项目根 CLAUDE.md / AGENTS.md**：关键技术栈 + 约束（如"React 仅用于 admin"）
- **package.json** / `requirements.txt` / `go.mod` 本身由代码管理
- **docs/runbook.md**：部署时 `npm ci` / `pip install` / `go mod download` 注意事项

### 跨项目改动（A 项目影响 B 项目）
- **A 项目的 docs/integration-guide.md**：新增 / 更新的接口说明
- **B 项目的 docs/`<external>-integration.md`** 或相应对接文档：同步 A 的变更
- **B 项目的 CLAUDE.md / AGENTS.md**：更新依赖版本 / 接口引用
- **双方 handoff.md**：标记依赖关系已完成同步

### 新增命令行工具 / 脚本
- **项目根 CLAUDE.md / AGENTS.md**：命令速查表（参数、示例）
- **docs/runbook.md**：运维用法的完整示例
- **docs/developer-guide.md**（若有）：开发时如何运行 / 调试

### 新增监控 / 告警规则
- **docs/runbook.md**：告警触发条件与处理步骤
- **项目根 CLAUDE.md / AGENTS.md**：关键监控指标速查
- **监控配置本身**（Prometheus rules, Datadog monitors）由代码管理

### 新增外部集成（第三方服务、SaaS）
- **docs/integration-guide.md**：完整接入步骤、认证、配额
- **项目根 CLAUDE.md / AGENTS.md**：集成速查（服务名、用途、环境变量前缀）
- **docs/architecture.md**：系统上下文图更新

### 权限模型变更（新增角色、改 ACL）
- **项目根 CLAUDE.md / AGENTS.md**：权限矩阵表
- **docs/architecture.md**：授权流程图
- **integration-guide**（外部调用时）：所需权限说明

### 弃用功能（标记 deprecated）
- **项目根 CLAUDE.md / AGENTS.md**：弃用列表，替代方案
- **docs/integration-guide.md**：旧接口保留但标记弃用，引导用新接口
- **handoff.md**：记录弃用决定与时间线

## 记忆层面的变更映射

### 相对时间 → 绝对日期
- **所有记忆文件**：`今天` → `2026-04-29`，`最近` → `2026-04 至今`

### 过期事实 → 更新
- 代码已删但记忆仍提到 → **删记忆条目**
- 配置路径变更 → **更新记忆的路径引用**
- 工具版本升级 → **更新记忆中的版本号**

### 重复条目 → 合并
- 同一事实出现在多个记忆文件 → **合并到最合适的一个，删其余**
- 同一记忆文件内相似段落 → **合并，保留完整版本**

### 已完成待办 → 删除
- 记忆中的 `TODO`、`待办` 已实现 → **删该条目**（成果已进代码 / docs，不需要记忆提醒）
- 临时备忘（如"明天问问 Alice"）已过期 → **删**

### 单次事故复盘 → 评估保留价值
- 有通用教训（"永远不要 X"）→ **提炼成规则，进 CLAUDE.md**
- 仅当时有效（"服务器 Y 那台机挂了"）→ **删**
- 详细排查步骤有复用价值 → **迁到 docs/runbook.md 故障排查章节，记忆删**

### 代码可读性代替详细机制
- 记忆里详细解释某函数如何工作 → **若代码本身可读，删记忆，CLAUDE.md 加"见 `src/...`"指针**
- 绕行逻辑（workaround）已进代码注释 → **记忆可删**

## 特殊情况的处理

### 发现之前的同步漏了东西
- **立即补**，不区分"本次对话"与"历史遗留"
- 在变更摘要的「记忆变更」或「文档变更」里如实写

### 多项目会话，只改了其中一个
- **只同步改了的那一个**，但检查它是否影响其他项目
- 若影响（如 API 协议变更），**必须同步下游项目**，即使本次对话没提

### 用户明确"不要动记忆"
- 跳过记忆层，但 **docs 和项目根 markdown 仍要同步**
- 在变更摘要里说明「记忆未动（用户指定）」

### 项目处于早期探索阶段（无稳定代码）
- **跳过同步**，但在摘要里提醒「项目尚在探索期，建议有可运行代码后再做知识同步」

### 文件已存在但内容为空
- **视为需要创建**，按上述矩阵填充

### 找不到对应文档位置
- 先按矩阵创建目录与文件结构
- 在 handoff.md 里记录「新增了 X 文档」

---

**最后一步**：改完后用这个矩阵再过一遍，确认每种变更类型都覆盖到了对应的文档层。