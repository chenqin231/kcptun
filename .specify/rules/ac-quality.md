# AC 质量规则（AC Quality Rules）

> 每条 AC 定稿前必须通过以下全部检查。

## 黑名单词汇（出现即重写）

- **模糊动词**: 优化/加强/完善/改进/提升/增强/确保/支持/处理/enhance/optimize/improve/ensure/handle
- **模糊范围**: 全面/整体/相关/适当/合理/充分/必要时/comprehensive/overall/appropriate
- **模糊程度**: 更好/更快/更安全/高性能/高可用/良好体验/better/faster/good/robust
- **无终态动词**: 实现XX功能/做好XX/搞定XX/implement XX feature

## 必备结构（每条 AC 至少含一项）

- 具体数字（时间、数量、百分比、步骤、字符数、大小）
- 二元条件（能/不能、出现/消失、存在/不存在、启用/禁用）
- 可观察的状态转换（从状态 A 到状态 B）
- 具体输入 → 具体输出映射

## 改写参考表

| ❌ 禁止写法 | ✅ 必须改写为 |
|-------------|--------------|
| 优化查询性能 | 列表页加载时间 ≤2 秒（当前基线: X 秒） |
| 全面实现用户管理功能 | 用户可完成注册、登录、修改密码三个操作 |
| 加强安全性 | 连续 5 次登录失败后账户锁定 15 分钟 |
| 确保数据完整性 | 订单创建失败时已扣库存在 30 秒内自动回滚 |
| 提升用户体验 | 表单提交后 ≤1 秒显示结果，无整页刷新 |
| 支持多语言 | 支持中文和英文切换，切换后 ≤0.5 秒完成渲染 |
| Improve performance | Response time ≤ 200ms at P95 under 100 concurrent users |
| Ensure data safety | Failed transaction rolls back all mutations within 30 seconds |

→ 含黑名单词或缺必备结构：**重写后再继续**。
