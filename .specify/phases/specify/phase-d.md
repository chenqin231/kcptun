# speckit.specify — Phase D: 用户旅程分析

> 所属命令：speckit.specify | 阶段：D
> 职责：绘制选定方案下的完整用户路径，确定每步的新增/优化/现有状态。

D.1. **Map the complete user journey** for the selected solution direction:
   - List every step the user takes from start to goal completion
   - For each step, classify:
     - 🆕 **New** — feature does not exist yet
     - 🔧 **Improve** — feature exists but experience is poor or missing
     - ✅ **Existing** — already works well, no change needed

D.2. **Overall UX requirements** (journey-level):
   - Describe end-to-end experience quality goals that span **multiple steps**
   - Examples: "Complete entire flow in under 3 taps", "No step requires user to leave the app"
   - These govern the whole journey, NOT a single feature

**[STOP — MANDATORY]** Present journey map + overall UX requirements, ask:
"【Phase D: User Journey】Does this journey reflect the intended flow? Any steps missing or unnecessary?"

**[STOP] 确认后**：将确认的用户旅程和整体 UX 需求写入 SPEC_FILE 的 §User Journey 章节，然后 Read `.specify/phases/specify/phase-e.md`。
