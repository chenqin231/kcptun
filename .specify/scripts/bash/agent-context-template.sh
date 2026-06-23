#!/usr/bin/env bash
# agent-context-template.sh — 模板变量替换模块
#
# 职责: 从模板创建新 agent 文件 / 更新已有 agent 文件内容
# 依赖: 由主入口 source 加载，需要全局变量和 log_*/format_technology_stack
# 导出: create_new_agent_file(), update_existing_agent_file()

[[ -n "${_AGENT_CONTEXT_TEMPLATE_LOADED:-}" ]] && return 0
_AGENT_CONTEXT_TEMPLATE_LOADED=1

# 根据项目类型生成目录结构
get_project_structure() {
    if [[ "$1" == *"web"* ]]; then
        echo "backend/\\nfrontend/\\ntests/"
    else
        echo "src/\\ntests/"
    fi
}

# 根据语言生成构建/测试命令
get_commands_for_language() {
    case "$1" in
        *"Python"*)  echo "cd src && pytest && ruff check ." ;;
        *"Rust"*)    echo "cargo test && cargo clippy" ;;
        *"JavaScript"*|*"TypeScript"*) echo "npm test \\&\\& npm run lint" ;;
        *)           echo "# Add commands for $1" ;;
    esac
}

# 从模板创建新的 agent 文件
create_new_agent_file() {
    local target_file="$1" temp_file="$2" project_name="$3" current_date="$4"

    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_error "Template not found at $TEMPLATE_FILE"; return 1
    fi
    if [[ ! -r "$TEMPLATE_FILE" ]]; then
        log_error "Template file is not readable: $TEMPLATE_FILE"; return 1
    fi

    log_info "Creating new agent context file from template..."
    if ! cp "$TEMPLATE_FILE" "$temp_file"; then
        log_error "Failed to copy template file"; return 1
    fi

    local project_structure=$(get_project_structure "$NEW_PROJECT_TYPE")
    local commands=$(get_commands_for_language "$NEW_LANG")

    # 转义 sed 特殊字符
    local escaped_lang=$(printf '%s\n' "$NEW_LANG" | sed 's/[\[\.*^$()+{}|]/\\&/g')
    local escaped_framework=$(printf '%s\n' "$NEW_FRAMEWORK" | sed 's/[\[\.*^$()+{}|]/\\&/g')
    local escaped_branch=$(printf '%s\n' "$CURRENT_BRANCH" | sed 's/[\[\.*^$()+{}|]/\\&/g')

    # 构造技术栈和变更记录字符串
    local tech_stack recent_change
    if [[ -n "$escaped_lang" && -n "$escaped_framework" ]]; then
        tech_stack="- $escaped_lang + $escaped_framework ($escaped_branch)"
        recent_change="- $escaped_branch: Added $escaped_lang + $escaped_framework"
    elif [[ -n "$escaped_lang" ]]; then
        tech_stack="- $escaped_lang ($escaped_branch)"
        recent_change="- $escaped_branch: Added $escaped_lang"
    elif [[ -n "$escaped_framework" ]]; then
        tech_stack="- $escaped_framework ($escaped_branch)"
        recent_change="- $escaped_branch: Added $escaped_framework"
    else
        tech_stack="- ($escaped_branch)"
        recent_change="- $escaped_branch: Added"
    fi

    local substitutions=(
        "s|\[PROJECT NAME\]|$project_name|"
        "s|\[DATE\]|$current_date|"
        "s|\[EXTRACTED FROM ALL PLAN.MD FILES\]|$tech_stack|"
        "s|\[ACTUAL STRUCTURE FROM PLANS\]|$project_structure|g"
        "s|\[ONLY COMMANDS FOR ACTIVE TECHNOLOGIES\]|$commands|"
        "s|\[LANGUAGE-SPECIFIC, ONLY FOR LANGUAGES IN USE\]|$NEW_LANG: Follow standard conventions|"
        "s|\[LAST 3 FEATURES AND WHAT THEY ADDED\]|$recent_change|"
    )
    for substitution in "${substitutions[@]}"; do
        if ! sed -i.bak -e "$substitution" "$temp_file"; then
            log_error "Failed to perform substitution: $substitution"
            rm -f "$temp_file" "$temp_file.bak"; return 1
        fi
    done

    # 将 \n 序列转为实际换行
    local newline=$(printf '\n')
    sed -i.bak2 "s/\\\\n/${newline}/g" "$temp_file"
    rm -f "$temp_file.bak" "$temp_file.bak2"
    return 0
}

