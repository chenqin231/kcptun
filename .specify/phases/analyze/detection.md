# speckit.analyze — 检测通道 A-G（跨文档）

> 所属命令：speckit.analyze | 阶段：检测（Part 1）

## 4. Detection Passes (Token-Efficient Analysis)

Focus on high-signal findings. Limit to 50 findings total; aggregate remainder in overflow summary.

### A. Duplication Detection
- Identify near-duplicate requirements
- Mark lower-quality phrasing for consolidation

### B. Cross-Document Ambiguity Detection
- Flag cross-document ambiguity: spec says A, plan says B
- Flag vague adjectives (fast, scalable, secure, intuitive, robust) lacking measurable criteria
- Flag unresolved placeholders (TODO, TKTK, ???, `<placeholder>`, etc.)

### C. Underspecification
- Requirements with verbs but missing object or measurable outcome
- User stories missing acceptance criteria alignment
- Tasks referencing files or components not defined in spec/plan

### D. Constitution Alignment
- Any requirement or plan element conflicting with a MUST principle
- Missing mandated sections or quality gates from constitution

### E. Coverage Gaps
- Requirements with zero associated tasks
- Tasks with no mapped requirement/story
- Non-functional requirements not reflected in tasks

### F. Inconsistency
- Terminology drift (same concept named differently across files)
- Data entities referenced in plan but absent in spec (or vice versa)
- Task ordering contradictions
- Conflicting requirements

### G. Cross-Document Traceability

**Requirement ↔ Design:**
- Every FR in spec.md has a corresponding design in plan.md
- Every design in plan.md traces back to a spec.md requirement (no gold-plating)

**Design ↔ Tasks:**
- Every design point in plan.md has a corresponding task in tasks.md
- Every task in tasks.md traces back to plan.md (no gold-plating)

**Concrete value consistency:**
- File paths, port numbers, URLs, config key names, entity/field names are consistent across all three documents

**检测通道 A-G 完成后**，Read `.specify/phases/analyze/sma-detection.md` 继续 SMA 质量检测。
