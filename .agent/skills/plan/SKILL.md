---
name: plan
description: 轻量规划入口。在不需要 specs/ 目录、worktree、多阶段审批的小型修改场景下，inline 输出实现方案并等待用户确认。与 /speckit.specify 互补。
---

# /plan — 轻量级规划入口

> **定位**：speckit 流程的轻量替代。零文件副作用，inline 输出方案 + 等待用户确认。
> **对应铁律**：1️⃣ 方案先行原则

---

## 何时用 /plan vs /speckit.specify

入口边界由**用户决定**，下表仅供参考：

| 入口 | 参考场景 | 副作用 |
|------|---------|--------|
| `/plan`（本 skill） | 小型修改、Bug 修复、单文件重构、不需要新分支 | **零副作用**：inline 输出 + 等确认 |
| `/speckit.specify` | 新功能、多文件、架构变更、技术选型、需 PR 闭环 | 建 specs/ + worktree + 多阶段审批 |

**代码行数仅作参考**：经验上 <50 行变更适合 /plan，但最终由用户判断。

判定模糊时，AI 应**口头建议**用户切换到 /speckit.specify，**不自动跳转**。

---

## 执行协议

### 1. 复述需求
用清晰语言重述用户要求，标记不确定点。

### 2. 输出方案（固定格式）

```markdown
# 实现方案：<功能名>

## 需求复述
<2-3 句澄清用户要求>

## 受影响文件
- path/to/file1.ts — <做什么>
- path/to/file2.sh — <做什么>

## 实现步骤

### 步骤 1：<名称>（File: path/to/file.ts）
- 动作：<具体改什么>
- 原因：<为什么这样改>
- 依赖：无 / 需要步骤 X 完成
- 风险：低 / 中 / 高

### 步骤 2：<名称>（File: path/to/file.ts）
...

## 风险与缓解
- **风险**：<描述>
  - 缓解：<怎么处理>

## 复杂度评估
- 总行数：约 <N> 行
- 总文件数：<N> 个
- 复杂度：低 / 中 / 高

## 测试策略
- 单元测试：<哪些函数>
- 集成测试：<哪些流程>（如适用）
```

### 3. 等待确认（强制）

输出方案末尾必须包含：

```
**等待确认**：是否按此方案实施？（yes / no / modify: <修改点>）
```

**未收到 yes / proceed / 继续 / 同意 等明确肯定回复前，禁止写任何代码。**

### 4. 衔接 linus-three-questions（推荐）

用户确认方案后，**建议**在动手前跑一遍 `linus-three-questions` skill 自检（铁律 9）：
- 真问题吗？
- 有更简单方案吗？
- 会破坏什么？

未通过则回到方案重新设计。

---

## 硬约束

- **零文件副作用**：本 skill 执行期间禁止 `mkdir`、`touch`、`git checkout -b`、写任何 .md 或代码文件
- **不调用 subagent**：默认 inline 执行。仅当用户明确说"用 planner agent"时才委派 `.claude/agents/planner.md`
- **方案放在对话流里**：不写到 `specs/`、不写到 `~/.claude/plans/`（v4.6.0 废弃理由就是文档落盘位置混乱，本次重写规避此问题）
- **简体中文输出**：所有方案文本用简体中文，文件路径与代码标识符保留英文

---

## 与其他工作流的关系

| Skill / 命令 | 关系 |
|------|------|
| `/speckit.specify` | 重型替代。需要建分支 / 多阶段审批 / specs 目录时切换过去 |
| `linus-three-questions` | 方案确认后、动手前的质量门 |
| `defensive-delivery` | 代码完成后、交付前的 4 件套自检 |
| `tdd` | 实施时进入测试驱动循环 |
| `fix` | Bug 修复有独立 SOP，优先用 /fix |

---

## 示例

```
用户：/plan 给 lib/checker.sh 加一个 --quiet 参数，抑制非错误输出

AI 输出：
# 实现方案：checker.sh 静默模式

## 需求复述
为 lib/checker.sh 增加 --quiet 标志，运行时仅打印错误和最终判定，
抑制 INFO/DEBUG 级别输出。

## 受影响文件
- lib/checker.sh — 增 --quiet 解析 + 包装 echo 调用
- tests/checker.bats — 增 quiet 模式的 2 个测试用例

## 实现步骤

### 步骤 1：参数解析（File: lib/checker.sh）
- 动作：在现有 getopts 循环里新增 `q) QUIET=1 ;;`
- 原因：复用现有解析框架，不引入新依赖
- 依赖：无
- 风险：低

### 步骤 2：包装输出（File: lib/checker.sh）
- 动作：定义 info() 函数，QUIET=1 时 return；替换现有 9 处 echo
- 原因：集中控制输出，避免散落 if 判断
- 依赖：步骤 1
- 风险：低（grep "^echo" 确认无遗漏）

### 步骤 3：测试（File: tests/checker.bats）
- 动作：新增 `--quiet 抑制 INFO 输出` 和 `--quiet 不抑制 ERROR` 两个用例
- 原因：覆盖正反两个方向
- 依赖：步骤 1-2

## 风险与缓解
- **风险**：第三方调用方依赖现有输出做断言
  - 缓解：默认行为不变，--quiet 显式 opt-in

## 复杂度评估
- 总行数：约 25 行（含测试）
- 总文件数：2
- 复杂度：低

## 测试策略
- 单元测试：tests/checker.bats 新增 2 个 case
- 手动验证：bash lib/checker.sh --quiet 对比 bash lib/checker.sh

**等待确认**：是否按此方案实施？（yes / no / modify: <修改点>）
```
