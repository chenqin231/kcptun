# speckit.specify — Phase E: 功能需求分析

> 所属命令：speckit.specify | 阶段：E
> 职责：为旅程中每个🆕/🔧步骤定义用户可理解的功能需求。禁止包含任何技术实现内容。

**前置加载**：执行本阶段前，Read 以下共享规则：
- `.specify/rules/fr-content-check.md`
- `.specify/rules/ac-quality.md`
- `.specify/rules/ac-coverage.md`

## E.1. 功能需求定义

**For each 🆕 New or 🔧 Improve step in the journey**, define one FR:

```
FR-[NNN]: [Journey Step Name]

Feature: [What the user can do — in user language, e.g., "Pay with WeChat Pay"]

Acceptance Criteria:
- [Measurable, verifiable outcome]

Priority: P0 Must / P1 Should / P2 Could / P3 Won't this time

UI Requirements (if UI involved):
- [Interface elements: fields, buttons, labels, display content]
- Empty state: [what user sees when no data exists]
- Loading state: [what user sees during processing]
- Success state: [what user sees on completion]
- Error state: [what user sees on failure + how to recover]

UX Requirements (if UI involved):
- [Interaction flow within this feature: steps, transitions, auto-behaviors]

Prototype (if UI involved):
[ASCII 字符画原型草图，展示关键布局和交互元素]
```

**Prototype 规则**（当 FR 涉及 UI 时强制）：
- AI 主动绘制 ASCII 原型草图，仅需核心布局，不追求精细度
- 向用户确认后写入 spec；用户要求调整则修改后再确认

**写 FR 时**：对每条 FR 应用 `fr-content-check.md` 规则。
**写 AC 时**：对每条 AC 应用 `ac-quality.md` 规则。
**写完每个 FR 后**：对照 `ac-coverage.md` 检查三维覆盖。

## E.2. 非功能需求

根据功能特征，从以下 6 项中筛选适用项，一次性向用户确认（不适用的从 spec 中删除）：

| NFR 项 | 示例（用户/业务语言） | 典型适用场景 |
|--------|---------------------|-------------|
| **Security** | "支付数据不得在浏览器历史或日志中可见" | 涉及敏感数据、认证、权限 |
| **Availability** | "网络不稳定时功能需优雅降级" | 移动端、弱网环境、高可用要求 |
| **Compliance** | "须符合当地金融数据法规" | 涉及法规、行业标准、数据合规 |
| **Performance** | "列表页加载时间 ≤2 秒（1000 条数据）" | 大数据量、高并发、实时交互 |
| **Upgrade** | "从 V3.x 升级后，已有配置自动迁移" | 版本升级、数据迁移、向后兼容 |
| **Compatibility** | "支持 Chrome 90+、Firefox 88+、Edge 90+" | 多浏览器、多平台、多设备 |

Rules:
- 使用用户/业务语言描述，禁止技术实现细节
- 每项 NFR 必须包含可量化或可验证的指标（遵循 AC 质量规则）
- 用户确认不适用的项从 spec 中完全删除（不留 N/A）

**[STOP — MANDATORY]** Present all FRs grouped by journey step + NFR list, ask:
"【Phase E: Functional Requirements】Any missing requirements or adjustments to priority? Are the non-functional requirements complete?"

**[STOP] 确认后**：将确认的 FR 列表和 NFR 写入 SPEC_FILE 的 §Functional Requirements 和 §Non-Functional Requirements 章节，然后 Read `.specify/phases/specify/phase-fgh.md`。
