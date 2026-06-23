#!/usr/bin/env bash
# Common functions and variables for all scripts

# Get repository root, with fallback for non-git repositories
get_repo_root() {
    if git rev-parse --show-toplevel >/dev/null 2>&1; then
        git rev-parse --show-toplevel
    else
        # Fall back to script location for non-git repos
        local script_dir="$(CDPATH="" cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
        (cd "$script_dir/../../.." && pwd)
    fi
}

# Get current branch, with multi-level fallback
# 优先级: SPECIFY_FEATURE > git 分支(非 master/main) > progress.json > worktrees/ > specs/ > "main"
get_current_branch() {
    # 优先级 1: SPECIFY_FEATURE 环境变量（--branch 参数通过设置此变量生效）
    if [[ -n "${SPECIFY_FEATURE:-}" ]]; then
        echo "$SPECIFY_FEATURE"
        return
    fi

    # 优先级 2: git 分支检测（非 master/main 时直接返回）
    if git rev-parse --abbrev-ref HEAD >/dev/null 2>&1; then
        local git_branch
        git_branch=$(git rev-parse --abbrev-ref HEAD)
        if [[ "$git_branch" != "master" && "$git_branch" != "main" ]]; then
            echo "$git_branch"
            return
        fi
    fi

    # 优先级 3: 读 progress.json
    local progress_branch
    progress_branch=$(read_progress_branch)
    if [[ -n "$progress_branch" ]]; then
        echo "$progress_branch"
        return
    fi

    # 优先级 4: 扫描 worktrees/（按数字前缀降序取最大编号）
    local repo_root
    repo_root=$(get_repo_root)
    if [[ -d "$repo_root/worktrees" ]]; then
        local latest
        latest=$(ls "$repo_root/worktrees/" 2>/dev/null | grep -E '^[0-9]+-' | sort -t'-' -k1 -rn | head -1)
        if [[ -n "$latest" ]]; then
            echo "$latest"
            return
        fi
    fi

    # 优先级 5: 扫描 specs/（按数字前缀降序取最大编号，兼容非 git 仓库）
    local specs_dir="$repo_root/specs"
    if [[ -d "$specs_dir" ]]; then
        local latest_feature=""
        local highest=0
        for dir in "$specs_dir"/*; do
            if [[ -d "$dir" ]]; then
                local dirname=$(basename "$dir")
                if [[ "$dirname" =~ ^([0-9]{3})- ]]; then
                    local number=${BASH_REMATCH[1]}
                    number=$((10#$number))
                    if [[ "$number" -gt "$highest" ]]; then
                        highest=$number
                        latest_feature=$dirname
                    fi
                fi
            fi
        done
        if [[ -n "$latest_feature" ]]; then
            echo "$latest_feature"
            return
        fi
    fi

    echo "main"  # 最终兜底
}

# Check if we have git available
has_git() {
    git rev-parse --show-toplevel >/dev/null 2>&1
}

check_feature_branch() {
    local branch="$1"
    local has_git_repo="$2"

    # For non-git repos, we can't enforce branch naming but still provide output
    if [[ "$has_git_repo" != "true" ]]; then
        echo "[specify] Warning: Git repository not detected; skipped branch validation" >&2
        return 0
    fi

    if [[ ! "$branch" =~ ^[0-9]{3}- ]]; then
        echo "ERROR: Not on a feature branch. Current branch: $branch" >&2
        echo "Feature branches should be named like: 001-feature-name" >&2
        return 1
    fi

    return 0
}

get_feature_dir() { echo "$1/specs/$2"; }

# Find feature directory by numeric prefix instead of exact branch match
# This allows multiple branches to work on the same spec (e.g., 004-fix-bug, 004-add-feature)
find_feature_dir_by_prefix() {
    local repo_root="$1"
    local branch_name="$2"
    local specs_dir="$repo_root/specs"

    # Extract numeric prefix from branch (e.g., "004" from "004-whatever")
    if [[ ! "$branch_name" =~ ^([0-9]{3})- ]]; then
        # If branch doesn't have numeric prefix, fall back to exact match
        echo "$specs_dir/$branch_name"
        return
    fi

    local prefix="${BASH_REMATCH[1]}"

    # Search for directories in specs/ that start with this prefix
    local matches=()
    if [[ -d "$specs_dir" ]]; then
        for dir in "$specs_dir"/"$prefix"-*; do
            if [[ -d "$dir" ]]; then
                matches+=("$(basename "$dir")")
            fi
        done
    fi

    # Handle results
    if [[ ${#matches[@]} -eq 0 ]]; then
        # No match found - return the branch name path (will fail later with clear error)
        echo "$specs_dir/$branch_name"
    elif [[ ${#matches[@]} -eq 1 ]]; then
        # Exactly one match - perfect!
        echo "$specs_dir/${matches[0]}"
    else
        # Multiple matches - this shouldn't happen with proper naming convention
        echo "ERROR: Multiple spec directories found with prefix '$prefix': ${matches[*]}" >&2
        echo "Please ensure only one spec directory exists per numeric prefix." >&2
        echo "$specs_dir/$branch_name"  # Return something to avoid breaking the script
    fi
}

get_feature_paths() {
    local repo_root=$(get_repo_root)
    local current_branch=$(get_current_branch)
    local has_git_repo="false"

    if has_git; then
        has_git_repo="true"
    fi

    # Use prefix-based lookup to support multiple branches per spec
    local feature_dir=$(find_feature_dir_by_prefix "$repo_root" "$current_branch")

    cat <<EOF
REPO_ROOT='$repo_root'
CURRENT_BRANCH='$current_branch'
HAS_GIT='$has_git_repo'
FEATURE_DIR='$feature_dir'
FEATURE_SPEC='$feature_dir/spec.md'
IMPL_PLAN='$feature_dir/plan.md'
TASKS='$feature_dir/tasks.md'
RESEARCH='$feature_dir/research.md'
DATA_MODEL='$feature_dir/data-model.md'
QUICKSTART='$feature_dir/quickstart.md'
CONTRACTS_DIR='$feature_dir/contracts'
EOF
}

# 获取当前分支对应的 worktree 路径（如存在）
# 返回 worktree 路径，不存在时返回空字符串
get_worktree_path() {
    local branch_name="${1:-$(get_current_branch)}"
    local repo_root
    repo_root=$(get_repo_root)
    local worktree_dir="$repo_root/worktrees/$branch_name"

    if [[ -d "$worktree_dir" ]]; then
        echo "$worktree_dir"
    fi
}

# 加载 progress.json 读写函数（拆分为独立模块）
source "${BASH_SOURCE[0]%/*}/progress.sh"

# 转义 JSON 字符串中的特殊字符（反斜杠和双引号）
json_escape() { printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'; }

check_file() { [[ -f "$1" ]] && echo "  ✓ $2" || echo "  ✗ $2"; }
check_dir() { [[ -d "$1" && -n $(ls -A "$1" 2>/dev/null) ]] && echo "  ✓ $2" || echo "  ✗ $2"; }

