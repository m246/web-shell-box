FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive \
    HOME=/data \
    TZ=Asia/Shanghai \
    LANG=C.UTF-8

# 常用命令行工具，装好就能直接敲
RUN apt-get update && apt-get install -y --no-install-recommends \
      bash coreutils curl ca-certificates git nano vim-tiny less tree jq \
      python3 python3-pip python3-venv unzip zip wget procps iproute2 \
      openssh-client rsync file tar gzip xz-utils \
      shellinabox \
    && rm -rf /var/lib/apt/lists/*

# 网页终端 ttyd（主用）；下载失败时保留 shellinabox 兜底
RUN set -eux; \
    for u in \
      "https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64" \
      "https://ghproxy.net/https://github.com/tsl0922/ttyd/releases/download/1.7.7/ttyd.x86_64" \
    ; do \
      if curl -fsSL --retry 3 --connect-timeout 20 "$u" -o /usr/local/bin/ttyd; then \
        chmod +x /usr/local/bin/ttyd && break; \
      fi; \
    done; \
    rm -f /usr/local/bin/ttyd.tmp

# 兜底账号（ttyd 用基本认证，shellinabox 需要系统用户）
RUN useradd -m -s /bin/bash box && echo 'box:shellbox' | chpasswd

# 数据目录：挂载持久卷后，这里的东西不会随重启消失
RUN mkdir -p /data
WORKDIR /data

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080
CMD ["/usr/local/bin/entrypoint.sh"]
