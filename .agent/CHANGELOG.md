# 规范文档变更日志

## v6.12.0 - 2026-06-22

### 📤 新增「输出契约」节

**`.agent/instructions.md` 在「通用工作原则」后新增「📤 输出契约」节**：
- 用金字塔原理 + 结构化思维约束正文：结论先行、以上统下归类分组（MECE）、默认三段式（结论/依据/下一步）、推理不进正文、禁止反模式、长度自律
- 解决下游输出「大篇幅无用信息、无结论、无下一步」的痛点
- 「通用工作原则」第 2 条改为指向输出契约，纠正「推理彻底 = 打印推理过程」的误读

### 🤖 重写「Subagent 原则」

- 新增前置说明：是否起 subagent 由任务性质决定，不是每个任务都要起
- 四条原则重述为单一职责 / 主动卸载 / 主上下文精简 / 依赖串行
- 文件头版本号由 6.0.0 对齐至 6.12.0

### 🗑️ 彻底废弃 custom.md 自定义规范层（破坏性）

- 规范层级表删除「项目自定义 custom.md」行，`.agent/user.md` 升为**最高优先级**，兼任「项目坐标 + 项目自定义规范」
- 自定义规范统一走 `/project-rules` / `$project-rules` 写入 `.agent/user.md`
- 原因：custom.md 与 user.md 职责重叠，且三处定义互相矛盾（详见根 CHANGELOG v6.12.0）

## v6.3.0 - 2026-04-18

### 🧭 项目坐标指针节（对齐 HumanLayer《Writing a good CLAUDE.md》）

**`.agent/instructions.md` 末尾新增"🧭 项目坐标"节**：
- 一行指针指向 `.agent/user.md`（而非将技术栈/目的/工作流内联进 instructions.md）
- 符合博客"pointer 不是 copy"原则，避免 CLAUDE.md 塞入非通用项目信息

**规范层级表新增"项目坐标"一行**：
- `<project>/.agent/user.md` — 优先级"中"，放在 instructions.md 和 custom.md 之间

**下游项目收到的新文件**：
- `.agent/user.md`（WHAT/WHY/HOW 占位，由 `ai-rules init` 分发；`ai-rules init-context` 生成实际内容；`ai-rules update` 不覆盖）

---

## v4.5.0 - 2026-02-10

### 🧠 MCP 优先检索策略 + 代码库语义索引文档

**新增铁律**：
- `instructions.md` 新增"7️⃣ MCP 优先检索"（第 7 条 AI 行为铁律）
  - `[CONDITIONAL CONSTRAINT]`：仅当项目配置了 MCP 索引工具时生效
  - 检索优先级：MCP 语义搜索 → Grep/Glob/Read（兜底）
  - 覆盖所有 AI 工具（Claude/Cursor/Windsurf/Gemini）

**新增规则文件**：
- `.claude/rules/mcp-retrieval.md` — Claude Code 专用详细规则
  - 含场景对照表（何时用 MCP、何时允许 Grep）
  - 明确禁止行为（跳过 MCP 全局扫描、逐个 Read 理解功能）
  - `ai-rules init/update` 通过 `copy_claude_tools()` 自动分发

**新增文档**：
- `README.md` 新增"代码库语义索引（降低 Token 消耗）"章节
  - qmd 工具安装和配置说明
  - Claude Code MCP 配置模板

**文件变更**：
- `.agent/instructions.md` — 修改（+15 行，新增第 7 条铁律，版本 → v4.7）
- `.claude/rules/mcp-retrieval.md` — 新建（50 行）
- `README.md` — 修改（+190 行，新增语义索引章节，版本徽章 → 4.5.0）
- `VERSION` — 修改（4.4.0 → 4.5.0）

**设计理念**：
- MCP 工具"装了不用"的根因是缺少行为指令，而非技术问题
- 双层覆盖：instructions.md（全 AI 工具）+ .claude/rules/（Claude Code 强执行）
- 条件式约束避免无 MCP 项目受影响

---

## v4.4.0 - 2026-02-10

### 🔄 命令系统重构：/save 增强 + /restore 新增 + /checkpoint 废弃

**增强命令**：
- `/save` — 升级为"代码提交 + 上下文快照"一键存档
  - 新增步骤 2：`git add -A` + `git commit` 自动提交所有代码变更
  - 无变更时自动跳过提交，仅保存上下文快照
  - commit 信息格式：`save(<feature>): <task-title>`
  - 存档报告新增 commit SHA 显示
  - 自检清单新增 git commit 检查项

**新增命令**：
- `/restore` — 丢弃未提交修改，回到上次存档点
  - 检查 `git status` 确认有未提交变更
  - 展示即将丢弃的修改清单（`git diff --stat`）
  - 执行 `git checkout .` + `git reset HEAD .` + `git clean -fd`
  - 验证工作区干净后输出还原报告
  - 含自检清单保障执行完整性

