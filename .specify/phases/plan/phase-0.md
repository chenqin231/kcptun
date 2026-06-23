# speckit.plan — Phase 0: 大纲与研究

> 所属命令：speckit.plan | 阶段：Phase 0

## Phase 0: Outline & Research

1. **Extract unknowns from Technical Context** above:
   - For each NEEDS CLARIFICATION → research task
   - For each dependency → best practices task
   - For each integration → patterns task

2. **Generate and dispatch research agents**:

   ```text
   For each unknown in Technical Context:
     Task: "Research {unknown} for {feature context}"
   For each technology choice:
     Task: "Find best practices for {tech} in {domain}"
   ```

3. **Consolidate findings** in `research.md` using format:
   - Decision: [what was chosen]
   - Rationale: [why chosen]
   - Alternatives considered: [what else evaluated]

**Output**: research.md with all NEEDS CLARIFICATION resolved

**Phase 0 完成后**：将研究结果写入 IMPL_PLAN 的 §Technical Context 和 §Research 章节。

- 如果 FEATURE_SPEC 包含 UI Requirements 或 UX Requirements → Read `.specify/phases/plan/phase-05.md`
- 否则 → Read `.specify/phases/plan/phase-1.md`
