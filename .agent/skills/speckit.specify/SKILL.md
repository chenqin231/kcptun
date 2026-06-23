---
name: speckit.specify
description: Create or update the feature specification from a natural language feature description.
handoffs:
  - label: Build Technical Plan
    agent: speckit.plan
    prompt: Create a plan for the spec. I am building with...
  - label: Clarify Spec Requirements
    agent: speckit.clarify
    prompt: Clarify specification requirements
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## speckit.specify — 需求规格生成

从用户描述出发，经过 8 个发现阶段（A-H）产出功能规格文档。

### 阶段清单

| 阶段 | 文件 | 职责 |
|------|------|------|
| 初始化 | .specify/phases/specify/setup.md | 创建分支、加载模板、创建 spec.md 骨架 |
| A | .specify/phases/specify/phase-a.md | 用户问题挖掘 |
| B | .specify/phases/specify/phase-b.md | 竞品分析 |
| C | .specify/phases/specify/phase-c.md | 方案发散 |
| D | .specify/phases/specify/phase-d.md | 用户旅程 |
| E | .specify/phases/specify/phase-e.md | 功能需求 |
| F-H | .specify/phases/specify/phase-fgh.md | 范围 + 假设 + 验收 |
| 完成 | .specify/phases/specify/finish.md | 自检 + 报告 |

### 按需加载的共享规则

| 规则 | 加载时机 |
|------|---------|
| .specify/rules/ac-quality.md | Phase E 写 AC 时 |
| .specify/rules/ac-coverage.md | Phase E 写 AC 后检查覆盖时 |
| .specify/rules/fr-content-check.md | Phase E 写 FR 时 |
| .specify/rules/sc-rules.md | Phase H 写成功标准时 |

### 执行协议

**CRITICAL: 禁止一次性读取所有阶段文件。仅在即将执行该阶段时 Read 对应文件。**

1. Read `.specify/phases/specify/setup.md` → 执行初始化（创建 spec.md 骨架）
2. 初始化完成后 Read `phase-a.md` → 执行 Phase A
3. 每个阶段的 [STOP] 检查点等待用户确认后：
   a. **立即将确认内容写入 SPEC_FILE 对应章节**（增量持久化）
   b. Read 下一个阶段文件
4. Phase E 执行前，额外 Read `ac-quality.md`、`ac-coverage.md`、`fr-content-check.md`
5. 所有阶段确认后 Read `finish.md` → **Read SPEC_FILE → 自检 → 修补**（非从头生成）

### 全局规则
- 所有非代码内容使用简体中文
- Focus on WHAT users need — NEVER include HOW to implement
- Written for business stakeholders, not developers
- DO NOT create any checklists embedded in the spec
- When a section doesn't apply, remove it entirely (don't leave as "N/A")
- **[HARD CONSTRAINT] 禁止在 specify 阶段读项目代码**：不得 Read/Grep/Glob/Explore 项目源码、数据库 schema、配置文件等实现细节。需求阶段只与用户对话，不看代码。例外：① 用户主动要求参考特定文件 ② Fetch 用户提供的外部参考链接（UI 参考、竞品等）。
