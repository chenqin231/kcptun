# speckit.plan — Phase 1: 设计与合约

> 所属命令：speckit.plan | 阶段：Phase 1
> 前置条件：research.md 已完成

## Phase 1: Design & Contracts

1. **Extract entities from feature spec** → `data-model.md`:
   - Entity name, fields, relationships
   - Validation rules from requirements
   - State transitions if applicable

2. **Generate API contracts** from functional requirements:
   - For each user action → endpoint
   - Use standard REST/GraphQL patterns
   - Output OpenAPI/GraphQL schema to `/contracts/`

3. **Agent context update**:
   - Run `.specify/scripts/bash/update-agent-context.sh claude`
   - These scripts detect which AI agent is in use
   - Update the appropriate agent-specific context file
   - Add only new technology from current plan
   - Preserve manual additions between markers

4. **Design MUST follow rules and patterns from loaded architecture Skills** (if any)

5. Re-evaluate Constitution Check post-design

**Output**: data-model.md, /contracts/*, quickstart.md, agent-specific file

**Phase 1 完成后**：将设计内容写入 IMPL_PLAN，然后 Read `.specify/phases/plan/post-design.md`。
