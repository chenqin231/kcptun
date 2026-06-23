# Feature Specification: [FEATURE NAME]

**Feature Branch**: `[###-feature-name]`
**Created**: [DATE]
**Status**: Draft
**Input**: User description: "$ARGUMENTS"

---

## User Problem（用户问题）

<!-- Filled in Phase A. Describes the real-world context that motivated this feature. -->

- **Scene**: [In what context / situation does this occur?]
- **Pain Point**: [What problem or friction does the user encounter?]
- **Goal**: [What outcome does the user want to achieve?]
- **User's Idea** *(reference only)*: [How does the user think it could be solved? This is NOT the requirement.]

---

## Competitive / Industry Analysis（竞品与行业分析）

<!-- Filled in Phase B. Omit this section entirely if feature is a mature/commodity type with no competitive analysis performed. -->

### Competitor Observations

<!-- For each comparable product: describe what the USER EXPERIENCES, not how it works -->

| Product | User Experience | Strength | Weakness |
|---------|----------------|----------|---------|
| [Product A] | [What the user does / sees] | [What it does well] | [Where it falls short] |
| [Product B] | [What the user does / sees] | [What it does well] | [Where it falls short] |

### Differentiation Opportunity

[What gap exists that this feature could fill? Described from user value perspective, not technical capability.]

---

## Solution Decision（方案决策）

<!-- Filled in Phase C. Records the brainstormed options and the selected direction. -->

### Options Considered

| Option | User Experience Summary | Implementation Cost | Journey Complexity | Verdict |
|--------|------------------------|--------------------|--------------------|---------|
| Option A | [What the user experiences] | Low / Medium / High | [Steps count / complexity] | Selected / Rejected |
| Option B | [What the user experiences] | Low / Medium / High | [Steps count / complexity] | Selected / Rejected |

### Selected Direction

[Which option was chosen and why — from user value and feasibility perspective. No technical rationale.]

---

## User Journey（用户旅程）

<!-- Filled in Phase D. The complete path the user takes to achieve their goal. -->

### Journey Map

| # | Step | Type | Description |
|---|------|------|-------------|
| 1 | [Step name] | 🆕 New / 🔧 Improve / ✅ Existing | [What the user does at this step] |
| 2 | [Step name] | 🆕 New / 🔧 Improve / ✅ Existing | [What the user does at this step] |
| 3 | [Step name] | 🆕 New / 🔧 Improve / ✅ Existing | [What the user does at this step] |

### Overall UX Requirements（旅程级体验要求）

<!-- Cross-step experience goals that govern the entire journey -->

- [e.g., "Complete entire payment flow in under 3 taps"]
- [e.g., "User never needs to leave the app during the journey"]
- [e.g., "All error states must offer a clear recovery path without starting over"]

---

## Functional Requirements（功能需求）

<!-- Filled in Phase E. Only covers journey steps marked 🆕 or 🔧. -->
<!-- HARD CONSTRAINT: Every FR must be written in user-visible language.
     No technology names, no database fields, no API paths, no code structure. -->

### [Journey Step Name] — FR-001

**Feature**: [What the user can do, in user language. e.g., "Pay with WeChat Pay"]

**Acceptance Criteria**:

*正常操作路径（Happy Path）*:
- AC-001-H1: [操作] → [结果] → [反馈: 形式 + 文案 + 时机]
  - e.g., "用户点击'确认支付' → 支付成功 → 页面跳转至支付结果页，显示 Toast '支付成功' 持续 3 秒后自动消失"

*异常操作路径（Error Path）*:
- AC-001-E1: [异常条件] → [系统行为] → [反馈: 形式 + 文案 + 恢复方式]
  - e.g., "网络中断时点击'确认支付' → 支付不执行 → 页面显示 Modal 弹窗 '网络连接失败，请检查网络后重试'，用户点击'确定'关闭弹窗，返回支付页面可重新操作"
- AC-001-E2: [异常条件] → [系统行为] → [反馈: 形式 + 文案 + 恢复方式]
  - e.g., "余额不足时点击'确认支付' → 支付不执行 → 页面显示 Inline 提示 '余额不足，请充值后重试'，同时显示'去充值'按钮"

**Priority**: P0 Must / P1 Should / P2 Could / P3 Won't this time

