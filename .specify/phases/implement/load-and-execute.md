# speckit.implement — 分层加载与执行

> 所属命令：speckit.implement | 阶段：执行

## 3. Load Implementation Context (Tiered)

**Tier 1 — Always load (minimum required):**
- `tasks.md`: Read in full — this is the execution source of truth
- From `plan.md`: Read **only** the Module Decomposition and Project Structure sections

**Tier 2 — Load on demand (per task, only when that task requires it):**
- `data-model.md`: Load only when executing a task that creates/modifies entities or DB schema
- `contracts/`: Load only when executing a task that implements an API endpoint
- `research.md`: Load only when executing a task that involves a specific technology decision
- `quickstart.md`: Load only when executing integration or end-to-end validation tasks
- Full `plan.md`: Fall back to full read only if Module Decomposition section is absent

**Do NOT pre-load all Tier 2 documents at session start.**

## 4. Project Setup Verification

- **REQUIRED**: Create/verify ignore files based on actual project setup

**检测与创建逻辑**：
- `git rev-parse --git-dir` 成功 → 创建/验证 .gitignore
- Dockerfile* 存在或 plan.md 提到 Docker → 创建/验证 .dockerignore
- .eslintrc* 存在 → .eslintignore；eslint.config.* 存在 → 确保 `ignores` 条目覆盖
- .prettierrc* 存在 → .prettierignore
- package.json 存在且需发布 → .npmignore
- *.tf 存在 → .terraformignore；helm charts → .helmignore

**常用 ignore 模式（按技术栈）**：
- **Node.js/TS**: `node_modules/`, `dist/`, `build/`, `*.log`, `.env*`
- **Python**: `__pycache__/`, `*.pyc`, `.venv/`, `dist/`, `*.egg-info/`
- **Go**: `*.exe`, `*.test`, `vendor/`, `*.out`
- **Rust**: `target/`, `debug/`, `release/`, `*.rs.bk`
- **Java/Kotlin**: `target/`, `build/`, `.gradle/`, `*.class`, `*.jar`
- **C/C++**: `build/`, `bin/`, `obj/`, `*.o`, `*.so`, `*.a`, `*.exe`
- **Ruby**: `.bundle/`, `log/`, `tmp/`, `vendor/bundle/`
- **PHP**: `vendor/`, `*.log`, `*.cache`
- **Universal**: `.DS_Store`, `Thumbs.db`, `*.tmp`, `*.swp`, `.vscode/`, `.idea/`

**规则**：
- **已存在的 ignore 文件**：验证是否包含关键模式，仅追加缺失的
- **不存在的 ignore 文件**：按检测到的技术栈创建完整模式集

## 5-8. Execute Tasks

5. Parse tasks.md structure (phases, dependencies, task details, execution flow)
6. Execute implementation phase-by-phase:
   - Complete each phase before moving to the next
   - Respect dependencies; parallel tasks [P] can run together
   - Follow TDD approach: test tasks before implementation tasks
   - File-based coordination: same-file tasks run sequentially
7. Implementation execution rules:
   - Setup first → Tests before code → Core development → Integration → Polish
8. Progress tracking:
   - Report progress after each completed task
   - Halt on non-parallel task failure
   - **IMPORTANT**: Mark completed tasks as [X] in tasks file

**每个任务完成后**，执行 `.specify/phases/implement/validate-task.md` 中的验证流程。
**所有任务完成后**，Read `.specify/phases/implement/global-gate.md`。
