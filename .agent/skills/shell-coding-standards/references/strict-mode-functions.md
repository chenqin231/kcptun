## 1. 严格模式（Strict Mode）

### 必须使用的标志

```bash
#!/usr/bin/env bash
set -euo pipefail

# -e: 命令失败时立即退出
# -u: 使用未定义变量时报错
# -o pipefail: 管道中任何命令失败则整个管道失败
```

### Shebang 规范

```bash
# ✅ 推荐：使用 env 查找 bash
#!/usr/bin/env bash

# ❌ 不推荐：硬编码路径
#!/bin/bash  # 在某些系统上路径不同
```

### 调试模式

```bash
# 开发时可临时启用
set -x  # 打印每条命令

# 或在脚本开头添加
set -euxo pipefail  # 增加 -x 用于调试
```

---

## 2. 函数规范

### 函数定义

```bash
# ✅ 推荐：使用小写 snake_case
validate_email() {
    local email="$1"

    if [[ ! "$email" =~ ^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ ]]; then
        return 1
    fi
    return 0
}

# ❌ 避免：使用 function 关键字（非 POSIX 兼容）
function ValidateEmail() {
    # ...
}
```

### 函数注释

```bash
# 验证用户输入的文件路径
# 参数: $1 - 文件路径
# 返回: 0=有效, 1=无效
validate_file_path() {
    local file="$1"

    if [[ ! -f "$file" ]]; then
        error "文件不存在: $file"
        return 1
    fi

    return 0
}
```

### 参数处理

```bash
# ✅ 正确：使用局部变量并加引号
process_user() {
    local username="$1"
    local email="${2:-}"  # 默认值为空字符串

    # 参数验证
    if [[ -z "$username" ]]; then
        error "用户名不能为空"
        return 1
    fi

    # 业务逻辑
    info "处理用户: $username"
}

# ❌ 错误：直接使用 $1, $2（不清晰且容易出错）
process_user() {
    if [[ -z "$1" ]]; then
        return 1
    fi
    echo "$1"
}
```

### 返回值规范

```bash
# ✅ 使用标准返回码
# 0    = 成功
# 1    = 通用错误
# 2    = 命令行参数错误
# 127  = 命令未找到
# 130  = 用户中断 (Ctrl+C)

check_prerequisites() {
    if ! command -v git &>/dev/null; then
        error "Git 未安装"
        return 127
    fi
    return 0
}
```
