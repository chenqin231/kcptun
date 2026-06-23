#!/usr/bin/env bash
# agent-context-writers.sh — Agent 文件路径 + 写入与路由模块
#
# 职责: 定义 agent 文件路径 + 统一更新入口 + 按类型路由 + 批量更新
# 依赖: 由主入口 source 加载，需要 REPO_ROOT 和 create_new/update_existing 函数
# 导出: init_agent_paths(), update_agent_file(), update_specific_agent(),
#        update_all_existing_agents(), print_summary()

# 防止重复加载
[[ -n "${_AGENT_CONTEXT_WRITERS_LOADED:-}" ]] && return 0
_AGENT_CONTEXT_WRITERS_LOADED=1

# Agent 文件路径初始化（需要 REPO_ROOT 已设置）
init_agent_paths() {
    CLAUDE_FILE="$REPO_ROOT/CLAUDE.md"
    GEMINI_FILE="$REPO_ROOT/GEMINI.md"
    COPILOT_FILE="$REPO_ROOT/.github/agents/copilot-instructions.md"
    CURSOR_FILE="$REPO_ROOT/.cursor/rules/specify-rules.mdc"
    QWEN_FILE="$REPO_ROOT/QWEN.md"
    AGENTS_FILE="$REPO_ROOT/AGENTS.md"
    WINDSURF_FILE="$REPO_ROOT/.windsurf/rules/specify-rules.md"
    KILOCODE_FILE="$REPO_ROOT/.kilocode/rules/specify-rules.md"
    AUGGIE_FILE="$REPO_ROOT/.augment/rules/specify-rules.md"
    ROO_FILE="$REPO_ROOT/.roo/rules/specify-rules.md"
    CODEBUDDY_FILE="$REPO_ROOT/CODEBUDDY.md"
    QODER_FILE="$REPO_ROOT/QODER.md"
    AMP_FILE="$REPO_ROOT/AGENTS.md"
    SHAI_FILE="$REPO_ROOT/SHAI.md"
    Q_FILE="$REPO_ROOT/AGENTS.md"
    AGY_FILE="$REPO_ROOT/.agent/rules/specify-rules.md"
    BOB_FILE="$REPO_ROOT/AGENTS.md"
    TEMPLATE_FILE="$REPO_ROOT/.specify/templates/agent-file-template.md"
}

# 统一的 Agent 文件更新入口
update_agent_file() {
    local target_file="$1"
    local agent_name="$2"

    if [[ -z "$target_file" ]] || [[ -z "$agent_name" ]]; then
        log_error "update_agent_file requires target_file and agent_name parameters"
        return 1
    fi

    log_info "Updating $agent_name context file: $target_file"

    local project_name
    project_name=$(basename "$REPO_ROOT")
    local current_date
    current_date=$(date +%Y-%m-%d)

    # 确保目标目录存在
    local target_dir
    target_dir=$(dirname "$target_file")
    if [[ ! -d "$target_dir" ]]; then
        if ! mkdir -p "$target_dir"; then
            log_error "Failed to create directory: $target_dir"
            return 1
        fi
    fi

    if [[ ! -f "$target_file" ]]; then
        # 从模板创建新文件
        local temp_file
        temp_file=$(mktemp) || {
            log_error "Failed to create temporary file"
            return 1
        }

        if create_new_agent_file "$target_file" "$temp_file" "$project_name" "$current_date"; then
            if mv "$temp_file" "$target_file"; then
                log_success "Created new $agent_name context file"
            else
                log_error "Failed to move temporary file to $target_file"
                rm -f "$temp_file"
                return 1
            fi
        else
            log_error "Failed to create new agent file"
            rm -f "$temp_file"
            return 1
        fi
    else
        # 更新已有文件
        if [[ ! -r "$target_file" ]]; then
            log_error "Cannot read existing file: $target_file"
            return 1
        fi
        if [[ ! -w "$target_file" ]]; then
            log_error "Cannot write to existing file: $target_file"
            return 1
        fi

        if update_existing_agent_file "$target_file" "$current_date"; then
            log_success "Updated existing $agent_name context file"
        else
            log_error "Failed to update existing agent file"
            return 1
        fi
    fi

    return 0
}