**废弃命令**：
- `/checkpoint` — 已删除，功能被 `/save` + `/restore` 完全覆盖
  - `/save` 替代 checkpoint create（代码提交 = 自动创建还原点）
  - `/restore` 替代 checkpoint restore（丢弃修改 = 回到上次提交）

**文件变更**：
- `.claude/commands/save.md` — 修改（+30 行，新增 git commit 步骤）
- `.claude/commands/restore.md` — 新建（96 行）
- `.claude/commands/checkpoint.md` — 删除（-75 行）

**设计理念**：
- `/checkpoint` 本质是 `git tag` 的弱化封装，实际价值有限
- `/save` = git commit + context snapshot，一步完成"存档"
- `/restore` = git checkout，一步完成"读档（放弃当前）"
- 命令语义更直观：save/restore/load 对应 存档/还原/读档

---

## v4.3.0 - 2026-02-10

### 💾 存读档系统 + Hook 验证体系

**新增命令**：
- `/save` — 保存开发进度快照到 `context.md`，支持 `/save <备注>` 附带备注
- `/load` — 跨会话恢复进度，强制读取 `progress.json` + `context.md` + `tasks.md`

**强化命令**：
- `/accept` — 新增标记文件机制（`/tmp/claude-accept-pending`）、自检清单、清理标记步骤
  - 关键步骤增加 `[MUST]` / `[BLOCKING]` 约束词

**新增 Hooks**：
- `validate-accept.js`（Stop Hook）— 验证 `/accept` 执行后文件是否被真正更新
  - 检查 `progress.json` 的 `updatedAt` 和 `context.md` 修改时间
  - 未通过验证时 exit 2 阻止 AI 停止
  - 含 `stop_hook_active` 防循环 + 120 秒超时保护
- `validate-tasks-format.js`（PostToolUse Hook）— 写入 `tasks.md` 后验证 5 要素格式
  - 检查每个 Task 是否包含：目标、具体步骤、涉及文件、验收标准
  - matcher 限定 `specs/*/tasks.md`，不影响其他文件

**安全修复**：
- `check-console-log.js` — 新增 `stop_hook_active` 检查，防止 Stop Hook 无限循环

**文件变更**：
- `.claude/commands/save.md` — 新建（117 行）
- `.claude/commands/load.md` — 新建（102 行）
- `.claude/commands/accept.md` — 修改（+36 行）
- `.claude/hooks/validate-accept.js` — 新建（132 行）
- `.claude/hooks/validate-tasks-format.js` — 新建（103 行）
- `.claude/hooks/check-console-log.js` — 修改（+22 行）
- `.claude/settings.json` — 新增 2 个 Hook 注册（+20 行）

**设计理念**：
- 三层防御体系：命令指令（prompt）→ PostToolUse Hook（格式）→ Stop Hook（完整性）
- 解决 AI "承诺做但实际没做"的执行力问题
- 存读档机制解决跨会话"失忆"问题

---

## v4.0.4 - 2026-02-03

### 🐚 Shell/Bash 规范支持 + 文档同步约束强化

**新增内容**：
- ✅ 创建 `shell-coding-standards` skill（650+ 行）
  - 严格模式规范（`set -euo pipefail`）
  - 函数规范（命名、参数处理、返回值）
  - 错误处理（trap、stderr 输出、命令检查）
  - 变量规范（引号、局部变量、默认值）
  - ShellCheck 集成与常见警告修复
  - 代码组织（模块化、脚本结构模板）
  - 测试方法（bats-core 单元测试）
  - 安全编码（输入验证、避免命令注入）
  - 性能优化（避免子进程、批量处理）

**development-standards.md 增强**：
- ✅ 新增 **3.5 文档与代码同步规范（强制）** 章节
  - 明确「功能更新必须同步文档」的硬性约束
  - 列出 8 种强制同步场景（API/CLI/配置/安装/依赖等变更）
  - 提供文档更新工作流和提交规范示例
  - 自查清单（8 项检查）
  - 特殊情况处理（紧急修复、内部调整、大文档处理）
  - 自动化检查方法（Git Hook 示例）
  - 惩罚机制（提醒 → 拒绝合并 → 流程改进）
  - 最佳实践（模板提交信息、PR 描述、代码与文档近距离）

**文件更新**：
- `templates/generic/coding-standards.md` - 添加 `.sh/.bash` 语言映射
- `README.md` - 添加 Shell/Bash skill 到语言列表
- `.agent/instructions.md` - 更新可用 Skills 列表

**设计理念**：
- 践行"吃自己的狗粮"（dogfooding）原则
- ai-rules 项目本身主要由 Shell 脚本组成，需要对应规范
- 文档不同步导致用户按过期文档操作失败（如 v4.0.3 功能更新后 README 未同步）
- 将"功能更新必须同步文档"从建议提升为强制要求

**受益场景**：
- Shell 脚本项目（如 ai-rules、CI/CD 脚本、系统工具）
- 所有需要文档维护的项目（避免文档与代码脱节）
- 团队协作项目（统一文档同步标准）

---

## v4.0.3 - 2026-02-03

### 🌐 多语言项目智能规范支持

