# speckit.test — Round 3：E2E 端到端测试

> 所属命令：speckit.test | 阶段：Round 3 of 3

## 目标

以用户视角跑完整用户故事路径。**E2E 的断言对象是 spec.md 的 Acceptance Scenarios，不是 tasks.md 的 AC**——前者是端到端行为，后者是单任务验收标准。

## 执行步骤

### 3a. E2E 入口

从 Setup 的测试矩阵中读取 Round 3 入口。若标记 `⏭ 跳过`（无 E2E 工具链或项目类型不适用），跳到 3d。

### 3b. 加载 Acceptance Scenarios

Read `specs/<BRANCH>/spec.md`，提取所有 `## Acceptance Scenarios`（或 `## User Stories` 中的 "Given-When-Then"）。这些是本轮 E2E 的**目标用例**。

```
从 spec.md 提取到 N 条 Acceptance Scenarios：
  AS-1: Given <条件>, When <动作>, Then <结果>
  AS-2: ...
```

### 3c. 执行 E2E

对每条 AS，优先：

1. **已有自动化脚本** → 直接运行，记录 pass/fail
2. **无自动化但可脚本化** → 当场生成脚本（tester 人格主动提议），运行并记录；询问用户是否将脚本落盘到 `tests/e2e/`
3. **只能手动**（需要浏览器、真实第三方服务等）→ 输出**可重现的手动步骤清单**，要求用户执行后回报结果

每条用例输出：

```
🎬 AS-1: <scenario 摘要>
  执行方式：自动 / 手动
  状态：✅ pass / ❌ fail / ⏸ 待用户执行
  （若 fail）重现步骤：
    1. ...
    2. ...
    3. （失败点）
  （若 fail）实际 vs 预期：
    实际：<观察到的结果>
    预期：<spec 要求的结果>
```

### 3d. 跳过登记（无 E2E 工具链）

若 3a 标记跳过，本步输出：

```
⏭ Round 3 跳过：<原因，如"项目为 CLI 工具，无浏览器 E2E 场景">
⚠️ 风险：无 E2E 意味着 Acceptance Scenarios 缺少端到端验证。
📌 缓解建议：
  - 用集成测试（integration tests）覆盖关键用户路径
  - 为 CLI 工具建立 `tests/e2e-manual.sh`（手动脚本）
  - 为 API 项目建立 contract test（Pact / OpenAPI schema）
  - 本项目（如 rules 仓库）应维护 `tests/test_e2e_*.bats` 覆盖 user journeys
```

### 3e. 破坏性 E2E 补充（tester 人格强制输出）

即使自动化 E2E 全绿，也至少提出 **3 条未被 spec 覆盖但值得手动验证的场景**：

```
🧪 探索性 E2E 建议：
  1. 中断恢复：在 <关键步骤> 中途关闭浏览器/进程，重开后数据状态是否一致？
  2. 并发用户：两个用户同时 <动作>，数据/UI 是否有竞态？
  3. 权限边界：用低权限用户尝试执行高权限动作，错误提示是否清晰？
```

### 3f. 本轮汇总

```
📊 Round 3 — E2E
  执行：✅ / ⏭
  AS 总数：N
  通过：N
  失败：N
  待用户手动：N
  破坏性建议：N 条
```

**Round 3 完成后**：Read `.specify/phases/test/report.md` 输出终裁。
