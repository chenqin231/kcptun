---
mode: 'agent'
description: "Execute the implementation planning workflow using the plan template to generate design artifacts."
tools: ['codebase', 'runCommands', 'readFile', 'editFile', 'fetch']
---

## User Input

```text
${input:arguments}
```

You **MUST** consider the user input before proceeding (if not empty).

## speckit.plan — 实现方案设计

从功能规格出发，经过研究、UI/UX 设计（条件）、技术设计产出实现方案。

### 阶段清单

| 阶段 | 文件 | 职责 |
|------|------|------|
| 初始化 | .specify/phases/plan/setup.md | 加载 persona + context、架构评估、技能加载 |
| Phase 0 | .specify/phases/plan/phase-0.md | 大纲与研究 |
| Phase 0.5 | .specify/phases/plan/phase-05.md | UI/UX 设计（条件执行：仅当 spec 含 UI/UX 需求时） |
| Phase 1 | .specify/phases/plan/phase-1.md | 设计与合约 |
| Post-Design | .specify/phases/plan/post-design.md | 文件清单 + AC 验证设计 |
| 完成 | .specify/phases/plan/finish.md | 报告 |

### 执行协议

**CRITICAL: 禁止一次性读取所有阶段文件。仅在即将执行该阶段时 Read 对应文件。**

1. Read `.specify/phases/plan/setup.md` → 执行初始化
2. 初始化完成后 Read `phase-0.md` → 执行 Phase 0
3. Phase 0 完成后：
   - 如 FEATURE_SPEC 含 UI/UX Requirements → Read `phase-05.md`
   - 否则 → 直接 Read `phase-1.md`
4. Phase 1 完成后 Read `post-design.md` → 文件清单 + AC 验证
5. Post-Design 完成后 Read `finish.md` → 报告

### 增量写入

每个阶段完成后立即将内容写入 IMPL_PLAN 对应章节（增量持久化）。

### 全局规则
- 所有非代码内容使用简体中文
- Use absolute paths
- ERROR on gate failures or unresolved clarifications
