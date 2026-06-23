# 文档持久化规范

> **触发信号**：speckit 执行、specs/ 目录操作、进度追踪
> **对应铁律**：1️⃣ 方案先行原则（文档持久化部分）

---

## 严禁的做法

- ❌ 将文档保存在私有目录（如 `~/.copilot/session-state/`）
- ❌ 将文档保存在临时目录
- ❌ 不保存文档，仅口头描述

---

## 文档目录结构

所有文档必须保存至项目根目录下：

```
specs/
├── progress.json              # 进度追踪（JSON 格式）
├── 001-user-registration/
│   ├── research.md           # 研究报告
│   ├── spec.md               # 需求文档
│   ├── plan.md               # 设计文档
│   ├── tasks.md              # 任务分解
│   ├── changelog.md          # 变更记录
│   └── context.md            # 开发上下文记录
└── 002-payment-integration/
    └── ...
```

---

## 命名规范

- **编号**：3位数序号（`001`、`002`），自动递增
- **需求名**：简短英文或拼音（如 `user-registration`）

**自动编号规则**：读取 specs/ 下最大编号 + 1

---

## 进度追踪文件（progress.json）

```json
{
  "feature": "001-user-registration",
  "branch": "feature/user-registration",
  "specsDir": "specs/001-user-registration",
  "stage": "plan",
  "stageLabel": "设计阶段",
  "stages": {
    "research": "completed",
    "requirements": "completed",
    "plan": "in_progress",
    "tasks": "pending",
    "develop": "pending"
  },
  "currentTask": { "id": 2, "title": "实现用户注册 API" },
  "totalTasks": 5,
  "completedTasks": 1,
  "updatedAt": "2026-02-08T10:30:00Z"
}
```

**用途**：
- AI 通过读取此文件知道当前需求、阶段、任务
- 跨会话恢复上下文
- 自动生成下一个需求编号
- `/save` 和 `/accept` 命令自动更新进度

---

## 上下文记录文件（context.md）

- 位置：`specs/<编号>-<需求名>/context.md`
- 由 `/save` 保存快照、`/accept` 验收时自动生成
- 记录关键决策、完成内容、遗留问题
- AI 新会话时应首先读取

---

## 存读档命令

| 命令 | 作用 | 说明 |
|------|------|------|
| `/save` | 代码提交 + 上下文快照 | `git add -A` + `git commit` + 写入 context.md |
| `/load` | 恢复开发进度 | 读取 progress.json + context.md + tasks.md |
| `/restore` | 丢弃未提交修改 | `git checkout .` + `git reset` + `git clean` |
| `/accept` | 验收任务/阶段 | 标记完成、推进进度、上下文清洗 |

---

## 开发原则（按优先级排序）

1. **质量优先** — 通过测试、符合规范、不留已知 Bug
2. **安全优先** — 输入验证、输出转义、敏感信息加密
3. **文档同步** — 更新功能必须同步更新 README.md / API 文档
4. **性能意识** — 避免 N+1 查询、大数据集分页、合理缓存
