# speckit.analyze — 检测通道 H-J（SMA 质量）

> 所属命令：speckit.analyze | 阶段：检测（Part 2）

### H. SMA Specificity Detection (Specific)

**Core question: Does each description have only one possible interpretation?**

| Sub-dim | Detection Target | Pass/Fail Rule |
|---------|-----------------|----------------|
| H1 Vague verb | Optimize/improve/handle/enhance/adjust/support/manage/ensure — verbs with no end-state | Verb followed by explicit end-state → Pass; no end-state → Flag |
| H2 Implicit subject/object | "Needs restart", "Returns error", "Performs validation" — missing subject or object | Complete subject + object + channel → Pass |
| H3 Unquantified qualifier | High performance/fast response/high availability — no numeric value | Followed by specific metric → Pass; none → Flag |
| H4 Ambiguous reference | "The frontend", "the backend", "that module", "related files" — unclear referent | Contextually unique → Pass; multiple possible referents → Flag |
| H5 Multiple interpretations | Contains "or"/"alternatively"/"optionally" without explicit choice | ≥2 reasonable interpretations → Flag |
| H6 Architecture consistency | New component placement/naming/communication/error handling matches project patterns | Depends on architecture context; skip if unavailable |

### I. SMA Measurability Detection (Measurable)

**Core question: Can acceptance criteria objectively determine "pass" or "fail"?**

| Sub-dim | Detection Target | Pass/Fail Rule |
|---------|-----------------|----------------|
| I1 Missing acceptance criteria | Requirement/task has functional description but no acceptance condition | Must have a decidable completion criterion |
| I2 Subjective judgment | "UX improved", "interface looks good", "performance acceptable" | No objective threshold → Flag |
| I3 Missing expected value | "Returns error" without status code, "logs message" without level | Fill in specific expected value |
| I4 Implicit side-effect | Impact on other parts after operation unspecified | Config change → restart? Entity deletion → cascade? |
| I5 Untestable | Depends on external environment/specific timing but no verification method specified | Must have an executable verification method |

### J. SMA Atomicity Detection (Atomic) — tasks.md only

**Core question: Does each task do one and only one thing?**

| Sub-dim | Detection Target | Pass/Fail Rule |
|---------|-----------------|----------------|
| J1 Compound task | "Implement XX and YY", single item with >3 verbs or >3 file paths | XX and YY independently completable → Should split |
| J2 Cross-boundary | Simultaneously modifies frontend + backend, business + data layer | Crosses ≥2 layers → Should split |
| J3 Granularity too coarse | "Implement user module", "Complete database design" | Cannot finish in a single commit → Should split |
| J4 Embedded dependency | "Based on XX implement YY" but XX has no standalone task | Implicit prerequisite → Should make explicit |

**SMA 检测完成后**，Read `.specify/phases/analyze/verdict.md` 生成判决报告。
