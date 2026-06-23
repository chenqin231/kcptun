---
inclusion: manual
name: speckit-implement
description: "Execute the implementation plan by processing and executing all tasks defined in tasks.md"
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## speckit.implement — 任务执行

按 tasks.md 定义的任务清单执行开发，包含 worktree 隔离、分层加载、单任务验证和全局验收。

> **⚠️ 人格前置（MANDATORY）**：Step 0 在 `setup.md` 中 Read `.agent/personas/backend.md` 加载后端工程师人格（涉及 frontend 文件时动态切换 `frontend.md`）。全流程保持人格内化，不得退化为通用助手。global-gate 前临时切换至 `code-reviewer.md` 做交叉审查。

### 阶段清单

| 阶段 | 文件 | 职责 |
|------|------|------|
| 初始化 | .specify/phases/implement/setup.md | Worktree 创建 + checklist 检查 |
| 执行 | .specify/phases/implement/load-and-execute.md | 分层加载 + 按任务执行 |
| 单任务验证 | .specify/phases/implement/validate-task.md | AC 对照 + 测试 + Lint（每任务完成后） |
| 全局门控 | .specify/phases/implement/global-gate.md | 覆盖率报告 + 验收判定（所有任务完成后） |

### 执行协议

**CRITICAL: 禁止一次性读取所有阶段文件。仅在即将执行该阶段时 Read 对应文件。**

1. Read `.specify/phases/implement/setup.md` → 执行初始化
2. Setup 完成后 Read `load-and-execute.md` → 加载 context + 逐任务执行
3. **每个任务完成后** Read `validate-task.md` → 执行 Step 9 验证
   - 验证通过 → 继续下一个任务
   - 验证失败 → 修复后重新验证，不继续
4. **所有任务标记 [x] 后** Read `global-gate.md` → 执行 Step 10 全局验收

### 全局规则
- 所有非代码内容使用简体中文
- Use absolute paths
- Follow TDD approach: test tasks before implementation tasks
