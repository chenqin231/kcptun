# Implementation Plan: [FEATURE]

**Branch**: `[###-feature-name]` | **Date**: [DATE] | **Spec**: [link]
**Input**: Feature specification from `/specs/[###-feature-name]/spec.md`

**Note**: This template is filled in by the `/speckit.plan` command. See `.specify/agents/speckit.plan.md` for the execution workflow.

## Summary

[Extract from feature spec: primary requirement + technical approach from research]

## Technical Context

<!--
  ACTION REQUIRED: Replace the content in this section with the technical details
  for the project. The structure here is presented in advisory capacity to guide
  the iteration process.
-->

**Language/Version**: [e.g., Python 3.11, Swift 5.9, Rust 1.75 or NEEDS CLARIFICATION]  
**Primary Dependencies**: [e.g., FastAPI, UIKit, LLVM or NEEDS CLARIFICATION]  
**Storage**: [if applicable, e.g., PostgreSQL, CoreData, files or N/A]  
**Testing**: [e.g., pytest, XCTest, cargo test or NEEDS CLARIFICATION]  
**Target Platform**: [e.g., Linux server, iOS 15+, WASM or NEEDS CLARIFICATION]
**Project Type**: [single/web/mobile - determines source structure]  
**Performance Goals**: [domain-specific, e.g., 1000 req/s, 10k lines/sec, 60 fps or NEEDS CLARIFICATION]  
**Constraints**: [domain-specific, e.g., <200ms p95, <100MB memory, offline-capable or NEEDS CLARIFICATION]  
**Scale/Scope**: [domain-specific, e.g., 10k users, 1M LOC, 50 screens or NEEDS CLARIFICATION]

## Architecture Scope Assessment（架构规模评估）

> **必须决策**：根据 spec.md 需求内容，评估影响范围并选择对应的架构分析深度。

### 影响范围判断

| 维度 | 本次需求 |
|------|---------|
| 影响模块数 | [1 / 2-3 / 4+] |
| 是否新建模块 | [否 / 新增文件 / 新增模块 / 新增服务] |
| 接口变更范围 | [内部实现 / 模块接口 / 系统边界] |
| 数据模型变更 | [不变 / 字段调整 / 新实体 / 新关系] |

### 架构层级判定

根据以上判断，本次需求属于：

- [ ] **L1 模块内** — 单模块内部变更，接口不变
- [ ] **L2 跨模块** — 2+ 模块交互或新增模块
- [ ] **L3 系统级** — 新增服务/架构风格变更/重大重构

### 推荐架构 Skills

| 层级 | 加载 Skills | 关注点 |
|------|------------|--------|
| L1 | `design-patterns` | 局部设计模式选型 |
| L2 | `design-patterns` + `clean-architecture` | 依赖方向 + 边界设计 |
| L3 | `architecture-catalog` + `architecture-patterns` + `clean-architecture` | 架构选型 + 分层落地 + 规则守护 |

**本次推荐加载**: [根据层级自动填入]

⏸ **GATE: 用户确认加载的 Skills 后继续**

## Constitution Check

*GATE: Must pass before Phase 0 research. Re-check after Phase 1 design.*

[Gates determined based on constitution file]

## Project Structure

### Documentation (this feature)

```text
specs/[###-feature]/
├── plan.md              # This file (/speckit.plan command output)
├── research.md          # Phase 0 output (/speckit.plan command)
├── data-model.md        # Phase 1 output (/speckit.plan command)
├── quickstart.md        # Phase 1 output (/speckit.plan command)
├── contracts/           # Phase 1 output (/speckit.plan command)
└── tasks.md             # /speckit.tasks command output (NOT created by /speckit.plan)
```

### Source Code (repository root)
<!--
  ACTION REQUIRED: Replace the placeholder tree below with the concrete layout
  for this feature. Delete unused options and expand the chosen structure with
  real paths (e.g., apps/admin, packages/something). The delivered plan must
  not include Option labels.
-->

```text
# [REMOVE IF UNUSED] Option 1: Single project (DEFAULT)
src/
├── models/
├── services/
├── cli/
└── lib/

tests/
├── contract/
├── integration/
└── unit/

# [REMOVE IF UNUSED] Option 2: Web application (when "frontend" + "backend" detected)
backend/
├── src/
│   ├── models/
│   ├── services/
│   └── api/
└── tests/

frontend/
├── src/
│   ├── components/
│   ├── pages/
│   └── services/
└── tests/

# [REMOVE IF UNUSED] Option 3: Mobile + API (when "iOS/Android" detected)
api/
└── [same as backend above]

ios/ or android/
└── [platform-specific structure: feature modules, UI flows, platform tests]
```

**Structure Decision**: [Document the selected structure and reference the real
directories captured above]

## UI/UX Design（界面与交互设计）

> **条件填写**：仅当 spec.md 中有功能需求包含 UI Requirements 或 UX Requirements 时填写。否则删除本节。
> **强制要求**：本节内容必须基于 `ui-ux-pro-max` skill 的风格和交互选型结果生成。

### Style & Stack Selection（风格与技术栈选型）

| 决策项 | 选择 | 理由 |
|--------|------|------|
| Visual Style | [e.g., minimalism / glassmorphism] | [Why this fits the product context] |
| UI Stack | [e.g., shadcn/ui + Tailwind / native iOS] | [Why this fits the project] |
| Interaction Pattern | [e.g., modal flow / bottom sheet / inline] | [Why this fits the user journey] |

### Page / Screen Inventory（页面清单）