# 更新已有 agent 文件
update_existing_agent_file() {
    local target_file="$1" current_date="$2"
    log_info "Updating existing agent context file..."

    local temp_file
    temp_file=$(mktemp) || { log_error "Failed to create temporary file"; return 1; }

    local tech_stack=$(format_technology_stack "$NEW_LANG" "$NEW_FRAMEWORK")
    local new_tech_entries=()
    local new_change_entry=""

    # 准备新条目
    if [[ -n "$tech_stack" ]] && ! grep -q "$tech_stack" "$target_file"; then
        new_tech_entries+=("- $tech_stack ($CURRENT_BRANCH)")
    fi
    if [[ -n "$NEW_DB" && "$NEW_DB" != "N/A" && "$NEW_DB" != "NEEDS CLARIFICATION" ]] && ! grep -q "$NEW_DB" "$target_file"; then
        new_tech_entries+=("- $NEW_DB ($CURRENT_BRANCH)")
    fi
    if [[ -n "$tech_stack" ]]; then
        new_change_entry="- $CURRENT_BRANCH: Added $tech_stack"
    elif [[ -n "$NEW_DB" && "$NEW_DB" != "N/A" && "$NEW_DB" != "NEEDS CLARIFICATION" ]]; then
        new_change_entry="- $CURRENT_BRANCH: Added $NEW_DB"
    fi

    local has_active_technologies=0 has_recent_changes=0
    grep -q "^## Active Technologies" "$target_file" 2>/dev/null && has_active_technologies=1
    grep -q "^## Recent Changes" "$target_file" 2>/dev/null && has_recent_changes=1

    local in_tech_section=false in_changes_section=false
    local tech_entries_added=false changes_entries_added=false existing_changes_count=0

    while IFS= read -r line || [[ -n "$line" ]]; do
        if [[ "$line" == "## Active Technologies" ]]; then
            echo "$line" >> "$temp_file"; in_tech_section=true; continue
        elif [[ $in_tech_section == true ]] && [[ "$line" =~ ^##[[:space:]] || -z "$line" ]]; then
            if [[ $tech_entries_added == false && ${#new_tech_entries[@]} -gt 0 ]]; then
                printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"; tech_entries_added=true
            fi
            echo "$line" >> "$temp_file"
            [[ "$line" =~ ^##[[:space:]] ]] && in_tech_section=false
            continue
        fi
        if [[ "$line" == "## Recent Changes" ]]; then
            echo "$line" >> "$temp_file"
            [[ -n "$new_change_entry" ]] && echo "$new_change_entry" >> "$temp_file"
            in_changes_section=true; changes_entries_added=true; continue
        elif [[ $in_changes_section == true ]] && [[ "$line" =~ ^##[[:space:]] ]]; then
            echo "$line" >> "$temp_file"; in_changes_section=false; continue
        elif [[ $in_changes_section == true && "$line" == "- "* ]]; then
            if [[ $existing_changes_count -lt 2 ]]; then
                echo "$line" >> "$temp_file"; ((existing_changes_count++))
            fi
            continue
        fi
        if [[ "$line" =~ \*\*Last\ updated\*\*:.*[0-9]{4}-[0-9]{2}-[0-9]{2} ]]; then
            echo "$line" | sed "s/[0-9]\{4\}-[0-9]\{2\}-[0-9]\{2\}/$current_date/" >> "$temp_file"
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$target_file"

    # 循环结束后: 若仍在 tech section 且未添加
    if [[ $in_tech_section == true && $tech_entries_added == false && ${#new_tech_entries[@]} -gt 0 ]]; then
        printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
    fi
    # 若 section 不存在则追加
    if [[ $has_active_technologies -eq 0 && ${#new_tech_entries[@]} -gt 0 ]]; then
        echo "" >> "$temp_file"; echo "## Active Technologies" >> "$temp_file"
        printf '%s\n' "${new_tech_entries[@]}" >> "$temp_file"
    fi
    if [[ $has_recent_changes -eq 0 && -n "$new_change_entry" ]]; then
        echo "" >> "$temp_file"; echo "## Recent Changes" >> "$temp_file"
        echo "$new_change_entry" >> "$temp_file"
    fi

    if ! mv "$temp_file" "$target_file"; then
        log_error "Failed to update target file"; rm -f "$temp_file"; return 1
    fi
    return 0
}
