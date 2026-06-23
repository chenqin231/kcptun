---
name: load
description: 恢复开发进度。读取 progress.json、context.md、tasks.md，输出恢复报告并等待确认。
---

# /load 命令 — 恢复开发进度

## 用法

- `/load` — 读取存档，恢复到上次进度点

参数：无

---

## 执行流程

**[BLOCKING CONSTRAINT]** 以下每个步骤都必须**使用 Read 工具实际读取文件**，禁止凭记忆回答，禁止跳过任何文件。

### 步骤 1：读取 progress.json

使用 Read 工具读取 `specs/progress.json`，获取：
- `feature` — 当前需求名称
- `branch` — 开发分支
- `worktree` — worktree 路径（如有）
- `specsDir` — specs 目录路径
- `stage` / `stageLabel` — 当前阶段
- `currentTask` — 当前任务
- `completedTasks` / `totalTasks` — 任务进度
- `updatedAt` — 上次更新时间

如果文件不存在，输出错误并终止：
```
[/load] 错误：未找到 specs/progress.json，当前没有进行中的开发任务
```

### 步骤 2：读取 context.md

**[MUST]** 使用 Read 工具读取 `specs/<feature>/context.md`。

这是最关键的文件，包含上次保存的开发上下文快照。重点关注**最新一条快照**中的：
- **"未完成（下次继续）"** — 这是恢复后第一件要做的事
- **"当前状态"** — 了解上次做到了哪一步
- **"关键决策"** — 确保延续之前的技术决策
- **"遗留问题"** — 检查是否有需要先处理的问题

如果文件不存在，记录警告但不终止（可能是首次开发）。

### 步骤 3：读取 tasks.md

**[MUST]** 使用 Read 工具读取 `specs/<feature>/tasks.md`。

获取完整的任务列表和完成状态，确认：
- 哪些任务已完成（`[x]`）
- 当前任务的具体步骤和验收标准
- 下一个待执行任务

### 步骤 4：读取 plan.md（可选）

使用 Read 工具读取 `specs/<feature>/plan.md`。

获取设计决策背景，帮助理解整体架构。如果文件不存在，跳过此步骤。

### 步骤 5：输出恢复报告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  进度已恢复
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

需求：<feature>
分支：<branch>
阶段：<stageLabel>
任务进度：<completedTasks>/<totalTasks>

上次停在：
  - 任务：Task <id> - <title>
  - 进度：<从 context.md 最新快照提取>
  - 时间：<updatedAt>

关键上下文：
  - <context.md 中最新快照的关键决策摘要>

下一步：
  - <从 context.md "未完成（下次继续）"提取的待办事项>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 步骤 6：等待用户确认

输出恢复报告后，**必须等待用户确认**再继续开发。询问：
```
已恢复到上次进度点。确认后继续开发，或告诉我需要调整的地方。
```

---

## 自检清单

**[BLOCKING]** 输出恢复报告前，逐项确认：
- [ ] 是否使用 Read 工具**实际读取了** progress.json？（不是凭记忆）
- [ ] 是否使用 Read 工具**实际读取了** context.md？
- [ ] 是否使用 Read 工具**实际读取了** tasks.md？
- [ ] 恢复报告中的"下一步"是否来自 context.md 而非推测？

如有未完成项，立即补做后再输出报告。
