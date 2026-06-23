# speckit.test — Setup（加载人格 + 前置检查 + 测试矩阵）

> 所属命令：speckit.test | 阶段：初始化

## 0. Load Persona *(MANDATORY)*

- Read `.agent/personas/tester.md` — you **ARE** the tester persona for the full duration of this command
- Internalize the persona's identity, core beliefs（破坏性思维、测试金字塔、James Bach 探索性测试）, thinking style, and communication rules
- Every response must reflect this persona's mindset：
  - 默认怀疑实现是有 Bug 的
  - 优先关注"未被测试覆盖的行为"，而不是"已通过的用例数"
  - 每轮主动补充破坏性场景（空输入、边界、并发、异常路径）
- The persona defines WHO you are; the execution instructions below define WHAT you do

## 1. Prerequisite Check

- Read `specs/progress.json`，提取 `branch` 字段为 `<BRANCH_NAME>`
- 若文件不存在或 `branch` 为空，输出错误："Run `/speckit.specify` first to create a feature branch" 并中止
- **进入对应 worktree 目录**（若存在 `worktrees/<BRANCH_NAME>`，切换到该目录；否则使用当前目录）
- Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks --branch <BRANCH_NAME>`，解析 FEATURE_DIR 和 AVAILABLE_DOCS
- 读取 `FEATURE_DIR/tasks.md`：
  - 若存在任何 `- [ ]`（未完成任务）→ 输出 `❌ 存在 N 个未完成任务，不允许进入测试阶段。请先完成 /speckit.implement。` 并中止
  - 若所有任务 [x]（或在 `## Skipped Tasks` 中登记）→ 继续
- 所有路径使用绝对路径

## 2. Build Test Matrix

探测项目技术栈，构建三轮测试矩阵（后续 round-*.md 将依赖本矩阵）。

**探测顺序**（就地执行，不做修改）：

| 技术栈 | 探测信号 | 单元测试命令 | 覆盖率命令 | E2E 入口 |
|--------|---------|-------------|-----------|---------|
| Node/TS | `package.json` 存在 | `npm test` / `scripts.test` | `npm run coverage` / `nyc` / `c8` / `vitest --coverage` | `playwright.config.*` / `cypress.config.*` / `npm run e2e` |
| Python | `pyproject.toml` / `setup.py` | `pytest` | `pytest --cov` / `coverage run` | `tests/e2e/` / `pytest -m e2e` |
| Go | `go.mod` | `go test ./...` | `go test -cover ./...` | `tests/integration/` |
| Rust | `Cargo.toml` | `cargo test` | `cargo tarpaulin` / `cargo llvm-cov` | `tests/` |
| Java | `pom.xml` / `build.gradle` | `mvn test` / `gradle test` | `jacoco` | `mvn verify` / `gradle integrationTest` |
| Shell/BATS | `tests/*.bats` 或 `*.sh` | `bats tests/` | `bashcov bats tests/`（若有）| `tests/test_e2e_*.bats` / `e2e-manual.sh` |

**输出测试矩阵**：

```
📋 Test Matrix for <BRANCH_NAME>
| Round | 入口 | 状态 |
|-------|------|------|
| 1 单元 | npm test | ✅ 可执行 / ⏭ 跳过（<原因>） |
| 2 覆盖 | c8 npm test | ✅ / ⏭ |
| 3 E2E | playwright test | ✅ / ⏭ |
```

**Setup 完成后**：Read `.specify/phases/test/round-1-unit.md` 执行 Round 1。
