# 开发规范文档索引

> **最后更新**: 2026-02-03

---

## 🤖 AI 工具配置指引

### Copilot / Claude / Gemini 等 AI 工具应加载的文件

为确保 AI 工具能正确读取规范，请将以下文件添加到上下文中：

```
.agent/instructions.md          # L0: 核心指令（必读，最高优先级）
.agent/development-standards.md # L1: 开发流程规范（必读）
.agent/coding-standards.md      # L2: 语言编码规范（必读）
.agent/user.md                  # 项目坐标 + 项目特定规范（如有自定义）
```

**验证方法**：询问 AI "你加载了哪些规范文件？"，确认以上 3 个核心文件（L0/L1/L2）都已加载。

**Copilot CLI 用户**：
- 如果 Copilot 未自动加载 L1/L2，可手动执行：
  ```bash
  # 方法1：切换到 .agent 目录（让 Copilot 优先读取该目录文件）
  cd .agent && copilot --allow-all-tools

  # 方法2：在对话中明确要求
  "请读取 .agent/development-standards.md 和 .agent/coding-standards.md"
  ```

### Gemini/Antigravity 特殊说明

Gemini 不一定自动识别 `GEMINI.md`（即使是符号链接）。若规范未加载，在对话开始时手动提醒：
```
"请读取 .agent/instructions.md 与 .agent/user.md 并按其中约束执行"
```

项目级自定义规范统一写入 `.agent/user.md`（用 `/project-rules` 或 `$project-rules` 添加），不再使用独立的 `custom.md`。

---

## 📚 规范文档体系

```
.agent/
├── instructions.md          # AI 核心指令（语言无关）
├── development-standards.md # 开发流程规范（Git、工作流等）
├── coding-standards.md      # 语言编码规范（根据项目语言生成）
├── user.md                  # 项目坐标 + 项目自定义规范（L4 层，最高优先级）
└── skills/                  # AI Skills（可选启用）
```

### 规范层级

| 层级 | 文件 | 说明 |
|------|------|------|
| L0 | instructions.md | 最高优先级，AI 核心行为约束 |
| L1 | development-standards.md | 开发流程、Git 规范（语言无关） |
| L2 | coding-standards.md | 语言/框架特定规范（项目初始化时生成） |
| L3 | skills/ | 可选的 AI 技能扩展 |
| L4 | user.md | 项目坐标 + 项目自定义规范（可覆盖上层规范，优先级最高） |

---

## 🌐 多语言项目支持

### 问题场景

项目中同时使用多种编程语言（如 Next.js + Golang 前后端分离）：
- 前端：TypeScript/React/Next.js
- 后端：Golang/Python/Java
- 数据库：PostgreSQL/MongoDB

### 解决方案：智能 Skills 加载

不需要为每种语言创建单独的规范文件，AI 工具应：

1. **自动识别当前文件语言**
   - 通过文件扩展名：`.ts/.tsx` → TypeScript，`.go` → Golang
   - 通过目录结构：`frontend/` → Next.js，`backend/` → Golang

2. **动态加载对应的语言 Skills**
   - 编辑 `.tsx` → 自动加载 `skills/typescript-patterns`
   - 编辑 `.go` → 自动加载 `skills/golang-patterns`, `skills/golang-testing`
   - 编辑 `.py` → 自动加载 `skills/python-patterns`, `skills/python-testing`

3. **可用的语言 Skills**
   ```
   TypeScript/JavaScript: typescript-patterns
   Golang:                 golang-patterns, golang-testing
   Python:                 python-patterns, python-testing
   Java:                   java-coding-standards
   Django:                 django-patterns, django-security, django-tdd
   ```

### 使用示例

```bash
# 初始化为 generic 类型（适用于多语言项目）
cd /path/to/project
ai-rules init --type=generic

# AI 会根据文件类型自动应用对应规范
# 编辑 app/page.tsx → 应用 TypeScript + Next.js 规范
# 编辑 server/main.go → 应用 Golang 规范
```

