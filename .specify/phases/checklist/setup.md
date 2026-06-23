# speckit.checklist — Setup（初始化 + 澄清意图）

> 所属命令：speckit.checklist | 阶段：初始化

## Checklist Purpose: "Unit Tests for English"

**CRITICAL CONCEPT**: Checklists are **UNIT TESTS FOR REQUIREMENTS WRITING** - they validate the quality, clarity, and completeness of requirements in a given domain.

**NOT for verification/testing**:
- ❌ NOT "Verify the button clicks correctly"
- ❌ NOT "Test error handling works"

**FOR requirements quality validation**:
- ✅ "Are visual hierarchy requirements defined for all card types?"
- ✅ "Is 'prominent display' quantified with specific sizing/positioning?"

## 0. Load Persona *(MANDATORY)*

- Read `.agent/personas/tester.md` — if file exists, you **ARE** this persona for the entire session

## 1. Setup

- Read `specs/progress.json`, extract `branch` field as `<BRANCH_NAME>`
- If unavailable, fall back to auto-detection mode (omit --branch)
- Run `.specify/scripts/bash/check-prerequisites.sh --json --branch <BRANCH_NAME>`
- Parse JSON for FEATURE_DIR and AVAILABLE_DOCS list

## 2. Clarify Intent (Dynamic)

Derive up to THREE initial contextual clarifying questions:
- Generated from user's phrasing + extracted signals from spec/plan/tasks
- Only ask about information that materially changes checklist content
- Skipped individually if already unambiguous in `$ARGUMENTS`

Generation algorithm:
1. Extract signals: feature domain keywords, risk indicators, stakeholder hints, explicit deliverables
2. Cluster signals into candidate focus areas (max 4)
3. Identify probable audience & timing
4. Detect missing dimensions: scope breadth, depth/rigor, risk emphasis, exclusion boundaries
5. Formulate questions from archetypes (scope refinement, risk prioritization, depth calibration, audience framing, boundary exclusion, scenario class gap)

Question formatting: table with Option | Candidate | Why It Matters (limit A-E options).
Defaults: Depth=Standard, Audience=Reviewer, Focus=Top 2 clusters.

After answers: if ≥2 scenario classes remain unclear, MAY ask up to TWO more follow-ups (Q4/Q5). Max 5 total questions.

## 3. Understand User Request

Combine `$ARGUMENTS` + answers: derive theme, consolidate must-haves, map focus to categories, infer missing context from spec/plan/tasks.

## 4. Load Feature Context

Read from FEATURE_DIR: spec.md, plan.md (if exists), tasks.md (if exists).
- Load only necessary portions relevant to active focus areas
- Use progressive disclosure: add follow-on retrieval only if gaps detected

**Setup 完成后**，Read `.specify/phases/checklist/generate.md` 生成 checklist。
