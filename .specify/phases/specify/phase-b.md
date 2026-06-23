# speckit.specify — Phase B: 竞品与行业分析

> 所属命令：speckit.specify | 阶段：B
> 职责：了解市场现状和用户可感知的效果参考，禁止描述技术实现。

B.1. **Determine analysis type** based on feature nature:

   | Feature Type | Analysis Mode |
   |--------------|---------------|
   | New feature / system-level development | **Mandatory** — full competitive analysis |
   | Optimization of existing feature | **Optional** — ask user: "Would you like a competitive analysis for reference?" |
   | Mature / commodity feature (e.g., auto-update, login) | **Industry best practice** — skip to B.3 |

B.2. **For mandatory or user-opted analysis**:
   - Research 2-4 comparable products in the same domain
   - For each: describe what the **user experiences** (NOT how it is built)
   - Identify differentiation opportunities: what gap exists that this feature could fill?

   **[STOP — MANDATORY]** Present findings, ask:
   "【Phase B: Competitive Analysis】Any adjustments to the competitive landscape or differentiation direction?"

B.3. **For mature/commodity features** (skip B.2):
   - Describe the industry-standard **user-perceivable outcome** only
   - Example: "User opens app, sees update prompt, taps install, app restarts with new version — no manual steps required"
   - Do NOT describe technology, protocols, or architecture

   **[STOP — MANDATORY]** Present the industry practice description, ask:
   "【Phase B: Industry Reference】Does this industry-standard experience match the effect you want to achieve? Reply OK or describe adjustments."

**[STOP] 确认后**：将确认的竞品/行业分析内容写入 SPEC_FILE 的 §Competitive Analysis 章节，然后 Read `.specify/phases/specify/phase-c.md`。
