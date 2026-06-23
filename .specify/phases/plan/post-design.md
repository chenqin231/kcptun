# speckit.plan — Post-Design: 文件清单 + AC 验证设计

> 所属命令：speckit.plan | 阶段：Post-Design
> 前置条件：Phase 1 设计完成

## 4.8. File Structure Inventory (MANDATORY)

- **Purpose**: Prevent file bloat by planning file organization upfront (see `.claude/rules/modularity.md`)
- **Load language skill**: If not already loaded, load the project's language `*-patterns` skill
- **Generate file inventory table** in IMPL_PLAN:

  ```markdown
  ## File Structure Inventory

  | File Path | Responsibility (one line) | Est. Lines | New/Modify | Dependencies |
  |-----------|--------------------------|-----------|------------|-------------|
  ```

- **Validation checklist** (must pass before proceeding):
  - [ ] Every file estimated ≤ 300 lines (flag any exceeding)
  - [ ] Every file has exactly one primary responsibility
  - [ ] No circular dependencies between files
  - [ ] If ≥ 2 tasks modify the same file → marked as serial dependency
- **If any file > 300 lines**: STOP and split until all are ≤ 300, then update the table

## 4.9. AC Verification Design (MANDATORY)

- **Purpose**: Translate every spec AC into a concrete, executable technical verification
- **Input**: Read all FR Acceptance Criteria and Success Criteria from FEATURE_SPEC

- **Generate AC Verification Table** in IMPL_PLAN:

  ```markdown
  ## AC Verification Design

  | Spec AC | Coverage Type | Source | Verification Type | Technical Assertion | Verification Method |
  |---------|--------------|--------|------------------|--------------------|--------------------|
  ```

- **Coverage Type**: Happy / Error / Message
- **Verification type**: Unit test / Integration test / E2E test / Performance test / Manual verification
- **Validation rules** (must pass):
  - [ ] Every FR AC from FEATURE_SPEC has ≥1 row
  - [ ] Every SC from FEATURE_SPEC has ≥1 row
  - [ ] **Coverage balance**: Every FR must have ≥1 Happy row AND ≥1 Error row; FR with UI must have ≥1 Message assertion row
  - [ ] **Message assertion**: AC with Toast/Modal/Inline/Notification must include concrete text assertion
  - [ ] No "Technical Assertion" column contains vague words
  - [ ] Manual verification rows have explicit step-by-step procedure

- **If any spec AC cannot be translated**: Flag as `AC-DEFECT` and recommend returning to `/speckit.specify`

**Post-Design 完成后**：将文件清单和 AC 验证设计写入 IMPL_PLAN 对应章节，然后 Read `.specify/phases/plan/finish.md`。
