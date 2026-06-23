# AI IDE 统一配置架构

> ⚠️ **DEPRECATED**: 本文档描述的 `.ai/` 架构已废弃。
> 新标准请使用 `.agent/` 目录。详见 [../docs/ai-tools-setup-guide.md](../docs/ai-tools-setup-guide.md)

> **最后更新**: 2026-02-02
> **版本**: 1.0

---

## 🎯 设计目标

实现**一份规范文档，多个 AI IDE 共享**，避免重复维护。

---

## 📊 架构图

### 当前实施方案（方案 A）

```
┌─────────────────────────────────────────────────────────┐
│                  项目根目录                                │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        ▼                 ▼                 ▼
   ┌─────────┐      ┌─────────┐      ┌─────────┐
   │ .github │      │   .ai   │      │  根目录  │
   └─────────┘      └─────────┘      └─────────┘
        │                │                 │
        │                │                 │
        ▼                ▼                 ▼
┌──────────────┐  ┌──────────────┐  ┌──────────────┐
│copilot-      │  │instructions  │  │.cursorrules  │
│instructions  │◄─┤.md (symlink) │◄─┤(symlink)     │
│.md (主文件)   │  └──────────────┘  └──────────────┘
└──────────────┘         │
        │                │           ┌──────────────┐
        │                └──────────►│.windsurfrules│
        │                            │(symlink)     │
        │                            └──────────────┘
        │
        ▼
  ┌──────────────────┐
  │development-      │
  │standards.md      │
  │(详细通用规范)     │
  └──────────────────┘
        │
        ▼
  ┌──────────────────┐
  │php-project-      │
  │standards.md      │
  │(详细 PHP 规范)   │
  └──────────────────┘
```

---

## 🔗 文件关系矩阵

| 文件路径 | 类型 | 指向 | 用途 | IDE |
|---------|------|------|------|-----|
| `.github/copilot-instructions.md` | 📄 主文件 | - | 核心规范 | GitHub Copilot |
| `.ai/instructions.md` | 🔗 软链接 | `../.github/copilot-instructions.md` | 中转 | - |
| `.cursorrules` | 🔗 软链接 | `.ai/instructions.md` | Cursor 配置 | Cursor AI |
| `.windsurfrules` | 🔗 软链接 | `.ai/instructions.md` | Windsurf 配置 | Windsurf |
| `.github/development-standards.md` | 📄 原文件 | - | 通用规范详情 | 所有（引用） |
| `.github/php-project-standards.md` | 📄 原文件 | - | PHP 规范详情 | 所有（引用） |
| `.ai/development-standards.md` | 🔗 软链接 | `../.github/development-standards.md` | 便捷访问 | - |
| `.ai/php-project-standards.md` | 🔗 软链接 | `../.github/php-project-standards.md` | 便捷访问 | - |

---

## 🔄 数据流图

```
用户修改规范
    ↓
编辑 .github/copilot-instructions.md (主文件)
    ↓
    ├─────────────────────┬─────────────────────┐
    ↓                     ↓                     ↓
自动同步到             自动同步到             自动同步到
.ai/instructions.md    .cursorrules        .windsurfrules
    ↓                     ↓                     ↓
GitHub Copilot 读取    Cursor AI 读取      Windsurf 读取
```

---

## 📁 目录结构详解

```
/www/wwwroot/rp.infogo.vip/
│
├── .github/                          # GitHub 标准配置目录
│   ├── copilot-instructions.md       # 📄 主文件（6KB）
│   │   ├── Priority 0 核心约束
│   │   ├── 角色定义
│   │   ├── 快速参考
│   │   └── 链接到详细文档
│   │
│   ├── development-standards.md      # 📄 通用开发规范（30KB）
│   ├── php-project-standards.md      # 📄 PHP 项目规范（22KB）
│   ├── README.md                     # 📖 导航索引
│   ├── CHANGELOG.md                  # 📝 变更日志
│   └── AI-IDE-ARCHITECTURE.md        # 📐 本文档
│
├── .ai/                              # AI 配置中心
│   ├── README.md                     # 📖 实施指南
│   ├── instructions.md               # 🔗 → ../.github/copilot-instructions.md
│   ├── development-standards.md      # 🔗 → ../.github/development-standards.md
│   └── php-project-standards.md      # 🔗 → ../.github/php-project-standards.md
│
├── .cursorrules                      # 🔗 → .ai/instructions.md (Cursor AI)
├── .windsurfrules                    # 🔗 → .ai/instructions.md (Windsurf)
│
└── scripts/
    └── sync-ai-config.sh             # 🔧 Windows 兼容同步脚本
```

