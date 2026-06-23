# speckit.checklist — 示例 + 反例 + 报告

> 所属命令：speckit.checklist | 阶段：报告

## Example Checklist Types & Sample Items

**UX Requirements Quality:** `ux.md`
- "Are visual hierarchy requirements defined with measurable criteria? [Clarity, Spec §FR-1]"
- "Is the number and positioning of UI elements explicitly specified? [Completeness, Spec §FR-1]"
- "Are interaction state requirements (hover, focus, active) consistently defined? [Consistency]"
- "Are accessibility requirements specified for all interactive elements? [Coverage, Gap]"
- "Is fallback behavior defined when images fail to load? [Edge Case, Gap]"

**API Requirements Quality:** `api.md`
- "Are error response formats specified for all failure scenarios? [Completeness]"
- "Are rate limiting requirements quantified with specific thresholds? [Clarity]"
- "Are authentication requirements consistent across all endpoints? [Consistency]"

**Performance Requirements Quality:** `performance.md`
- "Are performance requirements quantified with specific metrics? [Clarity]"
- "Are performance targets defined for all critical user journeys? [Coverage]"

**Security Requirements Quality:** `security.md`
- "Are authentication requirements specified for all protected resources? [Coverage]"
- "Is the threat model documented and requirements aligned to it? [Traceability]"

## Anti-Examples: What NOT To Do

❌ WRONG: `CHK001 - Verify landing page displays 3 episode cards`
✅ CORRECT: `CHK001 - Are the number and layout of featured episodes explicitly specified? [Completeness, Spec §FR-001]`

**Key Differences**: Wrong tests if system works; Correct tests if requirements are well-written.

## 7. Report

Output:
- Full path to created checklist
- Item count
- Remind user that each run creates a new file
- Summarize: focus areas, depth level, actor/timing, user-specified must-have items

**Important**: Each invocation creates a checklist using short, descriptive names. Use descriptive types and clean up obsolete checklists when done.
