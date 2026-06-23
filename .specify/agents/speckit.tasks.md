---
description: Generate an actionable, dependency-ordered tasks.md for the feature based on available design artifacts.
handoffs: 
  - label: Analyze For Consistency
    agent: speckit.analyze
    prompt: Run a project analysis for consistency
    send: true
  - label: Implement Project
    agent: speckit.implement
    prompt: Start the implementation in phases
    send: true
---

## User Input

```text
$ARGUMENTS
```

You **MUST** consider the user input before proceeding (if not empty).

## Outline

0. **Load persona** *(MANDATORY)*:
   - Read `.agent/personas/project-manager.md` — if file exists, you **ARE** this persona for the entire session
   - Internalize the persona's identity, core beliefs, thinking style, professional skills, and communication rules
   - Every response must reflect this persona's mindset (e.g., focus on value delivery, expose risks early, clear task boundaries)
   - The persona defines WHO you are; the execution instructions below define WHAT you do

1. **Setup**:
   - Read `specs/progress.json` first, extract the `branch` field value as `<BRANCH_NAME>`
   - If the file does not exist or the `branch` field is empty, output error: "Run `/speckit.specify` first to create a feature branch" and abort
   - Run `.specify/scripts/bash/advance-stage.sh --stage tasks --branch <BRANCH_NAME>` to advance stage (guard check + state transition)
   - Run `.specify/scripts/bash/check-prerequisites.sh --json --branch <BRANCH_NAME>` and parse FEATURE_DIR and AVAILABLE_DOCS list
   - All paths must be absolute. For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot")

2. **Load design documents** (tiered — load only what is needed, in order):

   **Tier 1 — Always load (minimum required):**
   - From `spec.md`: Read **only** the User Stories section and Functional Requirements list
     (skip Overview, Context, NFR, Edge Cases — not needed for task generation)
   - From `plan.md`: Read **only** the Module Decomposition and Project Structure sections
     (skip architecture rationale, research background, constitution check — not needed)

   **Tier 2 — Load on demand (only if the content above is insufficient):**
   - `data-model.md`: Load only if tasks need to reference specific entity fields
   - `contracts/`: Load only if tasks need to reference specific endpoint signatures
   - `research.md`: Load only if setup tasks require specific technology decisions
   - `quickstart.md`: Load only if test scenarios are requested
   - Full `spec.md`: Fall back to full read only if User Stories section is absent or incomplete
   - Full `plan.md`: Fall back to full read only if Module Decomposition section is absent

   **Do NOT pre-load Tier 2 documents speculatively.** Load them only when a specific task generation step requires information not found in Tier 1.

3. **Execute task generation workflow**:
   - From Tier 1 spec.md extract: user stories with priorities (P1, P2, P3…) and FR list
   - From Tier 1 plan.md extract: module names, file paths, project structure
   - On demand: load Tier 2 documents only as specific gaps are encountered
   - Generate tasks organized by user story (see Task Generation Rules below)
   - Generate dependency graph showing user story completion order
   - Create parallel execution examples per user story
   - Validate task completeness (each user story has all needed tasks, independently testable)

4. **Generate tasks.md**: Use `.specify/templates/tasks-template.md` as structure, fill with:
   - Correct feature name from plan.md
   - Phase 1: Setup tasks (project initialization)
   - Phase 2: Foundational tasks (blocking prerequisites for all user stories)
   - Phase 3+: One phase per user story (in priority order from spec.md)
   - Each phase includes: story goal, independent test criteria, tests (if requested), implementation tasks
   - Final Phase: Polish & cross-cutting concerns
   - All tasks must follow the strict checklist format (see Task Generation Rules below)
   - Clear file paths for each task
   - Dependencies section showing story completion order
   - Parallel execution examples per story
   - Implementation strategy section (MVP first, incremental delivery)
   - **Requirements Coverage Matrix** (MANDATORY): Fill the matrix at the end of tasks.md:
     - List every FR and User Story from spec.md as a row (one row per atomic requirement)
     - For each row, identify which Task IDs cover it (based on [US?] labels and task descriptions)
     - Set all Status values to ⬜ (will be updated to ✅ by `/speckit.implement` Step 10)
     - If a FR has zero covering tasks, flag it immediately — this is a coverage gap that must be resolved before proceeding