---

## 🛠️ 实施细节

### 软链接创建命令

```bash
cd /www/wwwroot/rp.infogo.vip

# .ai 目录软链接
ln -sf ../.github/copilot-instructions.md .ai/instructions.md
ln -sf ../.github/development-standards.md .ai/development-standards.md
ln -sf ../.github/php-project-standards.md .ai/php-project-standards.md

# AI IDE 配置
ln -sf .ai/instructions.md .cursorrules
ln -sf .ai/instructions.md .windsurfrules
```

### 验证软链接

```bash
# 查看软链接状态
ls -lh .cursorrules .windsurfrules .ai/*.md

# 验证链接目标
readlink .cursorrules
readlink .windsurfrules

# 验证内容一致性（所有 MD5 应该相同）
md5sum .cursorrules .windsurfrules .ai/instructions.md .github/copilot-instructions.md
```

---

## 💡 工作流程

### 正常工作流（Linux/Mac）

1. **修改规范**：
   ```bash
   vim .github/copilot-instructions.md
   ```

2. **自动同步**：软链接自动生效，所有 AI IDE 立即看到变更

3. **提交变更**：
   ```bash
   git add .github/copilot-instructions.md
   git commit -m "docs: 更新规范"
   ```

### Windows 工作流（不支持软链接时）

1. **修改规范**：
   ```bash
   vim .github/copilot-instructions.md
   ```

2. **运行同步脚本**：
   ```bash
   bash scripts/sync-ai-config.sh
   ```

3. **提交变更**：
   ```bash
   git add .github/copilot-instructions.md .cursorrules .windsurfrules .ai/instructions.md
   git commit -m "docs: 更新规范并同步"
   ```

---

## ⚙️ 配置选项

### Git 配置（启用软链接）

```bash
# 全局启用（推荐）
git config --global core.symlinks true

# 仅当前仓库
git config core.symlinks true
```

### Windows 开发者模式

1. 设置 → 更新和安全 → 开发者选项
2. 启用"开发者模式"
3. 重启终端

---

## 🎁 架构优势

| 优势 | 说明 |
|------|------|
| **单一真相源** | 只需维护 `.github/copilot-instructions.md` |
| **自动同步** | 软链接实现所有 IDE 实时同步 |
| **版本控制友好** | Git 原生支持软链接跟踪 |
| **跨 IDE 一致性** | 所有团队成员使用不同 IDE 时配置完全一致 |
| **零冗余** | 消除多份副本，避免不一致 |
| **便于维护** | 单点修改，全局生效 |
| **跨平台兼容** | 提供 Windows 同步脚本 |

---

## 🔍 故障排查

### 问题 1：软链接显示为普通文件

**原因**：Git 配置未启用软链接支持

**解决**：
```bash
git config core.symlinks true
```

### 问题 2：Windows 无法创建软链接

**原因**：缺少权限或未启用开发者模式

**解决**：
- 启用 Windows 开发者模式
- 或使用 `scripts/sync-ai-config.sh` 脚本

### 问题 3：软链接指向错误

**原因**：相对路径计算错误

**解决**：
```bash
# 删除错误的软链接
rm .cursorrules

# 重新创建
ln -sf .ai/instructions.md .cursorrules
```

---

## 📚 相关文档

- [.ai/README.md](../.ai/README.md) - 详细实施指南
- [.github/CHANGELOG.md](./CHANGELOG.md) - 规范变更历史
- [.github/README.md](./README.md) - 规范文档导航

---

## 🔮 未来扩展

支持更多 AI IDE：

```bash
# Continue.dev
mkdir -p .continue
ln -sf ../.ai/instructions.md .continue/instructions.md

# Codeium
mkdir -p .codeium
ln -sf ../.ai/instructions.md .codeium/instructions.md

# Tabnine
mkdir -p .tabnine
ln -sf ../.ai/instructions.md .tabnine/instructions.md
```

---

**维护说明**：
- 本文档描述 AI IDE 统一配置的架构设计
- 修改架构时需同步更新本文档
- 定期检查软链接完整性
