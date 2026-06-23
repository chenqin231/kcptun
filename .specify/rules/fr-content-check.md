# FR 纯度检查（FR Content Check）

> 每条 FR 定稿前必须通过此检查。违反项立即删除，归入 `/speckit.plan`。

**[HARD CONSTRAINT]** — FR 中禁止出现以下任何内容：

- 技术选型（Redis, REST, GraphQL, MySQL, JWT, OAuth...）
- 数据库结构（表名、字段名、索引...）
- API 设计（端点路径、HTTP 方法、请求/响应格式...）
- 模块或代码结构（service, controller, repository, class names...）
- 任何非技术利益相关者无法理解的实现细节

→ 发现任何一项：**立即删除**。它们属于 `/speckit.plan`。
