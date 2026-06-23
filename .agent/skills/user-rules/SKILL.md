---
name: user-rules
description: 添加用户级全局规范到 ~/.claude/rules/
---

# /user-rules — 添加用户级全局规范到 ~/.claude/rules/

## 用法

- `/user-rules <规范要求>` — 将规范写入 `~/.claude/rules/`，对所有项目生效

参数：$ARGUMENTS

---

## Guard

If `$ARGUMENTS` is empty, output:

```
请描述要添加的全局规范，例如：
  /user-rules 提交代码前必须同步更新 VERSION、README badge 和 CHANGELOG
  /user-rules 永远不要自动 push，必须等用户确认
  /user-rules 所有 git commit 信息必须使用简体中文
```

Then stop. Do not proceed.

---

## 执行流程

**[BLOCKING CONSTRAINT]** 以下每个步骤都必须实际执行，禁止跳过。

### 步骤 1：读取现有全局规范

使用 Read 工具读取 `~/.claude/rules/` 下的所有 .md 文件，了解已有规范：

```
~/.claude/rules/
├── agents.md
├── coding-style.md
├── git-workflow.md
├── hooks.md
├── patterns.md
├── performance.md
├── security.md
└── testing.md
```

判断新规范属于哪个类别，优先追加到对应文件；若不属于任何现有类别，创建新文件。

### 步骤 2：冲突检测

检查 `$ARGUMENTS` 与现有全局规范是否冲突或重复：
- 是否与已有规范直接矛盾？
- 是否与现有文件中的某条规范重复？

**如果发现冲突**，输出警告并停止：

```
⚠️ 冲突检测

新规范与现有全局规范存在冲突：
- 冲突点：<具体描述>
- 涉及文件：~/.claude/rules/<文件名>.md
- 建议：<如何调整以消除冲突>

请修改后重新执行 /user-rules
```

Then stop. Do not proceed.

### 步骤 3：优化表达

对规范要求进行优化：
1. **归类**：确定写入哪个文件（或新建文件名）
2. **结构化**：清晰的条目格式
3. **规范化**：用"必须/禁止/建议"三级约束词
4. **去重**：与现有内容合并而非重复

### 步骤 4：写入目标文件

使用 Edit 工具将规范追加到对应的 `~/.claude/rules/<文件名>.md`。

格式要求：
- 在合适章节下追加，保持文件结构一致
- 若新建文件，使用 `# <主题>` 作为标题

### 步骤 5：同步到 Gitea

全局规范写入后，提示用户执行同步命令：

```bash
cd ~/.claude && git add -A && git commit -m "rules: <一句话描述>" && git push
```

### 步骤 6：输出融合报告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  🌐 全局规范已更新（~/.claude/rules/）
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 新增规范摘要：
<用一句话概括新增的规范核心内容>

🔍 冲突检测：✅ 无冲突
📄 写入文件：~/.claude/rules/<文件名>.md
⚡ 生效范围：本会话立即生效 + 所有项目所有设备（push 后）

📌 多设备同步：
  cd ~/.claude && git add -A && git commit -m "rules: <描述>" && git push

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 自检清单

**[BLOCKING]** 输出报告前，逐项确认：
- [ ] 已读取 ~/.claude/rules/ 下现有规范？
- [ ] 已完成冲突检测且无冲突？
- [ ] 已确定写入目标文件？
- [ ] 已写入目标文件？
- [ ] 已提示用户同步到 Gitea？

如有未完成项，立即补做后再输出报告。
