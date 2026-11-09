# web-shell-box

一个开箱即用的「网页命令行容器」：部署完打开网址就是终端，能在里面放任意文件、跑任意命令，不依赖 DSH 或任何 Agent 框架。

- 基础镜像：Ubuntu 24.04
- 网页终端：ttyd（自带基本认证）；ttyd 拉取失败时自动降级到 shellinabox
- 数据目录：`/data`，在 Zeabur 挂持久卷后重启不丢文件
- 端口：读取平台注入的 `PORT` 环境变量（默认 8080）

## 在 Zeabur 部署

1. 新建项目 → Add Service → 选这个仓库 → 平台自动识别 Dockerfile 构建。
2. 部署完成后打开生成的域名，输入用户名 / 密码登录终端。
3. 想要文件持久化：给这个服务添加 **Volume**，挂载路径填 `/data`（免费版注意休眠策略）。

## 环境变量

| 变量 | 默认值 | 说明 |
|---|---|---|
| `SHELL_USER` | `box` | 网页终端登录用户名 |
| `SHELL_PASS` | `shellbox` | 网页终端登录密码，**建议改成自己的** |
| `PORT` | `8080` | 平台注入，一般不用手动填 |

## 本地试跑

```bash
docker build -t web-shell-box .
docker run -p 8080:8080 -e SHELL_PASS=mypass -v ./data:/data web-shell-box
# 打开 http://127.0.0.1:8080
```
