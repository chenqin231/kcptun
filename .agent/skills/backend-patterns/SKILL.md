---
name: backend-patterns
description: Backend architecture patterns, API design, database optimization, and server-side best practices for Node.js, Express, and Next.js API routes.
triggers:
  keywords:
    primary: [backend, API, server, database, REST]
    secondary: [middleware, repository, service, cache, Redis]
  context_boost: [NextApiHandler, NextResponse, supabase, Express, JWT]
  context_penalty: [frontend, React, CSS, animation, component]
  priority: high
---

# Backend Development Patterns

Backend architecture patterns and best practices for scalable server-side applications.

## 参考资源

| 主题 | 说明 | 文件 |
|------|------|------|
| API 设计 | RESTful、Repository、Service Layer、Middleware 模式 | [api-design.md](references/api-design.md) |
| 数据库模式 | 查询优化、N+1 防护、事务处理 | [database-patterns.md](references/database-patterns.md) |
| 缓存策略 | Redis Caching Layer、Cache-Aside 模式 | [caching-strategies.md](references/caching-strategies.md) |
| 错误处理 | 集中式错误处理、指数退避重试 | [error-handling.md](references/error-handling.md) |
| 认证/限流/队列/日志 | JWT、RBAC、Rate Limiting、Job Queue、Structured Logging | [auth-ratelimit-jobs-logging.md](references/auth-ratelimit-jobs-logging.md) |
