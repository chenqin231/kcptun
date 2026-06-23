---

description: "Task list template for feature implementation"
---

# Tasks: [FEATURE NAME]

**Input**: Design documents from `/specs/[###-feature-name]/`
**Prerequisites**: plan.md (required), spec.md (required for user stories), research.md, data-model.md, contracts/

**Tests**: The examples below include test tasks. Tests are OPTIONAL - only include them if explicitly requested in the feature specification.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

## File Ownership（文件归属标注）

> **强制要求**：遵循"8️⃣ 模块化设计原则"，每个任务必须标注文件归属

每个任务必须包含以下标注：
- **独占文件**: 仅本任务修改的文件（可并行）
- **共享文件**: 与其他任务共享的文件 + 冲突风险说明（需串行或合并策略）

**冲突检测规则**：≥2 个任务修改同一文件 → 必须标注串行依赖或重新设计

## Path Conventions

- **Single project**: `src/`, `tests/` at repository root
- **Web app**: `backend/src/`, `frontend/src/`
- **Mobile**: `api/src/`, `ios/src/` or `android/src/`
- Paths shown below assume single project - adjust based on plan.md structure

<!-- 
  ============================================================================
  IMPORTANT: The tasks below are SAMPLE TASKS for illustration purposes only.
  
  The /speckit.tasks command MUST replace these with actual tasks based on:
  - User stories from spec.md (with their priorities P1, P2, P3...)
  - Feature requirements from plan.md
  - Entities from data-model.md
  - Endpoints from contracts/
  
  Tasks MUST be organized by user story so each story can be:
  - Implemented independently
  - Tested independently
  - Delivered as an MVP increment
  
  DO NOT keep these sample tasks in the generated tasks.md file.
  ============================================================================
-->

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Project initialization and basic structure

- [ ] T001 Create project structure per implementation plan
- [ ] T002 Initialize [language] project with [framework] dependencies
- [ ] T003 [P] Configure linting and formatting tools

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Core infrastructure that MUST be complete before ANY user story can be implemented

**⚠️ CRITICAL**: No user story work can begin until this phase is complete

Examples of foundational tasks (adjust based on your project):

- [ ] T004 Setup database schema and migrations framework
- [ ] T005 [P] Implement authentication/authorization framework
- [ ] T006 [P] Setup API routing and middleware structure
- [ ] T007 Create base models/entities that all stories depend on
- [ ] T008 Configure error handling and logging infrastructure
- [ ] T009 Setup environment configuration management

**Checkpoint**: Foundation ready - user story implementation can now begin in parallel

---

## Phase 3: User Story 1 - [Title] (Priority: P1) 🎯 MVP

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 1 (OPTIONAL - only if tests requested) ⚠️

> **NOTE: Write these tests FIRST, ensure they FAIL before implementation**

- [ ] T010 [P] [US1] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T011 [P] [US1] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 1

- [ ] T012 [P] [US1] Create [Entity1] model in src/models/[entity1].py
  - **独占文件**: `src/models/[entity1].py`
  - **覆盖 AC**: AC-001-H1, AC-001-E1
  - **完成标准**:
    - 正常：传入合法数据创建实体 → 返回完整实体对象，字段值与输入一致
    - 异常：必填字段为空 → 抛出 ValidationError，消息为 "[字段名]不能为空"
- [ ] T013 [P] [US1] Create [Entity2] model in src/models/[entity2].py
  - **独占文件**: `src/models/[entity2].py`
  - **覆盖 AC**: AC-001-H1
  - **完成标准**:
    - 正常：传入合法数据创建实体 → 返回完整实体对象
    - 异常：关联实体不存在 → 抛出 NotFoundError，消息为 "[关联实体]不存在"
- [ ] T014 [US1] Implement [Service] in src/services/[service].py (depends on T012, T013)
  - **独占文件**: `src/services/[service].py`
  - **覆盖 AC**: AC-001-H1, AC-001-E1, AC-001-E2
  - **完成标准**:
    - 正常：调用服务方法传入合法参数 → 操作成功，返回结果对象
    - 异常1：参数校验失败 → 返回错误码 + 具体错误消息 "[字段]格式不正确"
    - 异常2：外部依赖超时 → 返回错误码 + 消息 "服务暂时不可用，请稍后重试"
