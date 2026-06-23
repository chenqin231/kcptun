# speckit.implement — Setup（Worktree + Checklist 检查）

> 所属命令：speckit.implement | 阶段：初始化

## 0. Load Persona *(MANDATORY)*

- Read `.agent/personas/backend.md` — if file exists, you **ARE** this persona by default
- Internalize the persona's identity, core beliefs (especially 工程信条), thinking style, professional skills, and communication rules
- Every response must reflect this persona's mindset (e.g., explicit error handling, defensive programming, TDD-first)
- The persona defines WHO you are; the execution instructions below define WHAT you do
- **Dynamic persona switch**: When a task primarily involves frontend files (components/, pages/, styles/, *.tsx, *.jsx, *.vue, *.svelte), read `.agent/personas/frontend.md` and **become** the frontend persona for that task. Revert to backend persona for non-frontend tasks.

## 1. Setup

- Read `specs/progress.json` first, extract the `branch` field value as `<BRANCH_NAME>`
- If the file does not exist or the `branch` field is empty, output error: "Run `/speckit.specify` first to create a feature branch" and abort
- **Commit specs before creating worktree** (specs 在 specify/plan/tasks 阶段创建但未提交，worktree 基于当前分支创建，未提交的文件不会包含):
  ```bash
  git add specs/
  git commit -m "docs(specs): add <BRANCH_NAME> specification artifacts"
  ```
- **Create worktree isolation environment**:
  ```bash
  BASE_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@')
  [ -z "$BASE_BRANCH" ] && BASE_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
  [ -z "$BASE_BRANCH" ] && BASE_BRANCH="master"
  git worktree add worktrees/<BRANCH_NAME> -b <BRANCH_NAME> "$BASE_BRANCH"
  ```
- If worktree creation fails, try fallback with `git checkout -b <BRANCH_NAME>`
- If fallback also fails, output error and abort
- **All subsequent development operations execute in the worktree directory**
- Run `.specify/scripts/bash/advance-stage.sh --stage develop --branch <BRANCH_NAME>`
- Run `.specify/scripts/bash/check-prerequisites.sh --json --require-tasks --include-tasks --branch <BRANCH_NAME>` and parse FEATURE_DIR and AVAILABLE_DOCS list
- All paths must be absolute

## 2. Check Checklists Status

If `FEATURE_DIR/checklists/` exists:
- Scan all checklist files, count Total/Completed/Incomplete items
- Create status table:
  ```
  | Checklist | Total | Completed | Incomplete | Status |
  ```
- **If any checklist incomplete**: STOP and ask: "Some checklists are incomplete. Do you want to proceed? (yes/no)"
- **If all complete**: Automatically proceed

**Setup 完成后**，Read `.specify/phases/implement/load-and-execute.md`。
