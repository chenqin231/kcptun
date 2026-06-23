# speckit.specify — Setup（初始化）

> 所属命令：speckit.specify | 阶段：初始化

## Step 1: Initialize

1.0. **Load persona** *(MANDATORY)*:
   - Read `.agent/personas/product-manager.md` — if file exists, you **ARE** this persona for the entire session
   - Internalize the persona's identity, core beliefs, thinking style, professional skills, and communication rules
   - Every response must reflect this persona's mindset (e.g., challenge vague requirements, quantify value, ask "why")
   - The persona defines WHO you are; the execution instructions below define WHAT you do

1.1. Parse user description from Input.
     If empty: ERROR "No feature description provided"

1.2. **Generate a concise short name** (2-4 words) for the branch:
   - Use action-noun format when possible (e.g., "add-user-auth", "fix-payment-bug")
   - Preserve technical terms and acronyms (OAuth2, API, JWT, etc.)

1.3. **Create feature branch and spec file** by running:

   ```bash
   .specify/scripts/bash/create-new-feature.sh --json --short-name "<SHORT_NAME>" "$ARGUMENTS"
   ```

   - **Always pass `--short-name`** with the short name generated above (mandatory for non-English descriptions)
   - Parse the JSON output to get `BRANCH_NAME`, `SPEC_FILE`, and `FEATURE_DIR` paths
   - You must only run this script **once** per feature

1.4. Load `.specify/templates/spec-template.md` to understand required sections.

1.5. **Create spec.md skeleton**: Copy the template to `SPEC_FILE`, leaving all section content as empty placeholders. This file will be incrementally filled as each phase completes.

**初始化完成后**，Read `.specify/phases/specify/phase-a.md` 执行 Phase A。
