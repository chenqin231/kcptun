#!/usr/bin/env bash
# 阶段推进脚本（原子操作：Guard 检查 + 状态推进）
# 用法: ./advance-stage.sh --stage <name> [--branch <name>] [--json]

set -e

SCRIPT_DIR="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

TARGET_STAGE=""
BRANCH=""
JSON_MODE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --stage)  shift; TARGET_STAGE="$1" ;;
        --branch) shift; BRANCH="$1" ;;
        --json)   JSON_MODE=true ;;
        --help|-h)
            echo "用法: advance-stage.sh --stage <name> [--branch <name>] [--json]"
            echo "阶段: requirements|plan|tasks|develop"
            exit 0
            ;;
        *) echo "ERROR: 未知参数 '$1'" >&2; exit 1 ;;
    esac
    shift
done

if [[ -z "$TARGET_STAGE" ]]; then
    echo "ERROR: 必须指定 --stage 参数" >&2
    exit 1
fi

# 设置分支覆盖
[[ -n "$BRANCH" ]] && export SPECIFY_FEATURE="$BRANCH"

# 获取路径信息
eval $(get_feature_paths)

# 验证 progress.json 存在
PROGRESS_FILE="$REPO_ROOT/specs/progress.json"
if [[ ! -f "$PROGRESS_FILE" ]]; then
    echo "ERROR: specs/progress.json 不存在，请先运行 /speckit.specify" >&2
    exit 1
fi

# Guard: 验证目标阶段有效
STAGES=("research" "requirements" "plan" "tasks" "develop")
valid=false
target_idx=-1
for i in "${!STAGES[@]}"; do
    if [[ "${STAGES[$i]}" == "$TARGET_STAGE" ]]; then
        valid=true
        target_idx=$i
    fi
done
if ! $valid; then
    echo "ERROR: 无效阶段 '$TARGET_STAGE'，有效值: ${STAGES[*]}" >&2
    exit 1
fi

# Guard: 检查前序阶段状态（跳过 skipped，拦截 pending）
guard_passed=true
blocker_stage=""
blocker_status=""
for (( i=target_idx-1; i>=0; i-- )); do
    prev="${STAGES[$i]}"
    status=$(grep -o "\"$prev\"[[:space:]]*:[[:space:]]*\"[^\"]*\"" "$PROGRESS_FILE" \
        | head -1 | sed 's/.*"\([^"]*\)"$/\1/')

    [[ "$status" == "skipped" ]] && continue

    if [[ "$status" == "pending" ]]; then
        guard_passed=false
        blocker_stage="$prev"
        blocker_status="$status"
    fi
    break
done

if ! $guard_passed; then
    if $JSON_MODE; then
        printf '{"error":true,"target":"%s","blocker":"%s","status":"%s"}\n' \
            "$TARGET_STAGE" "$blocker_stage" "$blocker_status"
    else
        echo "ERROR: 前序阶段 '$blocker_stage' 状态为 $blocker_status，必须先完成" >&2
    fi
    exit 1
fi

# Guard: 验证前序阶段必需文件
missing_file=""
case "$TARGET_STAGE" in
    plan)    [[ ! -f "$FEATURE_SPEC" ]] && missing_file="spec.md" ;;
    tasks)   [[ ! -f "$IMPL_PLAN" ]]    && missing_file="plan.md" ;;
    develop) [[ ! -f "$TASKS" ]]         && missing_file="tasks.md" ;;
esac

if [[ -n "$missing_file" ]]; then
    if $JSON_MODE; then
        printf '{"error":true,"target":"%s","missingFile":"%s","featureDir":"%s"}\n' \
            "$TARGET_STAGE" "$missing_file" "$FEATURE_DIR"
    else
        echo "ERROR: 缺少必需文件 '$missing_file'（位于 $FEATURE_DIR）" >&2
    fi
    exit 1
fi

# Advance: 推进阶段
update_progress_stage "$TARGET_STAGE"

if $JSON_MODE; then
    printf '{"stage":"%s","status":"advanced"}\n' "$TARGET_STAGE"
else
    echo "Stage advanced to $TARGET_STAGE"
fi
