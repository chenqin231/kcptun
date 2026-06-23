## 6. 代码组织

### 脚本结构模板

```bash
#!/usr/bin/env bash
# 脚本名称
# 详细说明脚本的用途和使用方法

set -euo pipefail

# ============================================================================
# 全局常量
# ============================================================================

readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly SCRIPT_NAME="$(basename "$0")"
readonly VERSION="1.0.0"

# ============================================================================
# 颜色定义
# ============================================================================

readonly COLOR_RESET='\033[0m'
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_BLUE='\033[0;34m'

# ============================================================================
# 输出函数
# ============================================================================

info() {
    echo -e "${COLOR_BLUE}ℹ${COLOR_RESET} $*"
}

success() {
    echo -e "${COLOR_GREEN}✓${COLOR_RESET} $*"
}

error() {
    echo -e "${COLOR_RED}✗${COLOR_RESET} $*" >&2
}

# ============================================================================
# 业务逻辑函数
# ============================================================================

parse_arguments() {
    # 参数解析
}

validate_input() {
    # 输入验证
}

# ============================================================================
# 主函数
# ============================================================================

main() {
    parse_arguments "$@"
    validate_input
    # 业务逻辑
}

# ============================================================================
# 脚本入口
# ============================================================================

main "$@"
```

### 模块化（sourcing）

```bash
# lib/common.sh
info() {
    echo -e "${COLOR_BLUE}ℹ${COLOR_RESET} $*"
}

# main.sh
#!/usr/bin/env bash
set -euo pipefail

# 加载库文件
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "${SCRIPT_DIR}/lib/common.sh"

main() {
    info "开始执行"
}

main "$@"
```

---

## 7. 测试方法

### 使用 bats-core 进行单元测试

```bash
# 安装 bats-core
git clone https://github.com/bats-core/bats-core.git
cd bats-core
sudo ./install.sh /usr/local

# 测试文件: test/validate.bats
#!/usr/bin/env bats

# 加载被测试的脚本
load '../lib/validate.sh'

@test "validate_email: 有效邮箱" {
    run validate_email "user@example.com"
    [ "$status" -eq 0 ]
}

@test "validate_email: 无效邮箱" {
    run validate_email "invalid-email"
    [ "$status" -eq 1 ]
}

@test "validate_file: 文件存在" {
    touch /tmp/test-file
    run validate_file "/tmp/test-file"
    [ "$status" -eq 0 ]
    rm /tmp/test-file
}

# 运行测试
bats test/validate.bats
```

### 测试技巧

```bash
# 1. 测试输出内容
@test "info: 输出正确的消息" {
    run info "测试消息"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "测试消息" ]]
}

# 2. 测试错误处理
@test "error: 输出到 stderr" {
    run error "错误消息"
    [ "$status" -eq 0 ]
    [[ "$output" =~ "错误消息" ]]
}

# 3. Mock 外部命令
@test "使用 mock 测试" {
    # 创建假的 git 命令
    git() {
        echo "mocked git"
    }
    export -f git

    run my_function_that_uses_git
    [ "$status" -eq 0 ]
}
```
