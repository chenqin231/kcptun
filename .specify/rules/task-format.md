# 任务清单格式（Task Format Rules）

> 生成 tasks.md 时加载。

## 严格格式（每个任务必须遵循）

```text
- [ ] [TaskID] [P?] [Story?] Description with file path
```

### 格式组件

1. **Checkbox**: 始终以 `- [ ]` 开头
2. **Task ID**: 按执行顺序递增（T001, T002, T003...）
3. **[P] 标记**: 仅在任务可并行时标注（不同文件、无依赖）
4. **[Story] 标签**: 仅 User Story 阶段任务需要
   - 格式：[US1], [US2], [US3]...
   - Setup/Foundational/Polish 阶段：不加标签
5. **描述**: 明确操作 + 精确文件路径
6. **验收标准**（User Story 阶段任务强制）：
   - **覆盖 AC**: 标注本任务覆盖的 spec AC 编号
   - **完成标准**: 用操作→预期结果描述，含正常和异常路径

### 示例

```
- [ ] T012 [P] [US1] Create User model in src/models/user.py
  - **覆盖 AC**: AC-001-H1, AC-001-E1
  - **完成标准**:
    - 正常：创建用户传入合法数据 → 返回用户对象，包含 id/name/email 字段
    - 异常：email 格式非法 → 抛出 ValidationError，消息为 "邮箱格式不正确"
```

### 阶段结构

- **Phase 1**: Setup（项目初始化）
- **Phase 2**: Foundational（阻塞性前置任务）
- **Phase 3+**: 按优先级排列的 User Story
- **Final Phase**: Polish & 横切关注点
