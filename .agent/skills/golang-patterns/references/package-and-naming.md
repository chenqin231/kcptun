## Package Organization

### Standard Project Layout

遵循 [Standard Go Project Layout](https://github.com/golang-standards/project-layout) 社区标准。

```text
myproject/
├── cmd/                      # 主应用程序入口
│   ├── myapp/                # 应用 1
│   │   └── main.go           # 入口点：main 函数
│   └── worker/               # 应用 2（可选，如后台任务）
│       └── main.go
├── internal/                 # 私有应用和库代码（不能被外部导入）
│   ├── app/                  # 应用级代码
│   │   ├── api/              # HTTP/gRPC API 处理器
│   │   │   ├── handler/      # HTTP handlers
│   │   │   ├── middleware/   # 中间件
│   │   │   └── router/       # 路由配置
│   │   └── domain/           # 业务领域逻辑
│   │       ├── user/         # User 领域
│   │       │   ├── service.go       # 业务逻辑
│   │       │   ├── repository.go    # 数据访问接口
│   │       │   └── model.go         # 领域模型
│   │       └── order/        # Order 领域
│   └── pkg/                  # internal 内部共享库
│       ├── database/         # 数据库连接和配置
│       ├── validator/        # 输入验证
│       └── logger/           # 日志工具
├── pkg/                      # 公共库代码（可被外部项目导入）
│   └── client/               # API 客户端库
│       ├── client.go
│       └── types.go
├── api/                      # API 规范和定义
│   ├── openapi/              # OpenAPI/Swagger 规范
│   │   └── v1.yaml
│   └── proto/                # Protocol Buffer 定义
│       └── v1/
│           └── service.proto
├── web/                      # Web 应用资产（模板、静态文件）
│   ├── static/
│   └── templates/
├── configs/                  # 配置文件模板
│   ├── config.yaml.example
│   └── production.yaml
├── scripts/                  # 构建、安装、分析脚本
│   ├── build.sh
│   └── migrate.sh
├── deployments/              # 部署配置（Docker、K8s）
│   ├── Dockerfile
│   └── kubernetes/
│       └── deployment.yaml
├── test/                     # 额外的外部测试应用和数据
│   ├── integration/          # 集成测试
│   └── e2e/                  # 端到端测试
├── docs/                     # 设计和用户文档
│   ├── architecture.md
│   └── api.md
├── .golangci.yml             # Linter 配置
├── Makefile                  # 构建和任务自动化
├── go.mod
├── go.sum
└── README.md
```

**关键目录说明**：

- **`cmd/`**: 每个应用一个子目录，保持 `main.go` 简洁（仅初始化和启动）
- **`internal/`**: 仅本项目可用，外部无法导入（Go 编译器强制）
- **`pkg/`**: 可被外部项目安全导入的公共库
- **`api/`**: API 契约定义，与实现分离
- **避免使用 `src/` 目录**：Go 项目不需要 `src/` 层级

### Package Naming

```go
// Good: Short, lowercase, no underscores
package http
package json
package user

// Bad: Verbose, mixed case, or redundant
package httpHandler
package json_parser
package userService // Redundant 'Service' suffix
```

## Naming Conventions

### General Naming Rules

Go 命名应简洁、清晰，避免冗余。

```go
// Good: 简洁且描述性强
type User struct {
    ID   string
    Name string
}

func (u *User) Activate() error { }
func (u *User) IsActive() bool { }

// Bad: 冗余前缀/后缀
type UserStruct struct { }     // 不需要 Struct 后缀
func (u *User) GetUserName() string { } // 不需要 Get 前缀和 User 重复
```

### Variable Naming

- **局部变量**：简短、上下文明确时可用单字母
- **全局变量/导出变量**：完整描述性名称

```go
// Good: 局部变量简短
for i, user := range users {
    // i 和 user 在上下文中很清楚
}

// Good: 全局变量描述性强
var (
    ErrInvalidCredentials = errors.New("invalid credentials")
    DefaultTimeout        = 30 * time.Second
)

// Bad: 局部变量过于冗长
for index, userObject := range users {
    // 过于冗长，不符合 Go 习惯
}
```

### Function and Method Naming

- **方法名**：使用动词或动词短语
- **布尔返回函数**：使用 `Is`, `Has`, `Can` 等前缀
- **避免冗余**：方法名不需要重复接收器名称

```go
// Good: 清晰的动词
func (s *Server) Start() error { }
func (s *Server) Shutdown(ctx context.Context) error { }
func (u *User) IsActive() bool { }
func (u *User) HasPermission(perm string) bool { }

// Bad: 冗余和不清晰
func (s *Server) ServerStart() error { }  // 冗余 Server
func (u *User) Active() bool { }          // 不清楚是 getter 还是 action
```

### Constant Naming

- **导出常量**：使用 PascalCase
- **未导出常量**：使用 camelCase
- **枚举常量**：使用 iota，名称应该有共同前缀

```go
// Good: 导出常量
const (
    StatusActive   = "active"
    StatusInactive = "inactive"
)

// Good: 枚举常量
type Status int

const (
    StatusUnknown Status = iota
    StatusPending
    StatusApproved
    StatusRejected
)

// Bad: 全大写（不符合 Go 习惯）
const MAX_CONNECTIONS = 100
```

### File Naming

- **小写字母和下划线**
- **测试文件**：`_test.go` 后缀
- **平台相关**：`_linux.go`, `_darwin.go`, `_windows.go`
- **构建标签**：`_integration_test.go`

```bash
# Good: 清晰的文件命名
user.go
user_test.go
user_repository.go
user_repository_postgres.go
http_handler.go
http_handler_test.go

# Bad: 不符合习惯
User.go
UserRepository.go
HTTPHandler.go
```

### Avoid Package-Level State

```go
// Bad: Global mutable state
var db *sql.DB

func init() {
    db, _ = sql.Open("postgres", os.Getenv("DATABASE_URL"))
}

// Good: Dependency injection
type Server struct {
    db *sql.DB
}

func NewServer(db *sql.DB) *Server {
    return &Server{db: db}
}
```
