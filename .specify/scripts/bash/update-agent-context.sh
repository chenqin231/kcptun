#!/usr/bin/env bash
# update-agent-context.sh — 主入口/调度器
#
# 从 plan.md 提取项目信息并更新各 AI agent 上下文文件。
# 用法: ./update-agent-context.sh [agent_type]
# 留空则更新所有已有的 agent 文件。

set -euo pipefail

# 加载公共库和子模块
SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/agent-context-validate.sh"
source "$SCRIPT_DIR/agent-context-parse.sh"
source "$SCRIPT_DIR/agent-context-template.sh"
source "$SCRIPT_DIR/agent-context-writers.sh"

# 全局配置
eval $(get_feature_paths)
NEW_PLAN="$IMPL_PLAN"
AGENT_TYPE="${1:-}"
NEW_LANG=""
NEW_FRAMEWORK=""
NEW_DB=""
NEW_PROJECT_TYPE=""
init_agent_paths

# 临时文件清理
cleanup() {
    local exit_code=$?
    rm -f /tmp/agent_update_*_$$ /tmp/manual_additions_$$
    exit $exit_code
}
trap cleanup EXIT INT TERM

# Main
main() {
    validate_environment
    log_info "=== Updating agent context files for feature $CURRENT_BRANCH ==="

    if ! parse_plan_data "$NEW_PLAN"; then
        log_error "Failed to parse plan data"
        exit 1
    fi

    local success=true
    if [[ -z "$AGENT_TYPE" ]]; then
        log_info "No agent specified, updating all existing agent files..."
        if ! update_all_existing_agents; then success=false; fi
    else
        log_info "Updating specific agent: $AGENT_TYPE"
        if ! update_specific_agent "$AGENT_TYPE"; then success=false; fi
    fi

    print_summary

    if [[ "$success" == true ]]; then
        log_success "Agent context update completed successfully"
    else
        log_error "Agent context update completed with errors"
        exit 1
    fi
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