**核心改进**：
- ✅ 新增 PHP 8.x coding standards skill (750+ 行)
- ✅ 修改项目类型检测逻辑，默认使用 generic 类型
- ✅ 更新 generic 模板，引导使用 skills 智能加载机制

**Skills 系统增强**：
- 创建 `.agent/skills/php-coding-standards/SKILL.md`
  - 包含 MVC 架构模式（Controller/Model/View 职责）
  - 涵盖 6 大安全防护（SQL注入/XSS/CSRF/文件上传/密码处理）
  - PHP 8.x 现代特性（构造器属性提升、match、枚举、空安全运算符）
  - 性能优化技巧（生成器、数组操作）
  - PHPUnit 测试最佳实践

**detect_project_type() 逻辑调整**：
- 默认返回 `generic` 而非自动检测语言类型
- 支持 AI 工具根据文件扩展名智能加载对应 skills
- 保留详细检测逻辑用于显式 `--type` 参数指定

**模板更新**：
- `templates/generic/coding-standards.md` v2.0
  - 新增"🎯 智能规范系统说明"章节
  - 列出文件类型与 skills 对应关系表
  - 说明多语言项目支持机制

**使用场景**：
- PHP 项目：`ai-rules init` → generic + php-coding-standards skill
- Next.js + Golang：`ai-rules init` → generic + (typescript-patterns & golang-patterns)
- 单命令适配所有项目，AI 自动识别语言

---

## v3.0 - 2026-02-02

### 🎯 核心变更：文档整合，消除冗余

**问题分析**：
- 原有三个文件存在 ~60% 内容重复
- copilot-instructions.md (32KB) 内容过多，影响读取效率
- GitHub Copilot 只会自动读取 `.github/copilot-instructions.md`
- 其他文档不会被自动加载，需要手动引用

**解决方案**：
- 将 `copilot-instructions.md` 重构为**主控文件**（6KB）
- 只包含：Priority 0 核心约束 + 快速参考 + 链接
- 详细内容保留在独立文档中

### 📁 文档结构

```
.github/
├── copilot-instructions.md       (6KB)  ← Copilot 自动读取
│   ├── Priority 0: 核心指令
│   ├── 角色定义
│   ├── 快速参考（工作流、Git、安全）
│   └── 链接到详细文档
│
├── development-standards.md     (30KB)  ← 通用规范
│   ├── 语言锚点
│   ├── 结构化开发工作流
│   ├── Git Worktree 详细说明
│   └── 问题修复、代码审查等
│
├── php-project-standards.md    (22KB)  ← PHP 项目规范
│   ├── 项目目录结构
│   ├── PHP 命名规范
│   ├── MVC 架构规范
│   └── 安全编码、性能、测试
│
└── README.md                     (4KB)  ← 导航索引
```

### 📊 效果对比

| 指标 | 优化前 | 优化后 | 改进 |
|------|--------|--------|------|
| 主文件大小 | 32KB | 6KB | ⬇️ 81% |
| 内容重复率 | ~60% | 0% | ✅ 消除 |
| Copilot 加载时间 | 慢 | 快 | ⚡ 显著提升 |
| 文档可维护性 | 低（三处修改） | 高（单点修改） | ✅ 改善 |
| 内容组织 | 混乱 | 清晰 | ✅ 改善 |

### 🎨 设计哲学

1. **主控文件原则**：
   - 只包含必须立即加载的核心约束
   - 快速参考常用规范
   - 通过链接引用详细内容

2. **内容分层**：
   - **L0 (主控)**: 核心指令、角色定义
   - **L1 (通用)**: 语言无关的开发规范
   - **L2 (项目)**: 特定语言/框架规范

3. **零冗余原则**：
   - 每条规则只在一个文件中定义
   - 通过链接引用，不复制粘贴
   - 便于维护和更新

### 🔄 文档读取机制

```
用户启动 Copilot
    ↓
自动加载 copilot-instructions.md (6KB)
    ↓
获取 Priority 0 约束 + 快速参考
    ↓
    ├→ 遇到复杂场景 → 查看 development-standards.md
    └→ PHP 相关问题 → 查看 php-project-standards.md
```

### 🎁 额外收益

- ✅ 便于团队新成员快速上手（读主控文件即可）
- ✅ 详细规范可独立演进（不影响主控文件）
- ✅ 支持跨项目复用（通用规范可直接复制）
- ✅ 便于生成团队培训材料（文档结构清晰）

---

## v2.0 - 2026-02-02

### 优化 Git Worktree 工作流

- 增加"问题定位阶段"（Step 0）
- 引入**复杂度评估决策点**
- 定义快速修复模式 vs Worktree 模式
- 添加详细的使用场景和示例

---

## v1.2 - 2026-01-30

### 初始版本

- 建立 PHP 8.x 开发规范
- 定义 MVC 架构规范
- 安全编码规范
- Git 提交规范

---

**维护原则**：
- 本文档记录规范文档的演进历史
- 每次重大变更需更新此文档
- 记录变更动机、方案和效果
