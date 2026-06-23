#!/usr/bin/env bash
# progress.json 读写函数
# 被 common.sh 自动加载，不应直接 source 此文件
# 依赖: get_repo_root(), json_escape()（由 common.sh 提供）

# 从 specs/progress.json 读取当前活跃功能的分支名
# 返回: branch 字符串，无文件或解析失败返回空
read_progress_branch() {
    local repo_root
    repo_root=$(get_repo_root)
    local progress_file="$repo_root/specs/progress.json"
    if [[ -f "$progress_file" ]]; then
        # 用 grep+sed 提取，避免依赖 jq
        grep -o '"branch"[[:space:]]*:[[:space:]]*"[^"]*"' "$progress_file" \
            | head -1 | sed 's/.*"\([^"]*\)"$/\1/'
    fi
}

# 初始写入 progress.json（create-new-feature.sh 调用）
# 参数: feature_name branch_name worktree_path [mode]
#   mode: "full" = research 为 in_progress（完整模式）
#         "simplified" = research 为 skipped（精简模式，默认）
write_progress() {
    local feature="$1" branch="$2" worktree_path="${3:-}" mode="${4:-simplified}"
    local repo_root
    repo_root=$(get_repo_root)
    local progress_file="$repo_root/specs/progress.json"
    local now
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # 对用户输入进行 JSON 转义，防止非法 JSON
    local esc_feature esc_branch esc_worktree esc_specs_dir
    esc_feature=$(json_escape "$feature")
    esc_branch=$(json_escape "$branch")
    esc_worktree=$(json_escape "${worktree_path:-}")
    esc_specs_dir=$(json_escape "specs/$feature")

    local research_status="skipped"
    local initial_stage="requirements"
    local initial_label="需求阶段"
    local req_status="in_progress"
    if [[ "$mode" == "full" ]]; then
        research_status="in_progress"
        initial_stage="research"
        initial_label="研究阶段"
        req_status="pending"
    fi

    cat > "$progress_file" << EOF
{
  "feature": "$esc_feature",
  "branch": "$esc_branch",
  "specsDir": "$esc_specs_dir",
  "worktreePath": "$esc_worktree",
  "stage": "$initial_stage",
  "stageLabel": "$initial_label",
  "stages": {
    "research": "$research_status",
    "requirements": "$req_status",
    "plan": "pending",
    "tasks": "pending",
    "develop": "pending"
  },
  "currentTask": null,
  "totalTasks": 0,
  "completedTasks": 0,
  "updatedAt": "$now"
}
EOF
}

# 更新 progress.json 的阶段状态（原子操作：临时文件 + mv）
# 参数: new_stage (requirements|plan|tasks|develop)
update_progress_stage() {
    local new_stage="$1"
    local repo_root
    repo_root=$(get_repo_root)
    local progress_file="$repo_root/specs/progress.json"

    [[ ! -f "$progress_file" ]] && return 1

    local now
    now=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    local stage_label=""
    case "$new_stage" in
        requirements) stage_label="需求阶段" ;;
        plan)         stage_label="设计阶段" ;;
        tasks)        stage_label="任务分解阶段" ;;
        develop)      stage_label="开发阶段" ;;
        *)            stage_label="$new_stage" ;;
    esac

    # 使用临时文件实现原子写入，中断时不会损坏原文件
    local tmp_file="${progress_file}.tmp.$$"
    trap 'rm -f "$tmp_file"' RETURN
    cp "$progress_file" "$tmp_file"

    # 平台检测：macOS 用 sed -i ''，Linux 用 sed -i
    local sed_i_flag=(-i)
    if [[ "$(uname -s)" == "Darwin" ]]; then
        sed_i_flag=(-i '')
    fi

    # 更新顶层字段
    sed "${sed_i_flag[@]}" \
        -e "s/\"stage\": *\"[^\"]*\"/\"stage\": \"$new_stage\"/" \
        -e "s/\"stageLabel\": *\"[^\"]*\"/\"stageLabel\": \"$stage_label\"/" \
        -e "s/\"updatedAt\": *\"[^\"]*\"/\"updatedAt\": \"$now\"/" \
        "$tmp_file"

    # 将前一阶段标记为 completed，当前阶段标记为 in_progress
    # 阶段顺序: research → requirements → plan → tasks → develop
    local stages=("research" "requirements" "plan" "tasks" "develop")
    local found=false
    for s in "${stages[@]}"; do
        if [[ "$s" == "$new_stage" ]]; then
            sed "${sed_i_flag[@]}" \
                "s/\"$s\": *\"[^\"]*\"/\"$s\": \"in_progress\"/" "$tmp_file"
            found=true
        elif ! $found; then
            # 前置阶段：如果不是 skipped 就标记 completed
            local current_val
            current_val=$(grep -o "\"$s\": *\"[^\"]*\"" "$tmp_file" \
                | sed 's/.*"\([^"]*\)"$/\1/')
            if [[ "$current_val" != "skipped" ]]; then
                sed "${sed_i_flag[@]}" \
                    "s/\"$s\": *\"[^\"]*\"/\"$s\": \"completed\"/" "$tmp_file"
            fi
        fi
    done

    # 原子替换：mv 是 POSIX 原子操作（同文件系统）
    mv "$tmp_file" "$progress_file"
}
