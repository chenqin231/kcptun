#!/usr/bin/env bash
# agent-context-validate.sh — 日志工具 + 环境校验模块
#
# 职责: 提供日志函数 + 验证运行环境条件
# 依赖: 由主入口 source 加载，需要全局变量 CURRENT_BRANCH / HAS_GIT / NEW_PLAN / TEMPLATE_FILE
# 导出: log_info(), log_success(), log_error(), log_warning(), validate_environment()

# 防止重复加载
[[ -n "${_AGENT_CONTEXT_VALIDATE_LOADED:-}" ]] && return 0
_AGENT_CONTEXT_VALIDATE_LOADED=1

#==============================================================================
# 日志工具（所有子模块共用）
#==============================================================================

log_info()    { echo "INFO: $1"; }
log_success() { echo "✓ $1"; }
log_error()   { echo "ERROR: $1" >&2; }
log_warning() { echo "WARNING: $1" >&2; }

#==============================================================================
# 环境校验
#==============================================================================

validate_environment() {
    # 检查是否能确定当前分支/功能
    if [[ -z "$CURRENT_BRANCH" ]]; then
        log_error "Unable to determine current feature"
        if [[ "$HAS_GIT" == "true" ]]; then
            log_info "Make sure you're on a feature branch"
        else
            log_info "Set SPECIFY_FEATURE environment variable or create a feature first"
        fi
        exit 1
    fi

    # 检查 plan.md 是否存在
    if [[ ! -f "$NEW_PLAN" ]]; then
        log_error "No plan.md found at $NEW_PLAN"
        log_info "Make sure you're working on a feature with a corresponding spec directory"
        if [[ "$HAS_GIT" != "true" ]]; then
            log_info "Use: export SPECIFY_FEATURE=your-feature-name or create a new feature first"
        fi
        exit 1
    fi

    # 检查模板文件是否存在（创建新文件时需要）
    if [[ ! -f "$TEMPLATE_FILE" ]]; then
        log_warning "Template file not found at $TEMPLATE_FILE"
        log_warning "Creating new agent files will fail"
    fi
}