- [ ] T015 [US1] Implement [endpoint/feature] in src/[location]/[file].py
  - **独占文件**: `src/[location]/[file].py`
  - **覆盖 AC**: AC-001-H1, AC-001-E1, AC-001-E2
  - **完成标准**:
    - 正常：用户执行操作 → 操作成功 → 显示 Toast "操作成功" 持续 3 秒后消失
    - 异常1：输入校验失败 → 操作不执行 → 对应字段下方显示 Inline 提示 "[具体错误]"
    - 异常2：网络异常 → 操作不执行 → 显示 Modal "网络连接失败，请检查网络后重试"，用户点击确定关闭
- [ ] T016 [US1] Add validation and error handling
  - **共享文件**: `src/services/[service].py`（与 T014 共享，串行执行）
  - **覆盖 AC**: AC-001-E1, AC-001-E2
  - **完成标准**:
    - 异常：每种已知异常条件均有对应的错误处理 → 返回明确的错误码和用户可读消息
- [ ] T017 [US1] Add logging for user story 1 operations
  - **独占文件**: `src/logging/[logger].py`

**Checkpoint**: At this point, User Story 1 should be fully functional and testable independently

---

## Phase 4: User Story 2 - [Title] (Priority: P2)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 2 (OPTIONAL - only if tests requested) ⚠️

- [ ] T018 [P] [US2] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T019 [P] [US2] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 2

- [ ] T020 [P] [US2] Create [Entity] model in src/models/[entity].py
  - **独占文件**: `src/models/[entity].py`
  - **覆盖 AC**: AC-003-H1, AC-003-E1
  - **完成标准**:
    - 正常：传入合法数据 → 返回完整实体对象
    - 异常：数据校验失败 → 抛出 ValidationError + 具体消息
- [ ] T021 [US2] Implement [Service] in src/services/[service].py
  - **独占文件**: `src/services/[service].py`
  - **覆盖 AC**: AC-003-H1, AC-003-E1, AC-003-E2
  - **完成标准**:
    - 正常：调用服务方法 → 操作成功，返回结果
    - 异常：业务规则不满足 → 返回错误码 + 用户可读消息
- [ ] T022 [US2] Implement [endpoint/feature] in src/[location]/[file].py
  - **独占文件**: `src/[location]/[file].py`
  - **覆盖 AC**: AC-003-H1, AC-003-E1, AC-003-E2
  - **完成标准**:
    - 正常：用户操作 → 成功 → 显示对应成功反馈（Toast/页面跳转）
    - 异常：操作失败 → 显示对应错误反馈（Inline/Modal）+ 恢复方式
- [ ] T023 [US2] Integrate with User Story 1 components (if needed)

**Checkpoint**: At this point, User Stories 1 AND 2 should both work independently

---

## Phase 5: User Story 3 - [Title] (Priority: P3)

**Goal**: [Brief description of what this story delivers]

**Independent Test**: [How to verify this story works on its own]

### Tests for User Story 3 (OPTIONAL - only if tests requested) ⚠️

- [ ] T024 [P] [US3] Contract test for [endpoint] in tests/contract/test_[name].py
- [ ] T025 [P] [US3] Integration test for [user journey] in tests/integration/test_[name].py

### Implementation for User Story 3

- [ ] T026 [P] [US3] Create [Entity] model in src/models/[entity].py
  - **独占文件**: `src/models/[entity].py`
  - **覆盖 AC**: AC-005-H1, AC-005-E1
  - **完成标准**:
    - 正常：传入合法数据 → 返回完整实体对象
    - 异常：数据校验失败 → 抛出 ValidationError + 具体消息
- [ ] T027 [US3] Implement [Service] in src/services/[service].py
  - **独占文件**: `src/services/[service].py`
  - **覆盖 AC**: AC-005-H1, AC-005-E1, AC-005-E2
  - **完成标准**:
    - 正常：调用服务方法 → 操作成功，返回结果
    - 异常：业务规则不满足 → 返回错误码 + 用户可读消息
- [ ] T028 [US3] Implement [endpoint/feature] in src/[location]/[file].py
  - **独占文件**: `src/[location]/[file].py`
  - **覆盖 AC**: AC-005-H1, AC-005-E1, AC-005-E2
  - **完成标准**:
    - 正常：用户操作 → 成功 → 显示对应成功反馈（Toast/页面跳转）
    - 异常：操作失败 → 显示对应错误反馈（Inline/Modal）+ 恢复方式

**Checkpoint**: All user stories should now be independently functional

---

[Add more user story phases as needed, following the same pattern]

---

## Phase N: Polish & Cross-Cutting Concerns

**Purpose**: Improvements that affect multiple user stories

