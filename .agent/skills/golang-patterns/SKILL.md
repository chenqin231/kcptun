---
name: golang-patterns
description: Idiomatic Go patterns, best practices, and conventions for building robust, efficient, and maintainable Go applications.
triggers:
  keywords:
    primary: [golang, go, goroutine, channel]
    secondary: [go mod, gofmt, golangci-lint, errgroup]
  context_boost: [.go, go.mod, go.sum]
  context_penalty: [.ts, .tsx, .py, .rs]
  priority: high
tier: optional
stacks: [go]
---

# Go Development Patterns

Idiomatic Go patterns and best practices for building robust, efficient, and maintainable applications.

## 参考资源

| 主题 | 说明 | 文件 |
|------|------|------|
| 核心原则 | 简洁性、零值设计、接口/结构体使用 | [core-principles.md](references/core-principles.md) |
| 错误处理 | 错误包装、自定义错误、errors.Is/As | [error-handling.md](references/error-handling.md) |
| 并发模式 | Worker Pool、Context、errgroup、优雅关闭 | [concurrency.md](references/concurrency.md) |
| 接口设计 | 小接口、消费者定义、类型断言 | [interface-design.md](references/interface-design.md) |
| 包组织与命名 | 项目布局、包命名、变量/函数/常量命名 | [package-and-naming.md](references/package-and-naming.md) |
| 结构体与性能 | Functional Options、组合、内存优化 | [struct-and-performance.md](references/struct-and-performance.md) |
| 安全最佳实践 | SQL/命令注入、路径遍历、TLS、密钥管理 | [security.md](references/security.md) |
| 工具与速查 | go 命令、linter 配置、惯用法、反模式 | [tooling-and-reference.md](references/tooling-and-reference.md) |
