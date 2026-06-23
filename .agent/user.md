# 项目坐标

> 本文件由 `ai-rules init-context` 生成，描述本项目的技术栈 / 目的 / 工作流。
> Claude Code 会自动读取作为项目上下文。手动编辑或 `ai-rules init-context --refresh` 可重建。

## 🔧 技术栈（WHAT）

- **语言**：Go 1.22.3（toolchain go1.23.0）
- **框架**：urfave/cli v1.22（CLI 命令行框架）
- **运行时**：原生二进制，跨平台（linux/darwin/windows/freebsd 等，CGO_ENABLED=0）
- **数据存储**：无
- **关键依赖**：xtaci/kcp-go/v5（KCP 协议）、xtaci/smux（多路复用）、xtaci/tcpraw、golang/snappy（压缩）、xtaci/qpp（加密）

## 🎯 项目目的（WHY）

kcptun 是基于 KCP 协议的安全 TCP 隧道，在客户端与服务端之间建立 UDP 转发通道，以 FEC 前向纠错对抗丢包与高延迟网络。将应用的 TCP 连接（如 `8388/tcp`）封装为 KCP/UDP 传输，显著提升弱网环境下的吞吐与稳定性。面向需要在不稳定链路上做端口转发的运维与个人用户。

## ⚙️ 工作流（HOW）

### 构建与运行
- 装依赖：`go mod download`（已 vendor，构建用 `-mod=vendor`）
- 本地开发：`go build -o client github.com/xtaci/kcptun/client && go build -o server github.com/xtaci/kcptun/server`
- 生产构建：`./build-release.sh`（产物在 `build/`，CGO 版用 `./build-release-cgo.sh`）

### 测试
- 跑测试：`go test ./...`
- 覆盖率：`go test -cover ./...`
- Lint：`go vet ./...`

### 部署
- 见 README.md:35-69（下载预编译 release，分别启动 client/server 建立转发通道）；容器镜像见 `Dockerfile`

## 📎 项目自定义约束

<留空。由人工填入本项目特有的代码约定、业务规则、领域术语。AI 不要自动填充本节。>