- [ ] TXXX [P] Documentation updates in docs/
- [ ] TXXX Code cleanup and refactoring
- [ ] TXXX Performance optimization across all stories
- [ ] TXXX [P] Additional unit tests (if requested) in tests/unit/
- [ ] TXXX Security hardening
- [ ] TXXX Run quickstart.md validation

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies - can start immediately
- **Foundational (Phase 2)**: Depends on Setup completion - BLOCKS all user stories
- **User Stories (Phase 3+)**: All depend on Foundational phase completion
  - User stories can then proceed in parallel (if staffed)
  - Or sequentially in priority order (P1 → P2 → P3)
- **Polish (Final Phase)**: Depends on all desired user stories being complete

### User Story Dependencies

- **User Story 1 (P1)**: Can start after Foundational (Phase 2) - No dependencies on other stories
- **User Story 2 (P2)**: Can start after Foundational (Phase 2) - May integrate with US1 but should be independently testable
- **User Story 3 (P3)**: Can start after Foundational (Phase 2) - May integrate with US1/US2 but should be independently testable

### Within Each User Story

- Tests (if included) MUST be written and FAIL before implementation
- Models before services
- Services before endpoints
- Core implementation before integration
- Story complete before moving to next priority

### Parallel Opportunities

- All Setup tasks marked [P] can run in parallel
- All Foundational tasks marked [P] can run in parallel (within Phase 2)
- Once Foundational phase completes, all user stories can start in parallel (if team capacity allows)
- All tests for a user story marked [P] can run in parallel
- Models within a story marked [P] can run in parallel
- Different user stories can be worked on in parallel by different team members

---

## Parallel Example: User Story 1

```bash
# Launch all tests for User Story 1 together (if tests requested):
Task: "Contract test for [endpoint] in tests/contract/test_[name].py"
Task: "Integration test for [user journey] in tests/integration/test_[name].py"

# Launch all models for User Story 1 together:
Task: "Create [Entity1] model in src/models/[entity1].py"
Task: "Create [Entity2] model in src/models/[entity2].py"
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL - blocks all stories)
3. Complete Phase 3: User Story 1
4. **STOP and VALIDATE**: Test User Story 1 independently
5. Deploy/demo if ready

### Incremental Delivery

1. Complete Setup + Foundational → Foundation ready
2. Add User Story 1 → Test independently → Deploy/Demo (MVP!)
3. Add User Story 2 → Test independently → Deploy/Demo
4. Add User Story 3 → Test independently → Deploy/Demo
5. Each story adds value without breaking previous stories

### Parallel Team Strategy

With multiple developers:

1. Team completes Setup + Foundational together
2. Once Foundational is done:
   - Developer A: User Story 1
   - Developer B: User Story 2
   - Developer C: User Story 3
3. Stories complete and integrate independently

---

## Requirements Coverage Matrix

> **用途**：追踪 spec.md 中每个需求点（FR/US）与任务的映射关系。
> **维护**：由 `/speckit.tasks` 生成时填充；`/speckit.implement` 执行期间自动更新 Status 列。
> **门控**：所有任务完成后，`/speckit.implement` Step 10 将检查此矩阵，确保无 ⬜ 残留。

| Requirement | Source | Covered By (Task IDs) | Status |
|-------------|--------|-----------------------|--------|
| [FR-001: 需求描述] | spec.md §US1 | T010, T012, T014 | ⬜ |
| [FR-002: 需求描述] | spec.md §US1 | T015 | ⬜ |
| [FR-003: 需求描述] | spec.md §US2 | T021, T022 | ⬜ |

**Status 图例**：
- ⬜ 未完成（关联任务中有 `[ ]` 未勾选）
- ✅ 已完成（所有关联任务均为 `[x]`）
- ⏭ 已跳过（需在 Skipped Tasks 中登记原因，不计入门控检查）

## Skipped Tasks

> 记录被显式跳过的任务及原因。跳过的任务不计入 Step 10 门控检查，但需要说明对应需求是否仍被其他任务覆盖。

| Task ID | Reason | FR Still Covered By |
|---------|--------|---------------------|
| *(none)* | | |

---

## Notes

- [P] tasks = different files, no dependencies
- [Story] label maps task to specific user story for traceability
- Each user story should be independently completable and testable
- **AC inheritance**: US-phase tasks MUST include 覆盖 AC + 完成标准（正常+异常路径），Setup/Foundational/Polish 阶段可省略
- **消息反馈**: 完成标准中涉及用户反馈的，必须写明反馈形式（Toast/Modal/Inline/Notification/页面跳转/状态变更）+ 具体文案 + 触发时机
- Verify tests fail before implementing
- Commit after each task or logical group
- Stop at any checkpoint to validate story independently
- Avoid: vague tasks, same file conflicts, cross-story dependencies that break independence
