#!/usr/bin/env bash
# 一键部署 kcptun server 到远端 Linux VPS，供 clash-verge-rev 内置的 kcptun client 连接加速。
#
# 用法（root 运行）：
#   KCPTUN_TARGET=127.0.0.1:8388 KCPTUN_KEY='强密钥' sudo -E ./deploy-server.sh
#
# 必填环境变量：
#   KCPTUN_TARGET   真实代理服务端地址（kcptun 隧道出口），如 127.0.0.1:8388
#   KCPTUN_KEY      预共享密钥，必须与 client 端一致
# 可选环境变量（默认值）：
#   KCPTUN_LISTEN   (:29900)   KCP/UDP 监听地址
#   KCPTUN_CRYPT    (aes)      加密方式，必须与 client 一致
#   KCPTUN_MODE     (fast)     KCP 模式，建议与 client 一致
#   KCPTUN_BIN      ()         预编译 server 二进制路径；缺省时若有 go 则从源码构建
# 测试/定制路径（一般无需设置）：
#   KCPTUN_DRY_RUN  (0)        置 1 仅生成配置/单元到自定义路径，不动系统、不需 root
#   KCPTUN_PREFIX_BIN / KCPTUN_CONF_DIR / KCPTUN_UNIT_FILE  覆盖安装路径
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

LISTEN="${KCPTUN_LISTEN:-:29900}"
TARGET="${KCPTUN_TARGET:-}"
KEY="${KCPTUN_KEY:-}"
CRYPT="${KCPTUN_CRYPT:-aes}"
MODE="${KCPTUN_MODE:-fast}"
KCPTUN_BIN="${KCPTUN_BIN:-}"

DRY_RUN="${KCPTUN_DRY_RUN:-0}"
PREFIX_BIN="${KCPTUN_PREFIX_BIN:-/usr/local/bin/kcptun-server}"
CONF_DIR="${KCPTUN_CONF_DIR:-/etc/kcptun}"
CONF_FILE="$CONF_DIR/server.json"
UNIT_FILE="${KCPTUN_UNIT_FILE:-/etc/systemd/system/kcptun-server.service}"
RUN_USER="kcptun"

die() { echo "ERROR: $*" >&2; exit 1; }

[ -n "$TARGET" ] || die "必须设置 KCPTUN_TARGET（真实代理地址，如 127.0.0.1:8388）"
[ -n "$KEY" ] || die "必须设置 KCPTUN_KEY（与 client 一致的预共享密钥）"
if [ "$DRY_RUN" != "1" ] && [ "$(id -u)" -ne 0 ]; then
  die "请用 root 运行（需安装 systemd 服务）；或设 KCPTUN_DRY_RUN=1 仅做生成测试"
fi

# 1) 解析/构建 server 二进制
if [ -z "$KCPTUN_BIN" ]; then
  if command -v go >/dev/null 2>&1; then
    echo "[1/6] 从源码构建 server ..."
    CGO_ENABLED=0 go build -C "$REPO_ROOT" -mod=vendor -ldflags "-s -w" -o /tmp/kcptun-server.build ./server
    KCPTUN_BIN=/tmp/kcptun-server.build
  else
    die "未提供 KCPTUN_BIN 且本机无 go，无法获得 server 二进制"
  fi
fi
[ -x "$KCPTUN_BIN" ] || die "server 二进制不存在或不可执行: $KCPTUN_BIN"

# 2) 安装二进制
echo "[2/6] 安装二进制到 $PREFIX_BIN"
mkdir -p "$(dirname "$PREFIX_BIN")"
install -m 0755 "$KCPTUN_BIN" "$PREFIX_BIN"

# 3) 运行用户
if [ "$DRY_RUN" = "1" ]; then
  echo "[3/6] DRY_RUN：跳过创建用户 $RUN_USER"
elif id "$RUN_USER" >/dev/null 2>&1; then
  echo "[3/6] 用户 $RUN_USER 已存在"
else
  echo "[3/6] 创建系统用户 $RUN_USER"
  useradd --system --no-create-home --shell /usr/sbin/nologin "$RUN_USER"
fi

# 4) 写配置（含密钥，权限 600）
echo "[4/6] 写配置 $CONF_FILE"
mkdir -p "$CONF_DIR"
cat > "$CONF_FILE" <<EOF
{
  "listen": "$LISTEN",
  "target": "$TARGET",
  "key": "$KEY",
  "crypt": "$CRYPT",
  "mode": "$MODE",
  "mtu": 1350,
  "sndwnd": 1024,
  "rcvwnd": 1024,
  "datashard": 10,
  "parityshard": 3,
  "nocomp": false
}
EOF
chmod 600 "$CONF_FILE"
[ "$DRY_RUN" = "1" ] || chown "$RUN_USER:$RUN_USER" "$CONF_FILE"

# 5) 安装 systemd 单元
echo "[5/6] 写 systemd 单元 $UNIT_FILE"
mkdir -p "$(dirname "$UNIT_FILE")"
cat > "$UNIT_FILE" <<EOF
[Unit]
Description=kcptun server (KCP tunnel for clash acceleration)
Documentation=https://github.com/xtaci/kcptun
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
User=$RUN_USER
ExecStart=$PREFIX_BIN -c $CONF_FILE
Restart=on-failure
RestartSec=3
LimitNOFILE=1048576
AmbientCapabilities=CAP_NET_BIND_SERVICE
NoNewPrivileges=true

[Install]
WantedBy=multi-user.target
EOF

# 6) 启动
if [ "$DRY_RUN" = "1" ]; then
  echo "[6/6] DRY_RUN：跳过 systemctl；已生成 $CONF_FILE 与 $UNIT_FILE"
else
  echo "[6/6] 启用并启动服务"
  systemctl daemon-reload
  systemctl enable --now kcptun-server.service
  systemctl --no-pager --full status kcptun-server.service || true
fi

echo
echo "完成。client 端必须匹配：  -r <本机公网IP>${LISTEN}   -key '$KEY'   -crypt $CRYPT   -mode $MODE"
echo "（datashard=10 parityshard=3 两端默认一致；如改请同步）"
