# kcptun 服务端部署套件

把 kcptun **server** 部署到远端 Linux VPS，与 clash-verge-rev 内置的 kcptun **client** 配对，形成 `clash → kcptun → 真实代理` 的加速链路。

## 拓扑

```
[Windows: clash-verge-rev]                         [远端 Linux VPS]
 mihomo(节点 server=127.0.0.1:LPORT)                kcptun-server(:29900/udp)
   → kcptun-client(监听 127.0.0.1:LPORT)  ──KCP/UDP──→   → target=真实代理(127.0.0.1:8388)
                                                          → ss/vmess/trojan 服务端 → 互联网
```

- `target` 指向**真实代理服务端**在 VPS 上的本地端口（如 shadowsocks 的 `127.0.0.1:8388`）。
- `key / crypt / mode / datashard / parityshard` **两端必须一致**，否则握手或解密失败。

## 一键部署

在 VPS 上、kcptun 仓库根目录执行：

```bash
KCPTUN_TARGET=127.0.0.1:8388 \
KCPTUN_KEY='换成足够强的共享密钥' \
sudo -E ./deploy/deploy-server.sh
```

脚本会：构建/安装 `server` 二进制 → 建系统用户 `kcptun` → 写 `/etc/kcptun/server.json`(600) → 装并启用 `kcptun-server.service`。

可选环境变量：`KCPTUN_LISTEN`(默认 `:29900`)、`KCPTUN_CRYPT`(aes)、`KCPTUN_MODE`(fast)、`KCPTUN_BIN`(预编译二进制路径)。

## 本机生成测试（不动系统、无需 root）

```bash
KCPTUN_DRY_RUN=1 KCPTUN_TARGET=127.0.0.1:8388 KCPTUN_KEY=test \
KCPTUN_PREFIX_BIN=/tmp/k/bin KCPTUN_CONF_DIR=/tmp/k/etc KCPTUN_UNIT_FILE=/tmp/k/unit.service \
./deploy/deploy-server.sh
```

## 手动部署

1. 编译：`CGO_ENABLED=0 go build -mod=vendor -o kcptun-server ./server`
2. 装二进制到 `/usr/local/bin/kcptun-server`。
3. 用 `server-config.sample.json` 改成 `/etc/kcptun/server.json`（改 `target`/`key`）。
4. 装 `kcptun-server.service` 到 `/etc/systemd/system/`，`systemctl enable --now kcptun-server`。

## client 端对应配置

在 clash-verge-rev 的 kcptun 面板填写：远端地址 `<VPS公网IP>:29900`、相同的 `key/crypt/mode`、本地监听端口（如 `12948`）；再把要加速的 clash 节点 `server` 改为 `127.0.0.1:12948`。
