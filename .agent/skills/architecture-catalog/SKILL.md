---
name: architecture-catalog
description: 架构模式选型百科：9 种架构模式对比（单体/微服务/事件驱动/Serverless/Clean/DDD/Hexagonal/模块化单体/Strangler Fig），含决策树、演进路径、ADR 模板。
triggers:
  keywords:
    primary: [architecture, microservices, monolith, serverless, event-driven, ddd]
    secondary: [hexagonal, clean architecture, cqrs, saga, domain driven, modular]
  context_boost: [design, structure, enterprise, scale]
  context_penalty: [frontend, css, ui]
  priority: high
---

# Architecture Patterns Catalog

9 种架构模式对比选型百科，含决策树、演进路径、ADR 模板。

## 参考资源

| 主题 | 说明 | 文件 |
|------|------|------|
| 基础模式 | Monolith / Microservices / Event-Driven / Serverless | [patterns-basic.md](references/patterns-basic.md) |
| 高级模式 | Clean / DDD / Hexagonal / Modular Monolith / Strangler Fig / BFF | [patterns-advanced.md](references/patterns-advanced.md) |
| 决策指南 | 选型决策树 + 常见陷阱 + 模式对比表 | [decision-guide.md](references/decision-guide.md) |
| ADR 与演进 | ADR 模板 + 演进路径 + 反模式 + 性能/测试策略 | [adr-evolution-antipatterns.md](references/adr-evolution-antipatterns.md) |
