## Security Best Practices

### SQL Injection Prevention

**始终使用参数化查询**，永远不要拼接 SQL 字符串。

```go
// Good: 参数化查询（防止 SQL 注入）
func GetUser(db *sql.DB, id string) (*User, error) {
    query := "SELECT id, name, email FROM users WHERE id = ?"
    var user User
    err := db.QueryRow(query, id).Scan(&user.ID, &user.Name, &user.Email)
    if err != nil {
        return nil, fmt.Errorf("query user: %w", err)
    }
    return &user, nil
}

// Bad: 字符串拼接（SQL 注入漏洞！）
func BadGetUser(db *sql.DB, id string) (*User, error) {
    query := "SELECT * FROM users WHERE id = '" + id + "'"
    // 攻击者可以传入: "1' OR '1'='1"
    // ...
}

// Good: 使用 sqlx 或 ORM
func GetUserWithSqlx(db *sqlx.DB, id string) (*User, error) {
    var user User
    err := db.Get(&user, "SELECT * FROM users WHERE id = $1", id)
    return &user, err
}
```

### Command Injection Prevention

避免直接执行用户输入，使用参数化命令。

```go
import "os/exec"

// Good: 参数化命令
func RunSafeCommand(filename string) error {
    // 验证输入
    if !isValidFilename(filename) {
        return errors.New("invalid filename")
    }

    // 使用参数而非字符串拼接
    cmd := exec.Command("cat", filename)
    output, err := cmd.CombinedOutput()
    if err != nil {
        return fmt.Errorf("command failed: %w", err)
    }
    fmt.Println(string(output))
    return nil
}

// Bad: 字符串拼接命令（命令注入漏洞！）
func BadRunCommand(filename string) error {
    cmdStr := "cat " + filename
    // 攻击者可以传入: "file.txt; rm -rf /"
    cmd := exec.Command("sh", "-c", cmdStr)
    return cmd.Run()
}
```

### Path Traversal Prevention

验证和清理文件路径，防止目录遍历攻击。

```go
import (
    "path/filepath"
    "strings"
)

// Good: 路径验证和清理
func ReadFile(baseDir, filename string) ([]byte, error) {
    // 清理路径
    cleanPath := filepath.Clean(filename)

    // 构建完整路径
    fullPath := filepath.Join(baseDir, cleanPath)

    // 验证路径在基础目录内
    if !strings.HasPrefix(fullPath, baseDir) {
        return nil, errors.New("invalid file path: outside base directory")
    }

    return os.ReadFile(fullPath)
}

// Bad: 未验证路径（目录遍历漏洞！）
func BadReadFile(baseDir, filename string) ([]byte, error) {
    // 攻击者可以传入: "../../etc/passwd"
    fullPath := baseDir + "/" + filename
    return os.ReadFile(fullPath)
}
```

### Timing Attack Prevention

使用常量时间比较函数防止时间侧信道攻击。

```go
import "crypto/subtle"

// Good: 常量时间比较（防止时间攻击）
func ValidateToken(userToken, expectedToken string) bool {
    return subtle.ConstantTimeCompare(
        []byte(userToken),
        []byte(expectedToken),
    ) == 1
}

// Bad: 普通字符串比较（时间攻击漏洞！）
func BadValidateToken(userToken, expectedToken string) bool {
    // 比较时间与匹配的字符数成正比，攻击者可以暴力破解
    return userToken == expectedToken
}
```

### Secure Random Number Generation

使用 `crypto/rand` 而非 `math/rand` 生成安全随机数。

```go
import (
    "crypto/rand"
    "encoding/base64"
)

// Good: 密码学安全的随机数
func GenerateToken() (string, error) {
    b := make([]byte, 32)
    if _, err := rand.Read(b); err != nil {
        return "", fmt.Errorf("generate random: %w", err)
    }
    return base64.URLEncoding.EncodeToString(b), nil
}

// Bad: 非安全的随机数（math/rand）
func BadGenerateToken() string {
    // math/rand 是可预测的，不能用于安全场景！
    return fmt.Sprintf("%d", rand.Int63())
}
```

### Input Validation and Sanitization

始终验证和清理用户输入。

```go
import (
    "net/mail"
    "regexp"
    "strings"
)

var usernameRegex = regexp.MustCompile(`^[a-zA-Z0-9_]{3,20}$`)

// Good: 输入验证
func ValidateUserInput(email, username string) error {
    // 邮箱验证
    if _, err := mail.ParseAddress(email); err != nil {
        return fmt.Errorf("invalid email: %w", err)
    }

    // 用户名验证
    if !usernameRegex.MatchString(username) {
        return errors.New("invalid username: must be 3-20 alphanumeric characters")
    }

    return nil
}

// Good: HTML 输出转义
func RenderUserContent(content string) string {
    return html.EscapeString(content)
}
```

### Secrets Management

绝不在代码中硬编码密钥，使用环境变量或密钥管理服务。

```go
import "os"

// Good: 从环境变量读取密钥
func GetDatabaseURL() (string, error) {
    dbURL := os.Getenv("DATABASE_URL")
    if dbURL == "" {
        return "", errors.New("DATABASE_URL not set")
    }
    return dbURL, nil
}

// Good: 使用密钥管理服务
func GetAPIKeyFromVault() (string, error) {
    // 从 AWS Secrets Manager、HashiCorp Vault 等读取
    return secretsManager.GetSecret("api-key")
}

// Bad: 硬编码密钥（绝对禁止！）
const APIKey = "sk-1234567890abcdef" // 严重安全漏洞！
const DBPassword = "password123"     // 严重安全漏洞！
```

### HTTPS and TLS Configuration

```go
import (
    "crypto/tls"
    "net/http"
)

// Good: 安全的 TLS 配置
func NewSecureServer() *http.Server {
    tlsConfig := &tls.Config{
        MinVersion:               tls.VersionTLS13,
        PreferServerCipherSuites: true,
        CipherSuites: []uint16{
            tls.TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384,
            tls.TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256,
        },
    }

    return &http.Server{
        Addr:      ":443",
        TLSConfig: tlsConfig,
    }
}

// Bad: 接受不安全的 TLS 版本
func BadNewServer() *http.Server {
    tlsConfig := &tls.Config{
        MinVersion: tls.VersionTLS10, // 过时且不安全！
    }
    return &http.Server{Addr: ":443", TLSConfig: tlsConfig}
}
```

### Security Checklist

提交代码前检查：

- [ ] 所有 SQL 查询使用参数化
- [ ] 所有命令执行使用参数化（避免 shell）
- [ ] 文件路径经过验证和清理
- [ ] 敏感比较使用常量时间函数
- [ ] 使用 `crypto/rand` 而非 `math/rand`
- [ ] 所有用户输入经过验证
- [ ] 输出到 HTML 经过转义
- [ ] 无硬编码密钥或凭据
- [ ] HTTPS/TLS 配置安全（TLS 1.2+）
- [ ] 错误消息不泄露敏感信息