# 按类型更新指定 agent
update_specific_agent() {
    local agent_type="$1"

    case "$agent_type" in
        claude)       update_agent_file "$CLAUDE_FILE" "Claude Code" ;;
        gemini)       update_agent_file "$GEMINI_FILE" "Gemini CLI" ;;
        copilot)      update_agent_file "$COPILOT_FILE" "GitHub Copilot" ;;
        cursor-agent) update_agent_file "$CURSOR_FILE" "Cursor IDE" ;;
        qwen)         update_agent_file "$QWEN_FILE" "Qwen Code" ;;
        opencode)     update_agent_file "$AGENTS_FILE" "opencode" ;;
        codex)        update_agent_file "$AGENTS_FILE" "Codex CLI" ;;
        windsurf)     update_agent_file "$WINDSURF_FILE" "Windsurf" ;;
        kilocode)     update_agent_file "$KILOCODE_FILE" "Kilo Code" ;;
        auggie)       update_agent_file "$AUGGIE_FILE" "Auggie CLI" ;;
        roo)          update_agent_file "$ROO_FILE" "Roo Code" ;;
        codebuddy)    update_agent_file "$CODEBUDDY_FILE" "CodeBuddy CLI" ;;
        qoder)        update_agent_file "$QODER_FILE" "Qoder CLI" ;;
        amp)          update_agent_file "$AMP_FILE" "Amp" ;;
        shai)         update_agent_file "$SHAI_FILE" "SHAI" ;;
        q)            update_agent_file "$Q_FILE" "Amazon Q Developer CLI" ;;
        agy)          update_agent_file "$AGY_FILE" "Antigravity" ;;
        bob)          update_agent_file "$BOB_FILE" "IBM Bob" ;;
        *)
            log_error "Unknown agent type '$agent_type'"
            log_error "Expected: claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|roo|amp|shai|q|agy|bob|qoder"
            exit 1
            ;;
    esac
}

# 批量更新所有已有 agent 文件（注册表驱动）
declare -a _AGENT_REGISTRY=(
    "CLAUDE_FILE:Claude Code"
    "GEMINI_FILE:Gemini CLI"
    "COPILOT_FILE:GitHub Copilot"
    "CURSOR_FILE:Cursor IDE"
    "QWEN_FILE:Qwen Code"
    "AGENTS_FILE:Codex/opencode"
    "WINDSURF_FILE:Windsurf"
    "KILOCODE_FILE:Kilo Code"
    "AUGGIE_FILE:Auggie CLI"
    "ROO_FILE:Roo Code"
    "CODEBUDDY_FILE:CodeBuddy CLI"
    "SHAI_FILE:SHAI"
    "QODER_FILE:Qoder CLI"
    "Q_FILE:Amazon Q Developer CLI"
    "AGY_FILE:Antigravity"
    "BOB_FILE:IBM Bob"
)

update_all_existing_agents() {
    local found_agent=false

    for entry in "${_AGENT_REGISTRY[@]}"; do
        local var_name="${entry%%:*}"
        local display_name="${entry#*:}"
        local file_path="${!var_name}"

        if [[ -f "$file_path" ]]; then
            update_agent_file "$file_path" "$display_name"
            found_agent=true
        fi
    done

    # 若没有任何 agent 文件，创建默认 Claude 文件
    if [[ "$found_agent" == false ]]; then
        log_info "No existing agent files found, creating default Claude file..."
        update_agent_file "$CLAUDE_FILE" "Claude Code"
    fi
}

# 打印变更摘要
print_summary() {
    echo
    log_info "Summary of changes:"
    [[ -n "$NEW_LANG" ]] && echo "  - Added language: $NEW_LANG"
    [[ -n "$NEW_FRAMEWORK" ]] && echo "  - Added framework: $NEW_FRAMEWORK"
    [[ -n "$NEW_DB" && "$NEW_DB" != "N/A" ]] && echo "  - Added database: $NEW_DB"
    echo
    log_info "Usage: $0 [claude|gemini|copilot|cursor-agent|qwen|opencode|codex|windsurf|kilocode|auggie|codebuddy|shai|q|agy|bob|qoder]"
}
