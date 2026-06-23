# speckit.analyze — Setup（初始化 + 加载制品）

> 所属命令：speckit.analyze | 阶段：初始化

## 0. Load Persona *(MANDATORY)*

- Read `.agent/personas/code-reviewer.md` — if file exists, you **ARE** this persona for the entire session
- Internalize the persona's identity, core beliefs, thinking style, professional skills, and review feedback levels (🔴 BLOCKER → 💡 SUGGESTION)

## Goal

**Scope**: Cross-document consistency checks, coverage analysis, AND single-document SMA quality detection (Specific/Measurable/Atomic).

Identify inconsistencies, duplications, ambiguities, and underspecified items across `spec.md`, `plan.md`, `tasks.md` before implementation. This command MUST run only after `/speckit.tasks` has produced a complete `tasks.md`.

## Operating Constraints

- **STRICTLY READ-ONLY**: Do **not** modify any files
- **Constitution Authority**: `.specify/memory/constitution.md` is **non-negotiable**. Constitution conflicts are automatically CRITICAL.

## 1. Initialize Analysis Context

1. Read `specs/progress.json`, extract `branch` field as `<BRANCH_NAME>`
2. If unavailable, fall back to auto-detection mode (omit --branch)
3. Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks --branch <BRANCH_NAME>`
4. Parse JSON for FEATURE_DIR and AVAILABLE_DOCS. Derive: SPEC, PLAN, TASKS paths.
5. Abort if any required file missing.

## 2. Load Artifacts (Progressive Disclosure)

**From spec.md:** Overview/Context, Functional Requirements, Non-Functional Requirements, User Stories, Edge Cases
**From plan.md:** Architecture/stack choices, Data Model references, Phases, Technical constraints
**From tasks.md:** Task IDs, Descriptions, Phase grouping, Parallel markers [P], Referenced file paths
**From constitution:** Load `.specify/memory/constitution.md`
**Project Architecture Context (optional):** CLAUDE.md, `.agent/user.md`

## 3. Build Semantic Models

Create internal representations (do not include raw artifacts in output):
- **Requirements inventory**: Each FR + NFR with stable key
- **User story/action inventory**: Discrete user actions with acceptance criteria
- **Task coverage mapping**: Map each task to ≥1 requirement/story
- **Constitution rule set**: Extract principle names and MUST/SHOULD statements

**Setup 完成后**，Read `.specify/phases/analyze/detection.md` 执行检测。
