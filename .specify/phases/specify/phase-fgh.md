# speckit.specify — Phase F-H: 范围 + 假设 + 验收标准

> 所属命令：speckit.specify | 阶段：F, G, H
> 职责：定义边界、记录前提、设定可衡量的成功指标。

**前置加载**：执行 Phase H 前，Read `.specify/rules/sc-rules.md`。

---

## Phase F: 需求范围与边界

F.1. **Explicitly define**:
   - ✅ **In Scope**: what this feature WILL do (based on confirmed FRs)
   - ❌ **Out of Scope**: what this feature will NOT do
     - Be specific — address things users might commonly assume are included
     - If user mentioned anything during discovery that was ruled out, list it here

**[STOP — MANDATORY]** Present scope boundaries, ask:
"【Phase F: Scope】Does this correctly define what's in and out of scope? Any common assumptions we missed?"

**[STOP] 确认后**：将范围内容写入 SPEC_FILE 的 §Scope 章节。

---

## Phase G: 假设与约束

G.1. **List preconditions and constraints**:
   - **Prerequisites**: what must already be true for this feature to work?
     (e.g., "User must be logged in", "User must have completed identity verification")
   - **Constraints**: known limitations affecting the feature
     (e.g., "须在现有导航栏框架内实现，不新增顶级菜单")

**[STOP — MANDATORY]** Present assumptions and constraints, ask:
"【Phase G: Assumptions】Any missing preconditions or constraints?"

**[STOP] 确认后**：将假设与约束写入 SPEC_FILE 的 §Assumptions & Constraints 章节。

---

## Phase H: 验收标准（成功标准）

H.1. **Derive success criteria** from confirmed FRs and overall UX requirements:
   - Each criterion must be **measurable** (specific metrics: time, steps, percentage, count)
   - Must be **technology-agnostic** (no frameworks, languages, databases)
   - Must be **user-focused** (outcome from user/business perspective)
   - Must be **verifiable** without knowing implementation details
   - 遵循 `.specify/rules/sc-rules.md` 中的 SC 必备结构和可追溯性规则

**[STOP — MANDATORY]** Present success criteria, ask:
"【Phase H: Success Criteria】Do these criteria accurately measure whether the feature achieves its goals?"

**[STOP] 确认后**：将成功标准写入 SPEC_FILE 的 §Success Criteria 章节，然后 Read `.specify/phases/specify/finish.md`。
