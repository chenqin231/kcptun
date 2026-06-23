# speckit.specify — Phase C: 方案发散与决策

> 所属命令：speckit.specify | 阶段：C
> 职责：从用户体验角度发散多个方向并决策，禁止讨论技术实现细节。

C.1. **Generate multiple solution directions** — based on confirmed user problem and Phase B findings:
   - Propose 2-4 distinct solution directions
   - For each direction, describe from the **user's perspective**: what would the experience be like?
   - Evaluate each on two dimensions:
     - **Implementation cost**: Low / Medium / High *(expressed as user-understandable effort, e.g., "requires building a new flow from scratch")*
     - **Journey complexity**: how many steps does the user go through?

   Rules:
   - Use the `brainstorm` skill to support creative divergence if needed
   - Focus on **user experience differences** between options — NOT technical differences

   **[STOP — MANDATORY]** Present options in a comparison table, ask:
   "【Phase C: Solution Options】Which direction aligns with your goals? Or would you like to explore a combination?"

C.2. Record the selected direction with rationale. This feeds into Phase D.

**[STOP] 确认后**：将选定方案及理由写入 SPEC_FILE 的 §Solution Direction 章节，然后 Read `.specify/phases/specify/phase-d.md`。
