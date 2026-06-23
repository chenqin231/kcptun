#!/usr/bin/env bash
# agent-context-parse.sh — Plan 解析模块
#
# 职责: 从 plan.md 提取语言/框架/数据库/项目类型等结构化信息
# 依赖: 由主入口 source 加载，需要 log_info/log_warning/log_error 函数
# 导出: extract_plan_field(), parse_plan_data(), format_technology_stack()
# 副作用: 设置全局变量 NEW_LANG / NEW_FRAMEWORK / NEW_DB / NEW_PROJECT_TYPE

# 防止重复加载
[[ -n "${_AGENT_CONTEXT_PARSE_LOADED:-}" ]] && return 0
_AGENT_CONTEXT_PARSE_LOADED=1

#==============================================================================
# Plan 字段提取
#==============================================================================

extract_plan_field() {
    local field_pattern="$1"
    local plan_file="$2"

    grep "^\*\*${field_pattern}\*\*: " "$plan_file" 2>/dev/null | \
        head -1 | \
        sed "s|^\*\*${field_pattern}\*\*: ||" | \
        sed 's/^[ \t]*//;s/[ \t]*$//' | \
        grep -v "NEEDS CLARIFICATION" | \
        grep -v "^N/A$" || echo ""
}

#==============================================================================
# Plan 数据解析（设置全局变量）
#==============================================================================

parse_plan_data() {
    local plan_file="$1"

    if [[ ! -f "$plan_file" ]]; then
        log_error "Plan file not found: $plan_file"
        return 1
    fi

    if [[ ! -r "$plan_file" ]]; then
        log_error "Plan file is not readable: $plan_file"
        return 1
    fi

    log_info "Parsing plan data from $plan_file"

    NEW_LANG=$(extract_plan_field "Language/Version" "$plan_file")
    NEW_FRAMEWORK=$(extract_plan_field "Primary Dependencies" "$plan_file")
    NEW_DB=$(extract_plan_field "Storage" "$plan_file")
    NEW_PROJECT_TYPE=$(extract_plan_field "Project Type" "$plan_file")

    if [[ -n "$NEW_LANG" ]]; then
        log_info "Found language: $NEW_LANG"
    else
        log_warning "No language information found in plan"
    fi

    [[ -n "$NEW_FRAMEWORK" ]] && log_info "Found framework: $NEW_FRAMEWORK"
    [[ -n "$NEW_DB" && "$NEW_DB" != "N/A" ]] && log_info "Found database: $NEW_DB"
    [[ -n "$NEW_PROJECT_TYPE" ]] && log_info "Found project type: $NEW_PROJECT_TYPE"
}

#==============================================================================
# 技术栈格式化
#==============================================================================

format_technology_stack() {
    local lang="$1"
    local framework="$2"
    local parts=()

    [[ -n "$lang" && "$lang" != "NEEDS CLARIFICATION" ]] && parts+=("$lang")
    [[ -n "$framework" && "$framework" != "NEEDS CLARIFICATION" && "$framework" != "N/A" ]] && parts+=("$framework")

    if [[ ${#parts[@]} -eq 0 ]]; then
        echo ""
    elif [[ ${#parts[@]} -eq 1 ]]; then
        echo "${parts[0]}"
    else
        local result="${parts[0]}"
        for ((i=1; i<${#parts[@]}; i++)); do
            result="$result + ${parts[i]}"
        done
        echo "$result"
    fi
}