### 最佳实践

1. **项目结构建议**
   ```
   project/
   ├── frontend/          # Next.js/TypeScript
   ├── backend/           # Golang/Python
   ├── shared/            # 共享类型定义
   └── .agent/           # AI 规范（所有语言通用）
   ```

2. **在 user.md 中补充项目特定约定**
   ```markdown
   # 项目特定规范
   
   ## 前端技术栈
   - Next.js 14+ (App Router)
   - TypeScript 5+
   - Tailwind CSS
   
   ## 后端技术栈
   - Golang 1.21+
   - Gin Framework
   - GORM
   ```

---

## 📄 规范文档说明

### 1. AI 核心指令
**文件**: [instructions.md](./instructions.md)

包含 AI 编程工具的最高优先级约束：
- 全局语言锚点（简体中文）
- 角色定义（资深架构师）
- 工作原则（KISS 原则）
- 结构化开发工作流
- Git Worktree 工作流
- 安全编码原则
- 代码提交前检查清单

### 2. 通用开发规范
**文件**: [development-standards.md](./development-standards.md)

适用于**所有项目**，包含：
- 结构化开发工作流（Planning 模式）详细说明
- Git Worktree 开发与测试工作流
- 问题修改规范（根因定位）
- Git 提交规范
- 代码审查规范
- 文档规范
- 故障处理规范

### 3. 语言编码规范
**文件**: [coding-standards.md](./coding-standards.md)

根据项目语言自动生成，包含：
- 项目目录结构规范
- 语言特定的命名规范
- 安全编码规范（示例代码）
- 错误处理规范
- 测试规范
- 语言特定的检查清单

> 💡 此文件在运行 `ai-rules init` 时根据所选项目类型自动生成

---

## 🎯 快速导航

### 新人入职
1. 阅读 [instructions.md](./instructions.md)（核心指令）
2. 了解 [development-standards.md](./development-standards.md)（开发流程）
3. 学习 [coding-standards.md](./coding-standards.md)（语言规范）

### 开始新功能
1. 参考 [development-standards.md](./development-standards.md) 第 2 节（结构化开发工作流）
2. 按照 Research → Requirements → Plan → Tasks → Develop 流程执行

### 修复 Bug
1. 参考 [development-standards.md](./development-standards.md) 第 6 节（问题修改规范）
2. 必须先定位根因，再修复问题
3. 根据复杂度选择 Worktree 模式或快速修复模式

### 代码安全
1. 参考 [coding-standards.md](./coding-standards.md) 安全编码规范部分
2. 遵循 [instructions.md](./instructions.md) 中的安全编码原则

---

## ⚠️ 核心约束（必读）

### 最高优先级：全局语言锚点

**[HARD CONSTRAINT: ALWAYS RESPOND IN SIMPLIFIED CHINESE]**

无论在任何模式下（Thinking/Planning/Coding），所有非代码内容必须使用**简体中文**。

### 角色设定

- **资深架构师**：30年编码经验
- **第一性原理**：从底层逻辑剖析问题
- **KISS 原则**：严禁过度工程

### 结构化开发（Planning 模式）

识别到"规划"、"设计"、"新功能"时，必须按以下流程执行：

```
Research → Requirements → Plan → Tasks → Develop
```

所有文档必须保存至：`specs/<编号>-<需求名>/`

---

## 📖 版本历史

| 版本 | 日期 | 变更说明 |
|------|------|----------|
| 4.0 | 2026-02-03 | 重构为语言无关的通用规范体系 |
| 3.0 | 2026-02-02 | 拆分为通用规范和项目规范 |
| 2.0 | 2026-02-02 | 优化 Git Worktree 工作流 |
| 1.2 | 2026-01-30 | 初始统一规范文档 |

---

**维护说明**：
- `instructions.md` 和 `development-standards.md` 来自 ai-rules 仓库
- `coding-standards.md` 根据项目类型从模板生成，可自行定制
