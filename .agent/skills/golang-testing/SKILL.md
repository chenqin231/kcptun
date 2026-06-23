---
name: golang-testing
description: Go 测试模式：table-driven tests / subtests / benchmarks / fuzzing / 覆盖率，遵循 TDD 和惯用 Go 实践。
triggers:
  keywords:
    primary: [go test, golang test, table driven, benchmark go]
    secondary: [t.Run, t.Helper, fuzzing, testify, httptest]
  context_boost: [test, testing, coverage, benchmark]
  context_penalty: [frontend, python, pytest]
  priority: high
tier: optional
stacks: [go]
---

# Go Testing Patterns

Go 测试全流程指南，含 TDD、table-driven tests、subtests、benchmarks、fuzzing。

## 参考资源

| 主题 | 说明 | 文件 |
|------|------|------|
| TDD 与表驱动测试 | RED-GREEN-REFACTOR 流程 + table-driven tests（含错误用例） | [tdd-and-table-driven.md](references/tdd-and-table-driven.md) |
| Subtests 与 Helpers | 子测试组织 / 并行测试 / Helper 函数 / 临时文件 / Golden Files | [subtests-helpers-golden.md](references/subtests-helpers-golden.md) |
| 接口 Mock | interface-based mocking 模式 + 生产/Mock/测试完整示例 | [mocking-interfaces.md](references/mocking-interfaces.md) |
| Benchmark 与 Fuzzing | 基准测试 / 内存分配 / Fuzz 测试 / 覆盖率命令与目标 | [benchmarks-fuzzing-coverage.md](references/benchmarks-fuzzing-coverage.md) |
| HTTP 测试与 CI | httptest Handler 测试 / go test 命令速查 / 最佳实践 / CI 配置 | [http-testing-commands-ci.md](references/http-testing-commands-ci.md) |
