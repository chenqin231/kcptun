---
name: worktree-workflow
description: Git worktree 隔离工作流。写入型 subagent 通过 frontmatter isolation:worktree 自动隔离；主会话需 claude --worktree 启动。触发：多文件或 >50 行修改、新功能开发、架构调整、实验性开发。
---

# worktree-workflow — Git 工作区隔离

## 何时使用

满足任一条件时应走 worktree 路径：

- 新功能开发（非紧急 hotfix）
- 修改超过 50 行代码
- 修改超过 3 个文件
- 数据库迁移
- 架构调整
- 实验性开发
- 多个并行任务需要同时进行

## 两条隔离路径

### 路径 A（推荐）：使用带 `isolation: worktree` 的 subagent

本项目 7 个写入型 subagent 已默认启用 worktree 隔离：

- `build-error-resolver` — TypeScript / 构建错误修复
- `database-reviewer` — SQL / 数据库 schema 变更
- `e2e-runner` — E2E 测试生成与维护
- `go-build-resolver` — Go 构建错误修复
- `refactor-cleaner` — 死代码清理、重构
- `security-reviewer` — 安全漏洞修复
- `tdd-guide` — TDD 开发

调用方式：
```
使用 Agent 工具，subagent_type 设为上述任一名称，
Claude Code 会自动创建 worktree 并在隔离环境中执行。
```

**生命周期**：
- Agent 启动 → 自动创建 worktree
- Agent 完成 + 无改动 → 自动删除 worktree
- Agent 完成 + 有改动 → 保留 worktree，返回路径与分支名供 `git merge` 或 review

### 路径 B：主会话启动 `claude --worktree`

主会话需要隔离时（例如用户自己要在隔离环境里交互开发）：

```bash
claude --worktree
```

**注意**：官方目前**没有 settings.json 全局默认开关**。如果希望每次都默认隔离，在 shell 配置里加 alias：

```bash
# ~/.bashrc or ~/.zshrc
alias claudew='claude --worktree'
```

## 何时**不用** worktree（豁免）

- 单文件 ≤10 行的微修复
- 紧急生产 hotfix
- 纯文档改动
- 非 git 项目（工具不可用）
- 配置文件微调

## 冲突处理

worktree 完成后合并回主工作区：

```bash
# 在主工作区执行
git merge <worktree-branch>

# 若有冲突，在主工作区按常规流程解决
# 解决后删除 worktree
git worktree remove <worktree-path>
git branch -d <worktree-branch>
```

## 与其他 skill 协作

- `tdd` skill：TDD 流程本身涉及多轮修改，建议在 worktree 里做
- `fix` skill：Bug 修复 SOP 的 Phase 5（修复）天然适合 worktree
- `speckit.implement`：按任务执行实现时，每个独立任务可用独立 worktree

## 参考

- Anthropic Claude Code 官方 worktree 特性（v2.1.72+）
- `git worktree` 官方文档：https://git-scm.com/docs/git-worktree
