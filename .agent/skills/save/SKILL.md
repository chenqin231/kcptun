---
name: save
description: 代码提交 + 上下文快照（一键存档）。用法：/save 或 /save <备注>
---

# /save — 代码提交 + 上下文快照（一键存档）

## 用法

- `/save` — 提交所有修改 + 保存上下文快照
- `/save <备注>` — 提交并附带备注（同时作为 commit 信息后缀）

参数：$ARGUMENTS（可选备注）

---

## 执行流程

**[BLOCKING CONSTRAINT]** 以下每个步骤都必须实际执行，禁止跳过。

### 步骤 1：读取当前进度

使用 Read 工具读取 `specs/progress.json`，获取：
- `feature` — 当前需求名称
- `specsDir` — specs 目录路径
- `stage` — 当前阶段
- `stageLabel` — 阶段中文标签
- `currentTask` — 当前任务
- `completedTasks` / `totalTasks` — 任务进度

如果文件不存在，输出错误并终止：
```
[/save] 错误：未找到 specs/progress.json，请先通过 Planning 模式创建需求
```

### 步骤 2：提交代码变更

**[MUST - 这是 /save 命令的"存档"核心]**

使用 Bash 工具执行以下 Git 操作：

1. **暂存所有修改**：`git add -A`
2. **检查是否有变更需要提交**：`git diff --cached --quiet`
   - 如果没有变更（exit code 0），跳过提交，输出提示：
     ```
     [/save] 提示：没有检测到代码变更，跳过 git commit（仅保存上下文快照）
     ```
   - 如果有变更，继续执行提交
3. **生成 commit 信息**并提交：
   ```bash
   git commit -m "save(<feature>): <currentTask.title>

   阶段: <stageLabel> | 任务: <completedTasks>/<totalTasks>
   <如果有 $ARGUMENTS 备注，追加一行: 备注: $ARGUMENTS>"
   ```

**commit 信息示例**：
```
save(002-checkpoint-restore): 增强 /save + 新建 /restore + 废弃 /checkpoint

阶段: 开发阶段 | 任务: 0/1
备注: 完成 save.md 修改
```

### 步骤 3：更新 progress.json

使用 Edit 工具更新 `specs/progress.json`：
- **仅更新** `updatedAt` 字段为当前时间（ISO 8601 格式）
- **不改变**任何任务完成状态（/save 不是验收，不标记完成）

### 步骤 4：写入上下文快照到 context.md

**[MUST - 这是 /save 命令的核心价值]**

回顾当前对话的全部内容，提炼关键信息，**追加**写入 `specs/<feature>/context.md`。

如果 context.md 不存在，先创建并写入头部：
```markdown
# 开发上下文记录

> 此文件由 /save 和 /accept 命令维护，记录每次保存时的开发上下文。
> AI 在新会话开始时应首先读取此文件恢复上下文。
```

然后追加以下格式的快照（**最新在最前**，插入到头部之后）：

```markdown
---

## [YYYY-MM-DD HH:MM] 进度快照：<当前任务名> (<阶段标签>)

> 备注：<$ARGUMENTS 内容，如无则省略此行>

### 当前状态
- 正在执行：Task <id> - <title>
- 执行进度：[具体描述当前做到了哪一步]
- 阶段：<stageLabel>

### 已完成
- [本次对话中已完成的具体操作，逐条列出]

### 未完成（下次继续）
- [待完成的操作，按优先级排序，越紧急的越靠前]
- [每条要具体可执行，避免模糊描述]

### 关键决策
- [技术决策及理由，供下次会话参考]
- [如无重要决策则写"无"]

### 遗留问题
- [需要后续处理的问题]
- [如无则写"无"]

### 相关文件
- [本次修改/涉及的关键文件路径，不超过 10 个]
```

**提炼指引**（确保快照质量）：
- **"未完成"是最重要的部分** — 这是下次会话恢复后第一件要看的内容
- "已完成"要具体到操作，不写过程性对话
- "关键决策"必须包含"选择了什么"和"为什么"
- "遗留问题"必须具体可操作
- "相关文件"只列核心文件

### 步骤 5：输出存档报告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  进度已保存
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

需求：<feature>
阶段：<stageLabel>
任务：<completedTasks>/<totalTasks> - <currentTask.title>
提交：<commit SHA 前 7 位>（如跳过则显示"无新提交"）
快照：<specsDir>/context.md
时间：<当前时间>

下次开始时执行 /load 恢复进度 | /restore 可丢弃未提交修改
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 自检清单

**[BLOCKING]** 输出存档报告前，逐项确认：
- [ ] 代码变更已通过 git commit 提交（或确认无变更已跳过）？
- [ ] progress.json 的 updatedAt 已更新？
- [ ] context.md 已追加新的快照条目？
- [ ] 快照中的"未完成"部分是否具体可执行？

如有未完成项，立即补做后再输出报告。
