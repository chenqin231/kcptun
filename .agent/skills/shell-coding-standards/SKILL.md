---
name: shell-coding-standards
description: Shell/Bash coding standards for building secure, maintainable, and robust shell scripts. Covers strict mode, error handling, ShellCheck rules, and testing with bats-core.
triggers:
  keywords:
    primary: [bash, shell, sh, shellcheck, bats]
    secondary: [set -euo pipefail, trap, readonly, local]
  context_boost: [.sh, .bash, "#!/usr/bin/env bash", BASH_SOURCE]
  context_penalty: [.ts, .py, .go, .php, React]
  priority: high
tier: optional
stacks: [cli]
---

# Shell/Bash Coding Standards

Bash 脚本编码规范，适用于系统工具、CI/CD 脚本和命令行工具开发。

## 核心规范速查

| 类型 | 规则 | 示例 |
|------|------|------|
| 脚本名 | kebab-case | `init-project.sh` |
| 函数名 | snake_case | `parse_config()` |
| 局部变量 | snake_case + local | `local file_path` |
| 全局常量 | readonly UPPER_SNAKE | `readonly MAX_RETRIES=3` |

## 参考资源

| 主题 | 说明 | 文件 |
|------|------|------|
| 严格模式与函数规范 | set -euo pipefail、函数定义/注释/参数/返回值 | [strict-mode-functions.md](references/strict-mode-functions.md) |
| 错误处理与变量规范 | stderr 输出、trap、command -v、引号、local、默认值 | [error-handling-variables.md](references/error-handling-variables.md) |
| ShellCheck 规则 | 集成方式、常见警告修复、禁用规则 | [shellcheck.md](references/shellcheck.md) |
| 代码组织与测试 | 脚本结构模板、模块化 sourcing、bats-core 测试 | [code-organization-testing.md](references/code-organization-testing.md) |
| 安全/性能/检查清单 | 输入验证、命令注入防护、性能优化、提交前检查 | [security-performance-checklist.md](references/security-performance-checklist.md) |
