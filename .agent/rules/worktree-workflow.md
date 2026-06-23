# Git Worktree 开发与测试工作流

> **触发信号**：创建分支、worktree、隔离开发、多文件修改
> **对应铁律**：6️⃣ 环境隔离原则

---

## 适用场景

### 必须使用 Worktree（满足任意一项）

- 🆕 新功能开发（无论大小）
- 📏 改动超过 **50行代码** 或 **3个文件**
- 🗄️ 数据库变更（迁移、表结构修改）
- 🏗️ 架构调整（模块拆分、重构）
- 🧪 实验性开发（方案不确定）
- 🔀 需要保留多个版本同时测试

### 可豁免（快速修复模式）

- ✅ **<10行代码** 且 **单文件** 的简单修复
- ✅ 文档/注释更新
- ✅ 配置文件微调（不影响逻辑）

### 禁止直接在主分支修改

- ❌ 跨多个文件的修改
- ❌ 涉及数据库迁移
- ❌ 架构调整
- ❌ 不确定影响范围的修改

---

## 决策流程图

```
问题发现 → 问题定位（在主目录）→ 评估复杂度
    ├─→ 简单修复（单文件 <10行）→ 快速修复模式
    └─→ 复杂修复（≥3文件 或 ≥50行）→ Worktree 开发模式
```

---

## Worktree 开发模式（完整流程）

### 第零步：问题定位（在主目录）

```bash
cd /path/to/project
git status  # 确认主分支，无未提交修改
# 搜索代码、定位问题根因
```

### 第一步：创建 Worktree

```bash
git worktree add worktrees/<feature-name> -b <branch-name> <base-branch>

# 示例
git worktree add worktrees/feature-user-auth -b feature/user-auth master
```

**分支命名规范（强制）**：

| 类型 | 格式 | 示例 |
|------|------|------|
| 功能 | `feature/<name>` | `feature/user-batch-import` |
| 修复 | `fix/<name>` | `fix/upload-author-selection` |
| 热修复 | `hotfix/<name>` | `hotfix/login-crash` |
| 重构 | `refactor/<name>` | `refactor/database-query-optimization` |
| 文档 | `docs/<name>` | `docs/api-guide` |
| 测试 | `test/<name>` | `test/e2e-login` |

**命名禁止**：下划线 | 中文 | 描述不清晰（如 `fix-bug`）

### 第二步：在 Worktree 中开发

```bash
cd worktrees/<feature-name>
# 开发、测试、提交
git add -A && git commit -m "feat: 功能描述"
```

### 第三步：切换主目录到开发分支测试

```bash
cd /path/to/project

# 方式A：checkout 修改的文件（推荐，避免权限问题）
git checkout <branch-name> -- path/to/file1.ext path/to/file2.ext

# 方式B：完整切换分支
git stash && git checkout <branch-name>
```

### 第四步：测试

- 访问测试环境测试
- 运行测试脚本
- 检查日志、验证数据库
- 边界测试和异常测试

### 第五步：测试结果处理

**✅ 测试通过 → 合并**：
```bash
git checkout <base-branch>
git merge <branch-name> --no-ff  # 保留分支历史
```

**❌ 测试失败 → 回滚并返回第二步**：
```bash
git checkout HEAD -- path/to/files  # 方式A 恢复
# 或 git checkout <base-branch> && git stash pop  # 方式B 恢复
cd worktrees/<feature-name>  # 继续修改
```

### 第六步：清理 Worktree（验收通过后）

```bash
git worktree remove worktrees/<feature-name>
git branch -d <branch-name>
git push origin --delete <branch-name>  # 如果推送过远程
```

---

## 快速修复模式（<10行 且 单文件）

```bash
cd /path/to/project
git status  # 必须干净工作区
git pull    # 最新代码

# 修改 → 测试 → 提交
git add <modified-files>
git commit -m "fix(<scope>): 简短描述"
```

---

## 分支保护规则

**✅ 必须遵守**：
- 功能开发在独立分支，禁止直接在 master 开发
- 合并前充分测试
- 合并前解决所有冲突
- 合并后删除已合并的特性分支

**❌ 绝对禁止**：
- 直接在 master 开发
- `git push -f` 到 master 或共享分支
- 提交未完成的代码（TODO、调试代码、临时注释）
- 合并未经测试的代码
- 提交包含编译/运行时错误的代码

---

## 重要注意事项

1. **数据库共享**：所有 worktree 共享同一数据库，测试时注意数据影响
2. **文件权限**：切换分支可能遇到权限冲突，建议用 `git checkout <branch> -- <file>`
3. **必须测试后才合并**：紧急情况除外（但需立即补充测试）
4. **清理时机**：功能已合并 + 用户验收通过 + 代码已推送（如需）

---

## 方案模板中的环境隔离字段

```markdown
## 🏗️ 开发环境（强制）

**是否需要 Git Worktree？**
- [x] ✅ 是 - 需要创建 worktree
  - **触发原因**：新功能开发 / 超过50行代码 / 涉及3个文件
  - **分支名称**：`feature/user-registration`
  - **Worktree 路径**：`worktrees/user-registration`
  - **基础分支**：`master`

- [ ] ❌ 否 - 直接在主分支修改
  - **豁免原因**：单文件8行代码的简单修复
```
