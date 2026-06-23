# speckit.implement — 单任务验证（Step 9）

> 所属命令：speckit.implement | 阶段：每任务完成后自动执行

## Step 9: Completion Validation

每个任务实现完成后自动执行，无需用户手动触发。

### Step 9a — AC 对照（Acceptance Criteria Check）

Read the current task's AC list from tasks.md. For each AC item, display:
```
✅ AC1: <AC 描述> — 已实现
❌ AC2: <AC 描述> — 未实现（原因：<说明>）
```
If the task has no AC defined, skip and note: `（无 AC 定义，跳过对照）`

### Step 9b — 测试命令执行（Test Execution）

Detect the project's test command using this priority:
1. Check tasks.md for an explicit test command in the current task
2. Check `package.json` → `scripts.test`
3. Check `Makefile` → `test` target
4. Check for `bats tests/` (if `.bats` files exist)
5. Check for `pytest`, `go test ./...`, `cargo test`, etc.

Execute the detected test command and display **actual output** verbatim.
Do NOT declare "tests pass" without running them.

### Step 9c — Lint/格式检查（Lint Check）

- `shellcheck` for `.sh` files modified in this task
- `eslint` / `tsc` for TypeScript/JavaScript
- `flake8` / `mypy` for Python
- `go vet ./...` for Go
- Skip if no linter is configured; note: `（无 Lint 配置）`

### Step 9e — Spec Intent Check（需求回溯）

AC checkbox 只能证明"做了"，不能证明"满足需求意图"。本步对抗工程师乐观偏差。

1. 从 tasks.md 的 `## Requirements Coverage Matrix` 找到当前任务映射的 FR/AC 编号（例如 FR-001、AC-002）
2. Read `specs/<BRANCH>/spec.md`，定位对应 FR/AC 的**原文段落**
3. 对照本任务实现，逐一回答：**在意图层面**是否满足该 FR？例如 FR 要求"用户可导出 PDF"，实现只生成了 `.txt` 文件 → 意图未满足，即使 AC「点击导出按钮可下载文件」checkbox 通过
4. 输出格式：
   ```
   🎯 FR-001: <原文摘要> — ✅ 意图满足
   🎯 FR-002: <原文摘要> — ⚠️ 偏差：<具体偏差点>
   🎯 FR-003: <原文摘要> — ❌ 意图未满足：<说明>
   ```
5. 若当前任务 tasks.md 未映射任何 FR/AC，输出 `（无需求映射，跳过意图回溯）` 并在 Verdict 中标记"意图未验证"

### Step 9d — 验证结论（Verdict）

- **双 None**（AC 无定义 + 无测试配置）:
  `⚠️ 无 AC 和测试配置，建议手动验证功能正确性。可运行 /save 存档本任务。`

- **全通过**（所有 AC ✅ + 测试通过 + Lint 通过 + 意图全部 ✅）:
  `✅ 验证通过 — AC 全部实现，测试通过，Lint 通过，需求意图满足。继续下一个任务。`

- **有失败项或意图偏差**:
  `❌ 验证未通过，列出失败项（含意图 ⚠️/❌ 项）：...`
  Do NOT prompt `/save`. Do NOT continue to the next task automatically. 意图偏差必须修复或升级为新任务。

---

## 验证后的下一步

- **验证通过** → 返回 `load-and-execute.md` 继续执行下一个任务
- **验证失败** → 修复问题后重新执行本文件的 Step 9 验证流程
- **所有任务均标记 [x]** → Read `.specify/phases/implement/global-gate.md` 执行全局验收
