## 3. 错误处理

### 错误信息输出

```bash
# ✅ 错误信息输出到 stderr
error() {
    echo -e "${COLOR_RED}✗${COLOR_RESET} $*" >&2
}

warning() {
    echo -e "${COLOR_YELLOW}⚠${COLOR_RESET} $*" >&2
}

# ❌ 错误：错误信息输出到 stdout
error() {
    echo "Error: $*"  # 应该用 >&2
}
```

### 使用 trap 捕获错误

```bash
#!/usr/bin/env bash
set -euo pipefail

# 清理函数
cleanup() {
    local exit_code=$?

    # 清理临时文件
    [[ -n "${TMP_DIR:-}" ]] && rm -rf "$TMP_DIR"

    if [[ $exit_code -ne 0 ]]; then
        error "脚本执行失败，退出码: $exit_code"
    fi

    exit "$exit_code"
}

# 捕获 EXIT 信号
trap cleanup EXIT

# 捕获中断信号
trap 'error "脚本被用户中断"; exit 130' INT TERM

# 主逻辑
main() {
    TMP_DIR="$(mktemp -d)"
    # 业务逻辑...
}

main "$@"
```

### 命令检查

```bash
# ✅ 检查命令是否存在
check_command() {
    local cmd="$1"

    if ! command -v "$cmd" &>/dev/null; then
        error "未找到命令: $cmd"
        return 1
    fi
    return 0
}

# 使用示例
check_command "git" || exit 1
check_command "jq" || exit 1

# ❌ 错误：使用 which（不可移植）
if ! which git &>/dev/null; then
    # ...
fi
```

---

## 4. 变量规范

### 变量引用

```bash
# ✅ 始终使用引号
file_path="/path/to/file"
echo "处理文件: $file_path"
rm -f "$file_path"

# ✅ 数组引用
files=("file1.txt" "file2.txt" "file with spaces.txt")
for file in "${files[@]}"; do
    echo "$file"
done

# ❌ 错误：不加引号（会导致词分割问题）
file_path="/path/to/file with spaces.txt"
rm -f $file_path  # 会尝试删除 3 个文件！
```

### 局部变量与全局变量

```bash
# ✅ 函数内使用 local
calculate_total() {
    local price="$1"
    local quantity="$2"
    local total=$((price * quantity))

    echo "$total"
}

# ✅ 全局常量使用 readonly
readonly CONFIG_DIR="${HOME}/.config/myapp"
readonly VERSION="1.0.0"

# ❌ 错误：函数内不用 local（污染全局命名空间）
calculate_total() {
    price="$1"      # 全局变量！
    quantity="$2"   # 全局变量！
}
```

### 默认值

```bash
# ✅ 使用参数扩展设置默认值
log_level="${LOG_LEVEL:-info}"
config_file="${CONFIG_FILE:-config.yaml}"

# ✅ 带错误提示的必填参数
database_url="${DATABASE_URL:?错误: DATABASE_URL 未设置}"
```
