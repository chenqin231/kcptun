---
name: accept
description: 任务/阶段验收 + 上下文清洗。用法：/accept 或 /accept task 验收任务，/accept stage 验收阶段。
---

# /accept 命令 — 任务/阶段验收 + 上下文清洗

## 用法

- `/accept` 或 `/accept task` — 验收当前任务，推进到下一个任务
- `/accept stage` — 验收当前整个阶段，推进到下一阶段

参数：$ARGUMENTS（默认为 `task`）

---

## 执行流程

**[BLOCKING CONSTRAINT]** 以下每个步骤都必须实际执行，禁止跳过。

### 步骤 0：创建验证标记

**[MUST]** 在开始验收前，使用 Bash 工具创建临时标记文件，供 Stop Hook 验证使用：

```bash
echo "$(date +%s)" > /tmp/claude-accept-pending
```

此标记表示"正在执行 /accept，尚未完成"。Stop Hook 会检查此标记来验证文件是否被真正更新。

### 步骤 1：读取当前进度

**[MUST]** 使用 Read 工具读取 `specs/progress.json`，获取当前状态：
- `feature` — 当前需求名称
- `stage` — 当前阶段
- `currentTask` — 当前任务
- `specsDir` — specs 目录路径

如果文件不存在，输出错误并终止：
```
[/accept] 错误：未找到 specs/progress.json，请先通过 Planning 模式创建需求
```

### 步骤 2：读取任务清单

**[MUST]** 使用 Read 工具读取 `specs/<feature>/tasks.md`，解析任务列表：
- 识别 `- [ ]`（未完成）和 `- [x]`（已完成）标记
- 确定当前正在执行的任务（第一个 `[ ]` 任务）

### 步骤 3：执行验收

**[MUST]** 根据参数执行不同的验收逻辑（必须使用 Edit 工具实际修改文件）：

#### 3a. 验收任务（`/accept` 或 `/accept task`）

1. 在 `tasks.md` 中将当前任务标记为 `[x]`
2. 定位下一个 `[ ]` 任务
3. 更新 `progress.json`：
   - `currentTask` → 下一个任务（如无则为 `null`）
   - `completedTasks` + 1
   - `updatedAt` → 当前时间
4. 如果所有任务已完成，提示用户执行 `/accept stage` 推进阶段

#### 3b. 验收阶段（`/accept stage`）

1. 在 `progress.json` 中将当前阶段标记为 `completed`
2. 推进到下一阶段：
   - research → requirements
   - requirements → plan
   - plan → tasks
   - tasks → develop
   - develop → **需求完成**（输出完成报告）
3. 更新 `progress.json`：
   - `stage` → 下一阶段
   - `stageLabel` → 对应的中文标签
   - 新阶段设为 `in_progress`
   - `currentTask` → `null`（新阶段还没有任务）
   - `updatedAt` → 当前时间

阶段标签映射：
| stage | stageLabel |
|-------|-----------|
| research | 研究阶段（精简模式下为 skipped） |
| requirements | 需求阶段 |
| plan | 设计阶段 |
| tasks | 任务分解阶段 |
| develop | 开发阶段 |

**注意**：推进阶段时跳过 `skipped` 状态的阶段（精简模式下 research 为 skipped）

### 步骤 3.5：E2E 测试检查（验收前）

1. 读取 `.agent/user.md` 中的"当前项目自定义规范"区域
2. 如果存在"E2E 测试流程"定义：
   - 提醒用户是否已执行 E2E 测试
   - 如果未执行，先按照该流程执行测试
   - 测试通过后再继续验收
3. 如果不存在项目特定测试流程，跳过此步骤

### 步骤 4：上下文清洗（关键）

**目的**：提炼当前对话中的关键信息，保存为持久化上下文，供跨会话恢复使用。

1. 回顾当前对话内容，提炼以下信息：
   - **关键决策**：技术选型、架构决定、方案选择及理由
   - **完成内容**：本次验收范围内实际完成的工作
   - **遗留问题**：未解决的问题、需要后续处理的事项
   - **相关文件**：本次修改涉及的关键文件路径

2. 追加写入 `specs/<feature>/context.md`（按时间倒序，最新在最前）

3. 每次验收追加的内容格式：

```markdown
## [YYYY-MM-DD] 验收[任务/阶段]：<名称> (<阶段>)

### 关键决策
- 决策1及理由
- 决策2及理由

### 完成内容
- 完成项1
- 完成项2

### 遗留问题
- 问题1
- 问题2（如无则写"无"）

### 相关文件
- path/to/file1
- path/to/file2
```

**提炼指引**（确保质量）：
- 只记录对后续开发有价值的信息，不记录过程性对话
- 关键决策必须包含"选择了什么"和"为什么选择"
- 遗留问题必须具体可操作，不写模糊描述
- 相关文件只列出核心文件（不超过 10 个）

### 步骤 5：输出验收报告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  验收完成
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

需求：<feature>
验收类型：任务/阶段
验收内容：<任务/阶段名称>

进度更新：
  - 阶段：<当前阶段> → <下一阶段>（如适用）
  - 任务：<已完成>/<总数>
  - 上下文已保存：specs/<feature>/context.md

下一步：
  - <下一个任务/阶段的描述>
  - 建议操作：<具体建议>

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

### 步骤 6：自检清单

**[BLOCKING]** 输出验收报告前，逐项确认以下内容。任何一项未完成都必须**立即补做**，不得跳过：

- [ ] `progress.json` 的 `updatedAt` 已更新为当前时间？
- [ ] `progress.json` 的 `completedTasks` 已递增（任务验收时）？
- [ ] `tasks.md` 中当前任务已标记为 `[x]`（任务验收时）？
- [ ] `context.md` 已追加验收记录（包含关键决策、完成内容、遗留问题）？

如有未完成项，立即补做后再输出验收报告。

### 步骤 7：清理标记

**[MUST]** 验收全部完成后，使用 Bash 工具删除临时标记文件：

```bash
rm -f /tmp/claude-accept-pending
```

**注意**：此步骤必须在自检清单全部通过后执行，否则 Stop Hook 会阻止退出。

---

## 边界情况处理

### 最后一个任务
- 所有任务完成后，提示：
  ```
  所有任务已完成！请执行 `/accept stage` 推进到下一阶段。
  ```

### 最后一个阶段（develop）
- develop 阶段验收后，输出需求完成报告：
  ```
  需求 <feature> 已完成全部开发流程！

  建议后续操作：
  1. 执行最终代码审查
  2. 合并分支到主分支
  3. 清理 Git Worktree（如有）
  4. 归档 specs 目录
  ```

### 无 progress.json
- 输出错误提示，引导用户创建

### 阶段不匹配
- 如果当前在 research 阶段执行 `/accept task`，提示：
  ```
  当前处于研究阶段，该阶段无任务列表。请使用 `/accept stage` 验收阶段。
  ```
  （只有 develop 阶段有具体任务，其他阶段使用 `/accept stage`）
