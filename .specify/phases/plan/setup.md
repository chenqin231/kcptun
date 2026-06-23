# speckit.plan — Setup（加载与评估）

> 所属命令：speckit.plan | 阶段：初始化

## 0. Load Persona *(MANDATORY)*

- Read `.agent/personas/architect.md` — if file exists, you **ARE** this persona for the entire session
- Internalize the persona's identity, core beliefs (especially Linus 三问), thinking style, professional skills, and communication rules
- Every response must reflect this persona's mindset (e.g., question complexity, demand trade-off analysis, enforce KISS/YAGNI)
- The persona defines WHO you are; the execution instructions below define WHAT you do
- **Phase 0.5 persona switch**: When entering Phase 0.5 (UI/UX Design), read `.agent/personas/designer.md` and temporarily **become** the designer for that phase only. Revert to architect persona when Phase 0.5 completes.

## 1. Setup

- Read `specs/progress.json` first, extract the `branch` field value as `<BRANCH_NAME>`
- If the file does not exist or the `branch` field is empty, output error: "Run `/speckit.specify` first to create a feature branch" and abort
- Run `.specify/scripts/bash/advance-stage.sh --stage plan --branch <BRANCH_NAME>` to advance stage (guard check + state transition)
- Run `.specify/scripts/bash/setup-plan.sh --json --branch <BRANCH_NAME>` and parse JSON to obtain FEATURE_SPEC, IMPL_PLAN, SPECS_DIR, BRANCH
- For single quotes in args like "I'm Groot", use escape syntax: e.g 'I'\''m Groot' (or double-quote if possible: "I'm Groot")

## 2. Load Context

Read FEATURE_SPEC and `.specify/memory/constitution.md`. Load IMPL_PLAN template (already copied).

## 3. Architecture Scope Assessment

- Read FEATURE_SPEC and assess four dimensions: affected module count / whether new modules are created / interface change scope / data model changes
- Fill the "Architecture Scope Assessment" section in IMPL_PLAN
- Determine architecture level (L1 intra-module / L2 cross-module / L3 system-level)

**Language Skills — load immediately (MANDATORY):**
- Identify the project's primary language from Technical Context or file extensions
- Load the matching language Skill now — language rules apply to the entire plan session
- No user confirmation needed; note to user: "Auto-loaded language Skill: [skill name]"

**Architecture Skills — lazy load at decision points (NOT upfront):**
- Do NOT load architecture Skills now. Announce recommended Skills:
  "This feature is assessed as [L?]. Recommended architecture Skills (will be loaded when needed): [list]. You may adjust the level or skip."
- Load each architecture Skill **only when the plan reaches a section that requires it**

## 4. Execute Plan Workflow

- Fill Technical Context (mark unknowns as "NEEDS CLARIFICATION")
- Fill Constitution Check section from constitution
- Evaluate gates (ERROR if violations unjustified)

**Setup 完成后**，Read `.specify/phases/plan/phase-0.md` 执行 Phase 0。
