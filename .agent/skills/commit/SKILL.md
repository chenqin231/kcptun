---
name: commit
description: 自动提交并推送到当前分支。用法：/commit 或 /commit <备注>
---

# /commit — 自动提交并推送到当前分支

## 用法

- `/commit` — 自动提交所有修改并推送
- `/commit <备注>` — 附带额外备注信息

参数：$ARGUMENTS（可选备注）

---

## 执行流程

**[BLOCKING CONSTRAINT]** 以下每个步骤都必须实际执行，禁止跳过。

### 步骤 1：收集变更信息

使用 Bash 工具**并行**执行以下 Git 命令：

1. `git status` — 查看所有未跟踪和已修改的文件
2. `git diff` — 查看未暂存的变更内容
3. `git diff --cached` — 查看已暂存的变更内容
4. `git log --oneline -5` — 查看最近提交风格
5. `git branch --show-current` — 获取当前分支名

**如果没有任何变更**（工作区干净），输出提示并终止：
```
[/commit] 没有检测到任何变更，无需提交。
```

### 步骤 2：分析变更并生成提交信息

回顾本次会话中的所有操作，结合 `git diff` 输出，生成规范的 commit 信息。

**提交信息格式**：
```
<type>(<scope>): <subject>

<body>
```

**生成规则**：
- `type`：根据变更性质选择（feat/fix/refactor/docs/test/chore/perf）
- `scope`：根据主要修改的模块/目录确定
- `subject`：简洁描述变更目的（一句话）
- `body`：逐条列出关键变更点（如果变更较多）
- 如果有 `$ARGUMENTS` 备注，追加到 body 末尾

**示例**：
```
feat(commands): 新增 /user-rules 和 /commit 命令

- /user-rules: 自动整合用户规范到 .agent/user.md
- /commit: 自动提交并推送到当前分支
```

### 步骤 3：暂存文件

根据变更内容，使用 `git add` 暂存相关文件。

**暂存规则**：
- 优先按文件名逐个添加（`git add <file1> <file2> ...`）
- **禁止** `git add -A` 或 `git add .`（防止误提交敏感文件）
- **排除检查**：扫描变更文件列表，跳过以下类型：
  - `.env`、`credentials.*`、`*.key`、`*.pem` — 敏感文件
  - `node_modules/`、`vendor/`、`__pycache__/` — 依赖目录
  - 超大二进制文件（>1MB）
- **如果发现疑似敏感文件**，输出警告并询问用户是否继续

### 步骤 4：执行提交

使用 Bash 执行 `git commit`，使用 HEREDOC 传递 commit message：

```bash
git commit -m "$(cat <<'EOF'
<生成的提交信息>
EOF
)"
```

**如果提交失败**（如 pre-commit hook 失败）：
1. 分析错误原因
2. 修复问题（如格式化、lint 错误）
3. 重新暂存修复后的文件
4. 创建**新的** commit（禁止 `--amend`）

### 步骤 5：推送到远程

1. 检查当前分支是否有远程追踪分支：`git rev-parse --abbrev-ref --symbolic-full-name @{u}`
2. 如果没有远程追踪：使用 `git push -u origin <branch-name>`
3. 如果已有远程追踪：使用 `git push`

**推送前确认**：
- 如果当前分支是 `main` 或 `master`，**警告用户**并询问是否确认推送
- 其他分支直接推送

### 步骤 6：输出提交报告

```markdown
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  提交并推送完成
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

提交信息：<type>(<scope>): <subject>
提交哈希：<commit SHA 前 7 位>
分支：<branch-name>
变更文件：<文件数量> 个
   <逐行列出文件路径，前缀 +新增 ~修改 -删除>
推送状态：已推送到 origin/<branch-name>
时间：<当前时间>
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## 自检清单

**[BLOCKING]** 输出报告前，逐项确认：
- [ ] 已检查所有变更文件，无敏感文件泄露？
- [ ] commit 信息符合 `<type>(<scope>): <subject>` 格式？
- [ ] 已成功提交（非 amend）？
- [ ] 已推送到远程分支？
- [ ] 报告中的文件列表与实际变更一致？

如有未完成项，立即补做后再输出报告。
