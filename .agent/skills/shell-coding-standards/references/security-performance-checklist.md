## 8. 安全编码

### 输入验证

```bash
# ✅ 验证文件路径
validate_path() {
    local path="$1"

    # 检查路径遍历攻击
    if [[ "$path" =~ \.\. ]]; then
        error "路径包含 '..'，拒绝处理"
        return 1
    fi

    # 检查绝对路径
    if [[ "$path" != /* ]]; then
        error "必须使用绝对路径"
        return 1
    fi

    return 0
}

# ✅ 验证用户输入（白名单）
validate_action() {
    local action="$1"

    case "$action" in
        start|stop|restart|status)
            return 0
            ;;
        *)
            error "无效操作: $action"
            return 1
            ;;
    esac
}
```

### 避免命令注入

```bash
# ❌ 危险：使用 eval
eval "rm $user_input"

# ✅ 安全：直接执行命令
rm "$user_input"

# ❌ 危险：未转义的用户输入
mysql -e "SELECT * FROM users WHERE name='$username'"

# ✅ 安全：使用参数化查询（通过配置文件）
mysql --defaults-extra-file=<(cat <<EOF
[client]
user=root
password=$DB_PASSWORD
EOF
) -e "SELECT * FROM users WHERE id=${user_id}"
```

### 敏感信息处理

```bash
# ✅ 从环境变量读取密钥
api_key="${API_KEY:?错误: API_KEY 未设置}"

# ✅ 使用临时文件存储敏感数据
secret_file="$(mktemp)"
chmod 600 "$secret_file"  # 仅所有者可读写
echo "$secret_data" > "$secret_file"

# 使用后立即删除
trap 'rm -f "$secret_file"' EXIT

# ❌ 禁止：硬编码密钥
api_key="sk-1234567890abcdef"  # 绝对禁止！
```

---

## 9. 性能优化

### 避免不必要的子进程

```bash
# ❌ 慢：每次循环都创建子进程
for file in *.txt; do
    count=$(wc -l < "$file")
    echo "$file: $count"
done

# ✅ 快：使用内建命令
count=0
while IFS= read -r line; do
    ((count++))
done < "$file"
echo "$file: $count"
```

### 批量处理

```bash
# ❌ 慢：逐个文件处理
for file in *.txt; do
    cat "$file" | grep "pattern"
done

# ✅ 快：批量处理
grep "pattern" *.txt
```

---

## 10. 代码提交前检查清单

### Shell 特定检查项

- [ ] 所有脚本使用 `set -euo pipefail`
- [ ] 所有变量引用加引号 `"$var"`
- [ ] 函数使用 `local` 声明局部变量
- [ ] 通过 ShellCheck 检查（无错误）
- [ ] 有单元测试（bats-core）
- [ ] 使用 `trap` 处理清理逻辑
- [ ] 错误信息输出到 stderr (`>&2`)
- [ ] 使用 `command -v` 检查命令存在性
- [ ] 文件操作前验证路径有效性
- [ ] 无硬编码敏感信息

### 通用检查项

- [ ] 代码符合命名规范
- [ ] 函数有清晰的注释
- [ ] 有完整的错误处理
- [ ] Git 提交信息符合规范
- [ ] **功能更新已同步文档**（README.md / 使用文档）

---

## 参考资源

- [Google Shell Style Guide](https://google.github.io/styleguide/shellguide.html)
- [ShellCheck Wiki](https://github.com/koalaman/shellcheck/wiki)
- [Bash Guide for Beginners](https://tldp.org/LDP/Bash-Beginners-Guide/html/)
- [Bats-core Documentation](https://bats-core.readthedocs.io/)
