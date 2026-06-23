# 通用开发规范（索引）

> **版本**: 2.0
> **适用范围**: 所有项目
> **最后更新**: 2026-03-13

---

**CRITICAL: 禁止一次性读取所有细则。仅在触发对应场景时 Read 相关文件。**

## 细则索引

| 场景 | 细则文件 | 触发信号 |
|------|---------|---------|
| 规划/新功能/speckit | [planning-workflow.md](rules/planning-workflow.md) | "设计"、"规划"、新功能、speckit |
| 文档持久化/specs 管理 | [doc-persistence.md](rules/doc-persistence.md) | speckit 执行、specs/ 目录操作 |
| Tasks 拆解/Develop 执行 | [task-execution.md](rules/task-execution.md) | 任务拆解、开发阶段、验收 |
| 文档编写/同步/防污染 | [doc-hygiene.md](rules/doc-hygiene.md) | 创建/修改文档、README 更新 |
| Git Worktree/分支管理 | [worktree-workflow.md](rules/worktree-workflow.md) | 创建分支、worktree、隔离开发 |
| Bug 修复/TDD/根因定位 | [bug-fix-flow.md](rules/bug-fix-flow.md) | Bug 报告、测试驱动、修复流程 |
| Git 提交信息 | [git-commit.md](rules/git-commit.md) | 准备 commit、提交规范 |
| 代码审查/合并 | [code-review.md](rules/code-review.md) | PR 审查、合并前检查 |
| 开发最佳实践 | [best-practices.md](rules/best-practices.md) | 快速修复示例、Worktree 示例 |
| 生产故障处理 | [incident-handling.md](rules/incident-handling.md) | P0-P3 故障、紧急回滚 |

## 使用方式

1. 根据当前任务场景，Read 对应的细则文件
2. 每次只读取 1-2 个相关文件，禁止全部加载
3. 细则文件路径相对于 `.agent/` 目录

## 版本历史

- v2.0 (2026-03-13): 渐进式披露重构 — 拆为 thin router + 10 个细则文件
- v1.6 (2026-02-10): 新增存读档命令表（/save /load /restore /accept）
- v1.5 (2026-02-08): 区分完整/精简开发模式，强化需求沟通和任务拆分标准
- v1.4 (2026-02-08): specs/.current → progress.json 结构化进度追踪
- v1.3 (2026-02-05): 强化分阶段审批流程
- v1.2 (2026-02-05): 新增环境隔离原则实施指南
- v1.1 (2026-02-05): 新增 AI 行为铁律实施指南
- v1.0 (2026-02-02): 初始版本
