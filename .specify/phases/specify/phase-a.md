# speckit.specify — Phase A: 用户问题挖掘

> 所属命令：speckit.specify | 阶段：A
> 职责：明确用户真实问题，禁止讨论任何解决方案。

**⛔ 禁止读代码**：本阶段只与用户对话，不得 Read/Grep/Glob/Explore 任何项目源码。"了解现状"通过提问用户完成，不是读代码。

A.1. **Elicit user problem** — present the following structure and ask user to confirm or fill in gaps:

   - **Scene**: In what context / situation does this occur?
   - **Pain Point**: What problem or friction does the user encounter?
   - **Goal**: What outcome does the user want to achieve?
   - **User's Idea** *(reference only, NOT a requirement)*: How does the user think it could be solved?

   Rules:
   - If any item is unclear, ask a focused question before proceeding
   - Do NOT treat the user's idea as the solution — it is input for brainstorming only

**[STOP — MANDATORY]** Present the filled structure, ask:
"【Phase A: User Problem】Does this accurately capture the user problem? Reply OK to confirm or describe adjustments."

**[STOP] 确认后**：将确认的用户问题内容写入 SPEC_FILE 的 §Overview / §User Problem 章节，然后 Read `.specify/phases/specify/phase-b.md`。
