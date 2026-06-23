# speckit.analyze — 严重性 + 判决 + 下一步

> 所属命令：speckit.analyze | 阶段：报告

## 5. Severity Assignment

**Three severity levels** (LOW is removed — all findings are at least MEDIUM):

### CRITICAL — any one = NoGo

| # | Condition | Detection Pass | Rationale |
|---|-----------|---------------|-----------|
| C1 | Core requirement has multiple interpretations | H5 | Implementor builds wrong thing |
| C2 | Functional requirement has zero task coverage | E | Promised feature not delivered |
| C3 | Direct contradiction across spec ↔ plan ↔ tasks | F/G | e.g. spec says REST, plan writes GraphQL |
| C4 | Key architecture decision missing | H1+I1 | DB/auth/protocol unspecified |
| C5 | Violates Constitution MUST principle | D | Team hard constraint ignored |

### HIGH — any one = NoGo

> 注意：下表使用 HI 前缀（HIGH Issue）以区分 SMA 检测通道 H（Specificity）。

| # | Condition | Detection Pass | Rationale |
|---|-----------|---------------|-----------|
| HI1 | Task boundary overlap (≥2 tasks modify same file, unclear responsibility) | J2+file conflict | Parallel dev will conflict |
| HI2 | Duplicate tasks | A | Wasted effort + merge conflict |
| HI3 | Logical inconsistency | F | Task A says "sync", Task B says "async callback" |
| HI4 | Module responsibility not single | H6 | Coupling → maintenance burden |
| HI5 | Acceptance criteria unmeasurable (core functionality) | I1/I2 | Cannot judge "done" |
| HI6 | Vague verb with no end-state on functional task | H1 | "Optimize performance" → done when? |

### MEDIUM — Go (with warnings)

All other findings.

## 6. Produce Compact Analysis Report

Output a Markdown report (no file writes) with: findings table, coverage summary, constitution alignment, unmapped tasks, cross-document traceability, SMA quality detection table, SMA statistics, and metrics.

## 7. Verdict (MANDATORY)

```
CRITICAL > 0  →  NoGo
HIGH > 0      →  NoGo
MEDIUM only   →  Go (with improvement suggestions)
Zero issues   →  Go
```

## 8. Next Actions

- **NoGo**: List specific commands to fix issues
- **Go**: Provide improvement suggestions for MEDIUM issues

## 9. Offer Remediation

Ask: "Would you like me to suggest concrete remediation edits for the top N issues?" (Do NOT apply automatically.)

## Operating Principles

- **Minimal high-signal tokens**: Focus on actionable findings
- **Token-efficient output**: Limit findings to 50 rows
- **Deterministic results**: Rerunning should produce consistent IDs
- **NEVER modify files** | **NEVER hallucinate missing sections** | **Prioritize constitution violations**
