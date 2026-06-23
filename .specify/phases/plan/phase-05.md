# speckit.plan — Phase 0.5: UI/UX 设计（条件执行）

> 所属命令：speckit.plan | 阶段：Phase 0.5
> 前置条件：research.md 已完成 + FEATURE_SPEC 含 UI/UX Requirements

## UI/UX Design Phase

> 注意：本文件仅在 phase-0.md 判定 FEATURE_SPEC 含 UI/UX Requirements 时才会被 Read。
> 无需再次检测 UI involvement — 前置条件已由调用方保证。

- **Load ui-ux-pro-max skill** (MANDATORY when UI is involved):
  - Invoke the `ui-ux-pro-max` skill
  - Use it to guide style selection and interaction pattern selection

- **Style & Interaction Selection**:
  - Based on project type, confirmed tech stack, and user journey from FEATURE_SPEC, select:
    - Visual style (e.g., glassmorphism, minimalism, flat design)
    - Component library / UI stack (e.g., shadcn/ui, Tailwind, native)
    - Interaction patterns (e.g., modal flow, inline editing, bottom sheet)
  - **STOP**: Present style and interaction recommendations, ask:
    "Recommended UI style: [style]. Recommended stack: [stack]. Interaction pattern: [pattern]. Confirm or adjust?"

- **UI Design Artifacts** — after confirmation, produce:
  - Page / screen inventory: list every screen or view involved
  - Component breakdown: which components are needed per screen
  - State design: empty / loading / success / error for each component
  - Navigation / transition map: how screens connect
  - **Message & Feedback Components Design** (MANDATORY when spec AC contains Toast/Modal/Inline/Notification feedback):
    - Toast patterns: default duration, position, dismissal
    - Modal/Dialog patterns: trigger conditions, required user actions, backdrop behavior
    - Inline feedback: field-level validation message style, positioning, appearance timing
    - Confirm dialog patterns: primary/secondary button labels, destructive action styling
    - Notification patterns: persistent vs transient, grouping rules, action buttons
    - **Consistency rule**: All feedback components must reuse the same design tokens

- **UX Flow Design** — derive from Overall UX Requirements and per-FR UX Requirements:
  - Detailed interaction flow per journey step
  - Transition logic: what triggers navigation between screens
  - Error recovery flows
  - Edge paths: back button behavior, timeout handling, concurrent edit conflicts

**Phase 0.5 完成后**：将所有 UI/UX 设计制品写入 IMPL_PLAN 的 §UI/UX Design 章节，然后 Read `.specify/phases/plan/phase-1.md`。
