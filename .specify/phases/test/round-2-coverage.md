# speckit.test — Round 2：覆盖率

> 所属命令：speckit.test | 阶段：Round 2 of 3

## 目标

统计代码覆盖率，交叉对照 spec.md 的关键 FR/AC，**识别"测试盲区 vs 实现盲区"**——前者是测试不够，后者是代码根本没实现。

## 执行步骤

### 2a. 覆盖率工具入口

从 Setup 的测试矩阵中读取 Round 2 入口。若标记 `⏭ 跳过`（无覆盖率工具链），跳到 2d。

### 2b. 执行覆盖率统计

执行覆盖率命令，输出按模块/文件的覆盖率报告：

```
📈 Coverage Report
  Lines: XX% (目标 ≥ 80%)
  Branches: XX%
  Functions: XX%
  Statements: XX%

  按模块 Top-Down：
  | 模块 | Lines | Branches | 状态 |
  |------|-------|----------|------|
  | src/auth | 92% | 85% | ✅ |
  | src/payment | 64% | 48% | ⚠️ 低于阈值 |
  | src/utils | 100% | 100% | ✅ |
```

### 2c. 盲区交叉分析

对每个覆盖率 < 80% 的模块，**二选一判定**：

1. **测试盲区**：代码已实现，但测试未覆盖分支
   - 输出：`📍 <module> — 测试盲区。未覆盖分支：<line X>、<条件 Y>。建议补充测试：...`

2. **实现盲区**：代码根本没写该分支（可能是 tasks 分解漏了）
   - 输出：`🕳 <module> — 实现盲区。FR-XX 要求的 <具体行为> 未见对应实现代码。建议新建 task 补齐。`

交叉表（spec.md 关键 FR × 实际覆盖）：

```
| FR | 对应模块 | Lines | 判定 |
|----|---------|-------|------|
| FR-001 导出 PDF | src/export/pdf.js | 45% | 🕳 实现盲区：PDF 加密分支未实现 |
| FR-002 用户登录 | src/auth/login.js | 92% | ✅ 覆盖充分 |
```

### 2d. 跳过登记（无工具链时）

若 2a 标记跳过，本步输出：

```
⏭ Round 2 跳过：<原因，如"项目无覆盖率工具链">
📌 工具选型建议（按当前技术栈）：
  - Node/TS: c8 / vitest --coverage / nyc
  - Python: coverage.py / pytest-cov
  - Go: go test -cover / go tool cover
  - Rust: cargo-llvm-cov / tarpaulin
  - Java: JaCoCo
  - Shell/BATS: bashcov / kcov
```

### 2e. 本轮汇总

```
📊 Round 2 — 覆盖率
  执行：✅ / ⏭
  总体覆盖率：XX%（阈值 80%）
  达标模块：N / M
  测试盲区：N 项
  实现盲区：N 项
```

**Round 2 完成后**：Read `.specify/phases/test/round-3-e2e.md` 执行 Round 3。
