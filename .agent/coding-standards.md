# 项目编码规范

> **版本**: 2.0
> **适用范围**: 当前项目
> **基于**: [通用开发规范](./development-standards.md)

---

## 智能规范系统说明

本项目采用 **Skills 智能加载机制**，无需手动配置语言特定规范。

### 工作原理

AI 工具会根据您编辑的文件类型**自动加载**对应的编码规范 Skill：

| 文件类型 | 自动加载的 Skills |
|----------|------------------|
| `.ts` / `.tsx` / `.js` | typescript-patterns, javascript-best-practices |
| `.go` | golang-patterns, golang-testing |
| `.py` | python-patterns, python-testing |
| `.java` | java-coding-standards, java-spring-boot |
| `.php` | php-coding-standards |
| `.sh` / `.bash` | shell-coding-standards |
| `.cs` | csharp-coding-standards |
| `.rb` | ruby-coding-standards |

### 多语言项目支持

对于同时使用多种语言的项目（如 Next.js + Golang），AI 会：
- 编辑前端 `.tsx` 文件时 → 应用 TypeScript 规范
- 编辑后端 `.go` 文件时 → 应用 Golang 规范
- 自动切换，无需手动干预

### 查看可用 Skills

所有可用的语言 Skills 位于：

```bash
.agent/skills/
├── typescript-patterns/
├── golang-patterns/
├── python-patterns/
├── php-coding-standards/
└── ... (30+ 个语言特定 Skills)
```

---

## 1. 技术栈

请在此记录项目使用的技术栈：

- **编程语言**: [语言及版本]
- **框架**: [框架名称及版本]
- **数据库**: [数据库类型及版本]
- **其他**: [其他关键技术]

---

## 2. 项目结构

请在此描述项目的目录结构：

```
/project-root
├── src/                       # 源代码目录
├── tests/                     # 测试目录
├── docs/                      # 文档目录
└── ...
```

---

## 3. 命名规范

### 3.1 文件命名

| 类型 | 规范 | 示例 |
|------|------|------|
| 源代码文件 | [填写规范] | [填写示例] |
| 测试文件 | [填写规范] | [填写示例] |
| 配置文件 | [填写规范] | [填写示例] |

### 3.2 代码命名

| 类型 | 规范 | 示例 |
|------|------|------|
| 类名 | PascalCase | `UserService` |
| 方法名 | camelCase | `getUserById` |
| 变量名 | camelCase | `userName` |
| 常量名 | UPPER_SNAKE_CASE | `MAX_RETRY_COUNT` |

---

## 4. 安全编码规范

### 4.1 输入验证

所有外部输入必须进行验证和过滤：

```
[在此添加语言特定的输入验证示例]
```

### 4.2 输出转义

所有输出到页面的内容必须正确转义：

```
[在此添加语言特定的输出转义示例]
```

### 4.3 SQL 注入防护

所有数据库查询必须使用参数化查询：

```
[在此添加语言特定的参数化查询示例]
```

---

## 5. 错误处理规范

### 5.1 异常处理

```
[在此添加语言特定的异常处理示例]
```

### 5.2 日志记录

```
[在此添加语言特定的日志记录示例]
```

---

## 6. 测试规范

### 6.1 单元测试

- 测试覆盖率要求: [填写百分比]
- 测试命名规范: [填写规范]

### 6.2 测试示例

```
[在此添加语言特定的测试示例]
```

---

## 7. 代码提交前检查清单

除通用检查清单外，还需检查：

- [ ] [语言特定检查项 1]
- [ ] [语言特定检查项 2]
- [ ] [语言特定检查项 3]

---

## 8. 参考资源

- [官方文档链接]
- [代码风格指南链接]
- [最佳实践链接]

---

**维护说明**：
- 本文件是项目特定的编码规范
- 请根据项目实际情况进行定制
- 通用规范请参考 [development-standards.md](./development-standards.md)