5. **Report**: Output path to generated tasks.md and summary:
   - Total task count
   - Task count per user story
   - Parallel opportunities identified
   - Independent test criteria for each story
   - Suggested MVP scope (typically just User Story 1)
   - Format validation: Confirm ALL tasks follow the checklist format (checkbox, ID, labels, file paths)
   - **AC inheritance validation**: Confirm every US-phase task has 验收标准 sub-items with AC references; list any US task missing AC as a blocker
   - **AC coverage balance**: Confirm every FR's Happy + Error ACs are covered by at least one task's 完成标准，且含消息反馈的 AC 必须在完成标准中包含文案断言; list any uncovered AC as a blocker
   - **Coverage Matrix validation**: Confirm every FR/US from spec.md appears in the matrix; list any FR with zero task coverage as a blocker

Context for task generation: $ARGUMENTS

The tasks.md should be immediately executable - each task must be specific enough that an LLM can complete it without additional context.

## Task Generation Rules

**CRITICAL**: Tasks MUST be organized by user story to enable independent implementation and testing.

**Tests are OPTIONAL**: Only generate test tasks if explicitly requested in the feature specification or if user requests TDD approach.

### Checklist Format (REQUIRED)

Every task MUST strictly follow this format:

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

**Format Components**:

1. **Checkbox**: ALWAYS start with `- [ ]` (markdown checkbox)
2. **Task ID**: Sequential number (T001, T002, T003...) in execution order
3. **[P] marker**: Include ONLY if task is parallelizable (different files, no dependencies on incomplete tasks)
4. **[Story] label**: REQUIRED for user story phase tasks only
   - Format: [US1], [US2], [US3], etc. (maps to user stories from spec.md)
   - Setup phase: NO story label
   - Foundational phase: NO story label
   - User Story phases: MUST have story label
   - Polish phase: NO story label
5. **Description**: Clear action with exact file path
6. **Acceptance Criteria** (MANDATORY for User Story phase tasks): 每个 US 任务必须包含验收标准子项
   - **AC 引用**：标注本任务覆盖的 spec AC 编号（如 AC-001-H1, AC-001-E1）
   - **完成标准**：用具体的操作→预期结果描述，包含正常和异常路径
   - 格式：任务描述行下方缩进列出
   - Setup/Foundational/Polish 阶段任务可省略（无对应 spec AC）

**Examples**:

- ✅ CORRECT:
  ```
  - [ ] T012 [P] [US1] Create User model in src/models/user.py
    - **覆盖 AC**: AC-001-H1, AC-001-E1
    - **完成标准**:
      - 正常：创建用户传入合法数据 → 返回用户对象，包含 id/name/email 字段
      - 异常：email 格式非法 → 抛出 ValidationError，消息为 "邮箱格式不正确"
  ```
- ✅ CORRECT: `- [ ] T001 Create project structure per implementation plan` (Setup 阶段，无需 AC)
- ✅ CORRECT: `- [ ] T005 [P] Implement authentication middleware in src/middleware/auth.py` (Foundational 阶段，无需 AC)
- ❌ WRONG: `- [ ] Create User model` (missing ID and Story label)
- ❌ WRONG: `T001 [US1] Create model` (missing checkbox)
- ❌ WRONG: `- [ ] [US1] Create User model` (missing Task ID)
- ❌ WRONG: `- [ ] T001 [US1] Create model` (missing file path)
- ❌ WRONG: `- [ ] T012 [US1] Create User model in src/models/user.py` (US 任务缺少验收标准)

### Task Organization

1. **From User Stories (spec.md)** - PRIMARY ORGANIZATION:
   - Each user story (P1, P2, P3...) gets its own phase
   - Map all related components to their story:
     - Models needed for that story
     - Services needed for that story
     - Endpoints/UI needed for that story
     - If tests requested: Tests specific to that story
   - Mark story dependencies (most stories should be independent)

2. **From Contracts**:
   - Map each contract/endpoint → to the user story it serves
   - If tests requested: Each contract → contract test task [P] before implementation in that story's phase

3. **From Data Model**:
   - Map each entity to the user story(ies) that need it
   - If entity serves multiple stories: Put in earliest story or Setup phase
   - Relationships → service layer tasks in appropriate story phase

4. **From Setup/Infrastructure**:
   - Shared infrastructure → Setup phase (Phase 1)
   - Foundational/blocking tasks → Foundational phase (Phase 2)
   - Story-specific setup → within that story's phase

### Phase Structure

- **Phase 1**: Setup (project initialization)
- **Phase 2**: Foundational (blocking prerequisites - MUST complete before user stories)
- **Phase 3+**: User Stories in priority order (P1, P2, P3...)
  - Within each story: Tests (if requested) → Models → Services → Endpoints → Integration
  - Each phase should be a complete, independently testable increment
- **Final Phase**: Polish & Cross-Cutting Concerns
