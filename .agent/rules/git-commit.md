# Git 提交规范

> **触发信号**：准备 commit、提交规范查询

---

## 提交信息格式

```
<type>(<scope>): <subject>

<body>

<footer>
```

## Type 类型

| 类型 | 说明 | 示例 |
|------|------|------|
| feat | 新功能 | `feat(auth): 添加用户注册功能` |
| fix | Bug修复 | `fix(upload): 修复文件大小验证问题` |
| docs | 文档更新 | `docs(readme): 更新安装说明` |
| style | 代码格式 | `style(api): 统一缩进格式` |
| refactor | 重构 | `refactor(user): 重构用户模块` |
| perf | 性能优化 | `perf(query): 优化数据库查询` |
| test | 测试相关 | `test(auth): 添加登录测试用例` |
| chore | 构建/工具 | `chore(deps): 更新依赖版本` |

## Scope（可选）

模块名（`auth`, `user`）、功能点（`login`, `upload`）、文件名（`config`）

## Subject

- 使用简体中文
- 祈使句，现在时态："添加"而非"已添加"
- 首字母小写
- 结尾不加句号
- 不超过50字符

## Body（可选但推荐）

复杂修改应包含：问题现象、根因分析、修复方案、验证方式

## Footer（可选）

- 关闭 Issue：`Closes #123`
- 破坏性变更：`BREAKING CHANGE: 说明`

## 完整示例

```
fix(upload): 修复管理员新增项目时作者选择无效的问题

问题现象：
- 管理员选择其他用户作为作者
- 上传后显示的仍是管理员账号

根因分析：
- upload.php 第205行硬编码使用当前登录用户ID
- 忽略了表单中选择的author参数

修复方案：
- 管理员模式下根据表单选择的author反查对应用户ID
- 普通用户保持原有逻辑

验证方式：
- 测试管理员选择其他用户创建项目
- 验证项目所有者正确设置

Closes #456
```