**UI Requirements** *(if UI involved)*:
- [Interface elements: fields, buttons, labels, display content]
- Empty state: [What user sees when no data exists]
- Loading state: [What user sees during processing]
- Success state: [What user sees on completion]
- Error state: [What user sees on failure + how to recover]

**UX Requirements** *(if UI involved)*:
- [Interaction flow within this feature: steps, transitions, auto-behaviors]
- [e.g., "After entering card number, cursor auto-advances to expiry field"]
- [e.g., "Confirmation dialog appears before final submission"]

**Prototype（原型草图）** *(if UI involved)*:
<!-- AI 使用 ASCII 字符画绘制界面原型草图，展示关键布局和交互元素 -->
<!-- 仅需展示核心布局，不追求精细度。用户确认后保留，无 UI 时删除此节 -->

```
┌─────────────────────────────────────┐
│  [页面标题]                          │
├─────────────────────────────────────┤
│                                     │
│  ┌─────────┐  ┌─────────┐          │
│  │ 输入框   │  │ 按钮    │          │
│  └─────────┘  └─────────┘          │
│                                     │
│  ┌─────────────────────────────┐    │
│  │ 数据列表区域                 │    │
│  │ ├── 项目 1                  │    │
│  │ ├── 项目 2                  │    │
│  │ └── 项目 3                  │    │
│  └─────────────────────────────┘    │
└─────────────────────────────────────┘
```

---

### [Journey Step Name] — FR-002

**Feature**: [...]

**Acceptance Criteria**:

*正常操作路径（Happy Path）*:
- AC-002-H1: [操作] → [结果] → [反馈: 形式 + 文案 + 时机]

*异常操作路径（Error Path）*:
- AC-002-E1: [异常条件] → [系统行为] → [反馈: 形式 + 文案 + 恢复方式]

**Priority**: P0 / P1 / P2 / P3

**UI Requirements** *(if UI involved)*:
- [...]

**UX Requirements** *(if UI involved)*:
- [...]

**Prototype（原型草图）** *(if UI involved)*:
<!-- 同 FR-001 格式，AI 绘制 ASCII 字符画原型草图 -->

```
[ASCII 原型草图]
```

---

<!-- Add more FRs as needed, one per journey step -->

---

## Non-Functional Requirements（非功能需求）

<!-- 仅填写与本功能相关的项，不相关的删除。使用用户/业务语言描述，禁止技术实现细节。 -->

- **Security**: [e.g., "支付数据不得在浏览器历史或日志中可见"]
- **Availability**: [e.g., "网络不稳定时功能需优雅降级"]
- **Compliance**: [e.g., "须符合当地金融数据法规"]
- **Performance**: [e.g., "列表页加载时间 ≤2 秒（1000 条数据）"]
- **Upgrade**: [e.g., "从 V3.x 升级后，已有配置自动迁移，用户无需重新配置"]
- **Compatibility**: [e.g., "支持 Chrome 90+、Firefox 88+、Edge 90+；iOS 14+、Android 9+"]

---

## Scope & Boundaries（需求范围与边界）

<!-- Filled in Phase F. Be explicit — ambiguity here causes scope creep. -->

### In Scope ✅

- [What this feature WILL do]
- [What this feature WILL do]

### Out of Scope ❌

<!-- Address common assumptions explicitly. "Users might assume X is included — it is not." -->

- [Feature/behavior explicitly NOT included, and why]
- [Common assumption that is out of scope]
- [What will be addressed in a future iteration instead]

---

## Assumptions & Constraints（假设与约束）

<!-- Filled in Phase G. Preconditions that must be true for this feature to function. -->

### Preconditions

- [What must already exist or be true. e.g., "User must be logged in"]
- [e.g., "User must have completed identity verification before reaching this flow"]

### Constraints

- [Known limitations. e.g., "须在现有导航栏框架内实现，不新增顶级菜单"]
- [e.g., "不依赖用户额外安装独立应用"]

---

## Success Criteria（验收标准）

<!-- Measurable, technology-agnostic outcomes. Verifiable without implementation knowledge. -->

- **SC-001**: [e.g., "Users can complete payment in under 2 minutes from product page"]
- **SC-002**: [e.g., "95% of users successfully complete primary task on first attempt"]
- **SC-003**: [e.g., "Feature is available 99.9% of the time during business hours"]
