# speckit.specify — Finish（写入 + 自检 + 报告）

> 所属命令：speckit.specify | 阶段：完成

## Step 2: 验证 Spec 完整性

由于各阶段已增量写入 SPEC_FILE，此步骤仅做 **Read + 自检 + 修补**（非从头生成）。

Read SPEC_FILE，对照以下检查项逐一验证：

1. **User language**: Is every FR written in terms a non-technical stakeholder can understand? (technical terms found → rewrite)
2. **AC quality gate** (three sub-checks, ALL must pass):
   - 2a. **Blacklist scan**: Does any AC contain blacklisted vague words (优化/加强/完善/improve/ensure/etc.)? → found = rewrite immediately
   - 2b. **Quantification check**: Does every AC have a specific number, binary condition, or state transition? → missing = add concrete metric
   - 2c. **Single-interpretation test**: Can two different people read this AC and independently agree on pass/fail without discussion? → ambiguous = rewrite with concrete outcome
3. **AC coverage gate** (three sub-checks, ALL must pass):
   - 3a. **Happy path**: Does every FR have ≥1 AC describing normal operation with 操作→结果→反馈? → missing = add
   - 3b. **Error path**: Does every FR have ≥1 AC describing abnormal operation with 异常条件→系统行为→反馈→恢复方式? → missing = add
   - 3c. **Message specificity**: Does every AC specify concrete feedback (形式 + 文案 + 时机), NOT vague "显示提示/show message"? → vague = rewrite with exact form, text, timing
4. **No HOW**: Does any FR describe implementation approach, technology, or code structure? (found → remove immediately)
5. **UI/UX/Prototype completeness**: For UI features, does each FR have UI Requirements, UX Requirements, and Prototype filled? (missing → add)
6. **Scope alignment**: Does every FR map to a journey step marked 🆕 or 🔧? (orphan FR → verify necessity)
7. **Boundary coverage**: Does Out of Scope address at least 2 things users might assume are included? (too thin → expand)
8. **Success criteria traceability**: Does each SC trace back to at least one FR or overall UX requirement? (orphan SC → verify)
9. **NFR quantification**: Does every NFR item contain a measurable metric or verifiable condition? (vague → rewrite with concrete indicator)

Items marked `NEEDS CLARIFICATION` → suggest running `/speckit.clarify`.

## Step 3: Report

Report completion with:
- Branch name
- Spec file path
- Readiness for next phase (`/speckit.clarify` if NEEDS CLARIFICATION items exist, otherwise `/speckit.plan`)

**NOTE:** The script initializes the spec directory and file. The git branch and worktree are created later during `/speckit.implement`.
