# speckit.test — Final Report（终裁）

> 所属命令：speckit.test | 阶段：终裁

## 目标

合并三轮结果为一张表，以 tester 人格给出 **GO / NO-GO** 判定，并列出探索性建议。

## 执行步骤

### R1. 三轮结果汇总

```
## speckit.test Final Report — <BRANCH_NAME>

| Round | Status | Pass | Fail | Skip 原因 |
|-------|--------|------|------|----------|
| 1 单元 | ✅/⏭ | N | N | - |
| 2 覆盖 | ✅/⏭ | 总体 XX% | N 模块未达标 | - |
| 3 E2E | ✅/⏭ | N | N | - |

意图/AC 交叉（若 speckit.implement 的 Step 9e 产生过数据，汇总在此）：
| FR | 意图满足 | 测试覆盖 |
|----|---------|---------|
| FR-001 | ✅/⚠️/❌ | ✅/⚠️/❌ |
```

### R2. GO / NO-GO 判定

**GO 条件**（全部满足）：
- Round 1：无 Fail（或 Fail 已全部修复）
- Round 2：总覆盖率 ≥ 80%（或跳过已明确登记）
- Round 3：无 Fail（或 Fail 已全部修复，含待用户手动确认全部 ✅）
- 无实现盲区（Round 2 识别的 🕳 全部已补 task 或明确跳过）

**GO 输出**：
```
✅ GO — 三轮对抗性测试全部通过。
   本次 implement 可进入 /save 存档。
```

**NO-GO 条件**（任一触发）：
- 任何 Round 有未修复 Fail
- Round 2 总覆盖率 < 80% 且未明确跳过
- Round 2 识别出实现盲区且未补 task
- Round 3 有待用户手动但未回报

**NO-GO 输出**：
```
❌ NO-GO — 测试未通过，必须修复以下项后重新运行 /speckit.test：

  阻塞项（按优先级）：
  1. [Round X] <具体问题>
  2. [Round X] <具体问题>
  ...

  修复路径：
  - 回到 /speckit.implement 修复现有 task
  - 或调用 /speckit.tasks 新增 task 覆盖实现盲区
  - 或在 tasks.md 的 ## Skipped Tasks 中登记不实现原因

  禁止运行 /save。
```

### R3. 探索性建议（无论 GO / NO-GO 都输出）

**至少 3 条**。合并 Round 1/3 产出的探索性建议，去重后列出：

```
💡 探索性测试建议（需手动验证或后续补齐）：
  1. <场景> — 优先级 High/Med/Low
  2. <场景>
  3. <场景>
  ...

注：即使 GO，这些场景仍建议在下次迭代或 bug 修复时补充自动化测试。
```

### R4. 下一步提示

- **GO**：提示 `运行 /save 存档本功能；或先 /commit 后 /save`
- **NO-GO**：提示 `修复后重新运行 /speckit.test`；禁止提示 /save

## 人格恢复

终裁输出完毕后，本命令结束。若用户继续调用 /speckit.implement 修复，implement 的 Step 0 会重新加载 backend 人格——无需在此主动切换。
