#!/usr/bin/env bash
set -e

PORT="${PORT:-8080}"
SHELL_USER="${SHELL_USER:-box}"
SHELL_PASS="${SHELL_PASS:-shellbox}"

mkdir -p /data
cd /data

# 首次启动的欢迎文件，方便确认持久卷生效
if [ ! -f /data/README.txt ]; then
  cat > /data/README.txt <<'EOF'
这里是容器内的 /data 目录。
如果你在 Zeabur 给这个服务挂了持久卷（挂载路径 /data），
那么这里放的文件重启、重新部署后都还在。
EOF
fi

echo "[entrypoint] port=$PORT user=$SHELL_USER"

if [ -x /usr/local/bin/ttyd ]; then
  echo "[entrypoint] using ttyd"
  exec /usr/local/bin/ttyd -p "$PORT" -W -c "${SHELL_USER}:${SHELL_PASS}" bash -l
elif command -v shellinaboxd >/dev/null 2>&1; then
  echo "[entrypoint] ttyd missing, falling back to shellinabox"
  exec shellinaboxd --port="$PORT" --disable-ssl --no-beep \
       --user=box --group=box -s "/:box:box:/data"
else
  echo "[entrypoint] no web terminal available; serving /data as static file list"
  exec python3 -m http.server "$PORT"
fi
