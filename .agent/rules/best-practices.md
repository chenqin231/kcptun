# 最佳实践示例

> **触发信号**：快速修复示例、Worktree 示例、开发流程参考

---

## 示例1：简单 Bug 修复（快速模式）

```bash
# 问题：后台新增项目时作者选择无效
cd /path/to/project

# 第零步：定位问题
# - grep 搜索相关代码
# - 定位到 upload.php 第205行
# 评估：单文件，12行代码，根因明确 → 快速模式

# 直接修改 → 测试 → 提交
git add upload.php
git commit -m "fix(upload): 修复管理员新增项目时作者选择无效的问题

问题现象：
- 管理员选择其他用户作为作者
- 上传后显示的仍是管理员账号

根因分析：
- 第205行硬编码使用当前登录用户ID

修复方案：
- 管理员模式下根据选择的author查找对应用户ID

验证方式：
- 测试通过"
```

---

## 示例2：新功能开发（Worktree 模式）

```bash
# 需求：添加项目审批流程
cd /path/to/project

# 评估：涉及多文件 + 数据库迁移 → Worktree 模式

# 第一步：创建 worktree
git worktree add worktrees/feature-approval -b feature/project-approval master

# 第二步：开发
cd worktrees/feature-approval
# 创建模型、API、视图...
git add -A
git commit -m "feat(approval): 添加项目审批流程"

# 第三步：切换测试
cd /path/to/project
git checkout feature/project-approval -- models/Approval.php api/approval.php

# 第四步：测试
# 访问测试环境测试功能

# 第五步：测试通过，合并
git checkout master
git merge feature/project-approval --no-ff

# 第六步：清理
git worktree remove worktrees/feature-approval
git branch -d feature/project-approval
```
