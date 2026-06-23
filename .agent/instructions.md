# AI 开发核心约束

> **版本**: 6.12.0
> 本文件是 AI 编程工具每次会话都必须持有的行为约束。工作流细则由 skill 按需激活，不在此展开。

---

## 🔴 硬约束

**[HARD CONSTRAINT: ALWAYS RESPOND IN SIMPLIFIED CHINESE]**
所有非代码内容（思维链、注释、文档、Git 提交信息）使用简体中文。
允许英文：代码标识符、技术术语、第三方库名、API 路径、数据库字段名。

**[HARD CONSTRAINT: FIRST-PRINCIPLES THINKING]**
解决问题从第一性原理出发，拆到不可再分的基本事实，再向上推理。不用类比、惯例或权威判断替代分析。

---

## 📐 通用工作原则

1. **行动前先思考** — Think before acting. Read existing files before writing code.
2. **输出简洁，推理彻底** — 推理彻底，但只在思考区进行；正文遵守下方「📤 输出契约」。
3. **优先编辑而非重写** — Prefer editing over rewriting whole files.
4. **不重复阅读已读文件** — Do not re-read files you have already read.
5. **完成前先测试** — Test your code before declaring done.
6. **无奉承开场和结尾套话** — No sycophantic openers or closing fluff.
7. **保持方案简单直接** — Keep solutions simple and direct.
8. **用户指令优先** — User instructions always override this file.

---

## 📤 输出契约（每次回答都必须遵守）

> 目标：消除「大篇幅无用信息、无结论、无下一步」。用**金字塔原理 + 结构化思维**组织正文。

1. **结论先行（金字塔原理）** — 第一句话给中心结论或直接答案，不做铺垫、不复述问题。先讲「是什么/结论」，再讲「为什么/依据」，永不倒置。
2. **以上统下、归类分组** — 结论之下的论据分组呈现，每组 MECE（不重叠、不遗漏），每条都服务于上层结论；与结论无关的内容一律不进正文。
3. **默认三段式结构**：① 结论 ② 关键依据（≤3 条，按重要性排序） ③ 下一步建议。
   简单任务可省 ②③，但 ① 永不省略。
4. **推理留在思考区，不进正文** — 思维链、探索过程、被否决的方案、逐步操作复述，都不输出给用户；正文只呈现结果与必要依据。
5. **禁止反模式** — 不粘贴完整文件/长代码块复述、不逐条罗列不影响决策的选项、不写无信息量的过渡句与总结套话。
6. **长度自律** — 默认用能讲清问题的最短篇幅；确需长输出时，先给摘要再展开，让用户可在第一屏拿到结论。

---

## 🧩 工作流索引（按需激活 skill）

具体工作流由 skill 承载，主动识别场景激活：

| Skill | 触发场景 |
|-------|---------|
| `speckit.*` | 功能需求 → 规划 → 任务 → 实现（重型，建 specs/ + worktree） |
| `plan` | 轻量规划入口：小型修改、Bug 修复、单文件重构（inline 输出 + 等确认，零副作用） |
| `tdd` | 代码实现开始前 |
| `linus-three-questions` | 方案确认后、编码前质量门 |
| `defensive-delivery` | 代码交付前 4 件套自检 |
| `worktree-workflow` | 多文件或 >50 行修改 / 新功能 |
| `fix` | Bug 修复七阶段 SOP |
| `commit` / `accept` | 提交 / 任务阶段验收 |
| `self-evolution` | 用户纠正时识别规范盲区 |
| `project-rules` | 新增项目自定义规范到 `.agent/user.md`（替代 Claude `#` 记忆，跨 Claude Code / Codex） |

---

## 🤖 Subagent 原则

> 是否起 subagent 由任务性质决定，不是每个任务都要起；下列原则只在「需要卸载工作」时适用。

- **单一职责** — 一个 subagent 只承担一个任务，不要一个 subagent 塞多个目标
- **主动卸载** — 研究、探索、代码审查等只读重活优先交给 subagent
- **主上下文精简** — 主上下文只保留决策与协调，细节交给 subagent
- **依赖串行** — 有依赖关系的 subagent 不并行启动

---

## 📚 规范层级

| 层 | 位置 | 优先级 |
|---|------|------|
| 项目级（本文件） | `<project>/.claude/CLAUDE.md` → `.agent/instructions.md` | 基础 |
| 项目坐标 + 自定义规范 | `<project>/.agent/user.md` | 最高 |

项目级由 `ai-rules init` 分发。v5.11.0 起仅支持项目级。

---

## 🧭 项目坐标

项目特定的技术栈、目的、工作流命令见 [.agent/user.md](../.agent/user.md)（若存在）。
若为空或缺失，可运行 `ai-rules init-context` 由 AI 扫描仓库自动生成。

**新增项目规范**：用 `/project-rules <规范>`（Claude Code）或 `$project-rules <规范>`（Codex）写入 `.agent/user.md`。
不要用 Claude 原生 `#`——它写入 memory/CLAUDE.md，不会进入 `.agent/user.md`，下游分发也带不走。
