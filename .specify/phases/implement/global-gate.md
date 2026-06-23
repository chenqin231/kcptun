# speckit.implement — 全局验收门控（Step 10）

> 所属命令：speckit.implement | 阶段：所有任务完成后自动触发

## Step 10: Global Acceptance Gate

**触发条件**：tasks.md 中不存在任何 `- [ ]`（即所有非跳过任务已完成）。
跳过的任务须已在 `## Skipped Tasks` 表中登记，否则视为未完成。

### Step 10a — 计算覆盖状态（纯内存，不 Read 文件）

tasks.md 已在 Step 3 加载到上下文，直接在上下文中扫描，**无需重新 Read**：
- 遍历 `## Requirements Coverage Matrix` 的每一行
- 对该行 "Covered By" 列的所有 Task ID，检查 tasks.md 中对应行是否为 `[x]`
- 全部 `[x]` → 该需求状态为 ✅
- 该需求在 `## Skipped Tasks` 中有记录 → 状态为 ⏭
- 其余情况 → 状态为 ⬜
- **一次性批量计算所有行后，执行唯一一次 Edit** 更新矩阵 Status 列（禁止逐行 Edit）

### Step 10b — 输出覆盖率报告

```
## Global Acceptance Report

| Requirement | Tasks | Status |
|-------------|-------|--------|
| FR-001: ... | T010, T012 | ✅ |
| FR-002: ... | T015 | ✅ |
| FR-003: ... | T021 | ⬜ ← 未完成 |

覆盖率：X / Y（已完成需求 / 总需求数）
```

### Step 10b2 — Cross-Persona Review（交叉审查）

对抗工程师乐观偏差：临时切换人格，以不同视角审视本次 implement 的全部改动。

1. **临时人格切换**：Read `.agent/personas/code-reviewer.md`，从"我是代码审查员"的身份出发（**不是**"我这个后端工程师去审查自己"）
2. **审查范围**：本次 implement 在 worktree 分支上的所有 commit diff（`git log <BASE>..HEAD` + `git diff <BASE>..HEAD`）
3. **审查要点**：
   - 代码质量（重复、复杂度、命名）
   - 与 spec.md 设计意图的一致性（是否有 tasks 分解时遗漏但实现阶段才暴露的盲区）
   - 潜在 Bug、边界条件、并发/竞态问题
   - 错误处理和防御性编程是否到位
4. **输出**：
   ```
   🔎 交叉审查结论：
   - 通过项：...
   - 建议项（N 条）：... （可进入 10c）
   - 阻塞项（N 条）：... （必须修复后重跑 10b2）
   ```
5. **恢复人格**：审查完毕后恢复 backend 人格继续 Step 10c

### Step 10c — 门控判定

- **全部 ✅ 或 ⏭ 且交叉审查无阻塞项**（覆盖率 100%）:
  ```
  ✅ 全局验收通过 — 所有需求已覆盖，交叉审查无阻塞。
  💡 建议运行 /speckit.test 执行三轮对抗性测试（单元/覆盖/E2E），确认实现质量后再 /save。
  ```

- **存在 ⬜ 或交叉审查有阻塞项**:
  `❌ 全局验收未通过，以下需求未完全覆盖 / 审查有阻塞：...`
  `请补充实现或在 Skipped Tasks 中登记跳过原因；修复阻塞项后重跑 10b2 + 10c。禁止运行 /save。`

**注意**：如果 tasks.md 不含 `## Requirements Coverage Matrix`（旧格式），Step 10 降级为：
检查每个带 `[US?]` 标签的任务是否全部 `[x]`，按 User Story 分组汇总，输出完成率报告。

Note: This command assumes a complete task breakdown exists in tasks.md. If tasks are incomplete, suggest running `/speckit.tasks` first.
