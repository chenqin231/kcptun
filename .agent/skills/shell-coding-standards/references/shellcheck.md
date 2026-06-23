## 5. ShellCheck 规则

### 集成 ShellCheck

```bash
# 安装 ShellCheck
# Ubuntu/Debian
sudo apt install shellcheck

# macOS
brew install shellcheck

# 运行检查
shellcheck script.sh

# CI/CD 集成
find . -name "*.sh" -exec shellcheck {} +
```

### 常见 ShellCheck 警告修复

```bash
# SC2086: 双引号防止词分割
# ❌ 错误
rm $file

# ✅ 修复
rm "$file"

# SC2046: 使用 $() 替代反引号
# ❌ 错误
files=`ls *.txt`

# ✅ 修复
files=$(ls *.txt)

# SC2155: 分离声明和赋值以检查退出码
# ❌ 错误
local result="$(some_command)"

# ✅ 修复
local result
result="$(some_command)"

# SC2164: cd 后检查是否成功
# ❌ 错误
cd "$dir"
rm -rf *

# ✅ 修复
cd "$dir" || exit 1
rm -rf *
```

### 禁用规则（谨慎使用）

```bash
# 禁用特定规则（必须有注释说明原因）
# shellcheck disable=SC2086
# 原因：变量需要词分割以传递多个参数
rm $files_to_delete

# 禁用整个文件的规则（不推荐）
# shellcheck disable=SC2086
```
