# speckit.checklist — 生成规则 + 分类结构

> 所属命令：speckit.checklist | 阶段：生成

## 5. Generate Checklist — "Unit Tests for Requirements"

- Create `FEATURE_DIR/checklists/` directory if it doesn't exist
- Generate unique filename based on domain (e.g., `ux.md`, `api.md`, `security.md`)
- Number items sequentially starting from CHK001
- Each `/speckit.checklist` run creates a NEW file (never overwrites)

### CORE PRINCIPLE — Test the Requirements, Not the Implementation

Every checklist item MUST evaluate the REQUIREMENTS THEMSELVES for:
- **Completeness**: Are all necessary requirements present?
- **Clarity**: Are requirements unambiguous and specific?
- **Consistency**: Do requirements align with each other?
- **Measurability**: Can requirements be objectively verified?
- **Coverage**: Are all scenarios/edge cases addressed?

### Category Structure

- **Requirement Completeness** / **Requirement Clarity** / **Requirement Consistency**
- **Acceptance Criteria Quality** (happy-path / error-path / message-feedback)
- **Scenario Coverage** / **Edge Case Coverage**
- **Non-Functional Requirements** / **Dependencies & Assumptions** / **Ambiguities & Conflicts**

### Item Structure

- Question format asking about requirement quality
- Include quality dimension in brackets [Completeness/Clarity/Consistency/etc.]
- Reference spec section `[Spec §X.Y]` when checking existing requirements
- Use `[Gap]` marker when checking for missing requirements

### 🚫 ABSOLUTELY PROHIBITED

- ❌ "Verify", "Test", "Confirm", "Check" + implementation behavior
- ❌ References to code execution, user actions, system behavior
- ❌ "Displays correctly", "works properly", "functions as expected"
- ❌ "Click", "navigate", "render", "load", "execute"

### ✅ REQUIRED PATTERNS

- ✅ "Are [requirement type] defined/specified/documented for [scenario]?"
- ✅ "Is [vague term] quantified/clarified with specific criteria?"
- ✅ "Are requirements consistent between [section A] and [section B]?"

### Traceability

- MINIMUM: ≥80% of items MUST include ≥1 traceability reference
- Use: `[Spec §X.Y]`, `[Gap]`, `[Ambiguity]`, `[Conflict]`, `[Assumption]`

### Content Consolidation

- Soft cap: If raw candidates > 40, prioritize by risk/impact
- Merge near-duplicates; consolidate low-impact edge cases

## 6. Structure Reference

Use `.specify/templates/checklist-template.md` for title, meta, category headings, and ID formatting.

**生成完成后**，Read `.specify/phases/checklist/examples.md` 输出示例和报告。