| Screen | Purpose | Entry Point | Exit Point |
|--------|---------|-------------|------------|
| [Screen name] | [What the user does here] | [What triggers this screen] | [Where user goes next] |

### Component Breakdown（组件拆解）

| Screen | Component | States | Notes |
|--------|-----------|--------|-------|
| [Screen] | [Component name] | empty / loading / success / error | [Any special behavior] |

### Message & Feedback Components（消息反馈组件设计）

> **强制要求**：当 spec AC 中包含 Toast/Modal/Inline 等反馈描述时，必须在此定义统一的反馈组件规范。

| 反馈类型 | 触发场景 | 默认时长 | 位置 | 消失方式 | 样式规则 |
|---------|---------|---------|------|---------|---------|
| Toast (Success) | 操作成功 | 3 秒 | [顶部/底部] | 自动消失 | [绿色背景/图标] |
| Toast (Error) | 操作失败（可恢复） | 5 秒 | [顶部/底部] | 自动消失 | [红色背景/图标] |
| Modal (Confirm) | 破坏性操作前 | — | 居中 | 用户点击确认/取消 | [标题+描述+双按钮] |
| Modal (Error) | 操作失败（需用户处理） | — | 居中 | 用户点击确定 | [标题+描述+单按钮] |
| Inline (Validation) | 表单字段校验失败 | — | 字段下方 | 字段值修正后消失 | [红色文字/边框] |
| Notification (Info) | 异步事件通知 | 持续/用户清除 | [顶部/侧边] | 用户点击关闭或滑动消除 | [信息色背景/图标] |

**文案规范**：
- 成功消息：动作 + 结果（如 "保存成功"、"订单已提交"）
- 错误消息：问题 + 恢复建议（如 "网络连接失败，请检查网络后重试"）
- 确认弹窗：操作后果 + 询问（如 "删除后无法恢复，确认删除？"）

---

### UX Flow（交互流程）

<!-- Derived from Overall UX Requirements + per-FR UX Requirements in spec.md -->

#### [Journey Flow Name]

1. User [action] → System [response / transition]
2. User [action] → System [response / transition]
3. [Continue until goal reached]

**Error Recovery**:
- [Error condition] → [What user sees] → [How user recovers]

**Edge Paths**:
- Back button: [behavior]
- Timeout: [behavior]
- [Other edge cases from spec]

---

## Module Decomposition（模块划分）

> **强制要求**：遵循"8️⃣ 模块化设计原则"，每个模块预估行数不得超过 500 行

| 模块名 | 职责 | 文件路径 | 预估行数 | 依赖模块 |
|--------|------|---------|---------|---------|
| [模块1] | [单一职责描述] | [src/path/file.ext] | [≤200] | [无/模块X] |
| [模块2] | [单一职责描述] | [src/path/file.ext] | [≤200] | [模块1] |

### 模块依赖关系

```
模块1 → 模块2 → 模块3
              ↘ 模块4
```

**循环依赖检测**：[无 / 有 → 解决方案]

## Parallel Development Feasibility（并行开发可行性）

| 任务组 | 涉及文件 | 与其他任务冲突？ | 可并行？ |
|--------|---------|----------------|---------|
| [任务A] | [file1.ext, file2.ext] | [无冲突] | [是] |
| [任务B] | [file3.ext] | [无冲突] | [是] |
| [任务C] | [file1.ext] | [与任务A共享 file1.ext] | [否，串行] |

## AC Verification Design（验收标准验证设计）

> **强制要求**：每条 spec AC 必须映射到可执行的技术断言。由 `/speckit.plan` Step 4.9 自动填充。
> **覆盖度要求**：每个涉及 UI 的 FR 必须同时有 Happy + Error 行；消息反馈必须断言具体文案。

| Spec AC | Coverage Type | Source | Verification Type | Technical Assertion | Verification Method |
|---------|--------------|--------|------------------|--------------------|--------------------|
| [AC-001-H1: 正常操作描述] | Happy | spec.md | [E2E/Unit/Integration] | [具体技术断言] | [验证手段] |
| [AC-001-E1: 异常操作描述] | Error | spec.md | [E2E/Unit/Integration] | [具体技术断言，含消息文案断言] | [验证手段] |

**Coverage Type 图例**：
- **Happy** — 正常操作路径验证
- **Error** — 异常操作路径验证（输入异常/状态异常/外部异常）
- **Message** — 消息反馈验证（Toast/Modal/Inline/Notification/页面跳转/状态变更 的文案、时机、消失方式）

**验证通过条件**：
- [ ] 每条 FR AC 至少 1 行映射（零覆盖 → 返回 spec 补充）
- [ ] 每条 SC 至少 1 行映射
- [ ] 每个 FR 同时有 Happy + Error 行；UI 相关 FR 额外需要消息反馈断言行
- [ ] 消息反馈断言包含具体文案（如 `toast[text="保存成功"]`、`redirect to /result`），禁止仅写 "toast appears"
- [ ] Technical Assertion 列无模糊词（optimize/improve/ensure/加强/完善 → 重写）
- [ ] Manual verification 行包含逐步操作步骤（非仅 "manually check"）

---

## Complexity Tracking

> **Fill ONLY if Constitution Check has violations that must be justified**

| Violation | Why Needed | Simpler Alternative Rejected Because |
|-----------|------------|-------------------------------------|
| [e.g., 4th project] | [current need] | [why 3 projects insufficient] |
| [e.g., Repository pattern] | [specific problem] | [why direct DB access insufficient] |
