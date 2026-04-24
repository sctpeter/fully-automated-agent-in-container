# Claude Code 容器环境

## 目录结构

```
claude_home/
├── Containerfile         # 镜像构建文件
├── run.sh                # 启动脚本
├── claude-code.tar       # 已保存的镜像（可离线导入）
├── pod/                  # 挂载到容器 /workspace 的工作目录
├── claude-config/        # 容器专用 ~/.claude/ 目录（首次运行自动创建）
├── claude-config.json    # 容器专用 ~/.claude.json 文件（首次运行自动创建）
└── README.md             # 本文档
```

## 镜像说明

- 基础镜像：`node:22-bookworm-slim`
- 安装内容：`git`、`curl`、`sudo`、`@anthropic-ai/claude-code`
- 容器内用户：`node`（uid=1000，与宿主机 peter 一致），拥有容器内免密 sudo 权限
- 工作目录：`/workspace`（挂载自宿主机 `pod/`）
- 启动参数：`--dangerously-skip-permissions`（容器内跳过权限审核，不影响宿主机）

## 构建镜像

```bash
podman build -t claude-code -f Containerfile .
```

构建完成后可将镜像保存为 tar 文件供离线使用：

```bash
podman save -o claude-code.tar claude-code
```

## 使用方法

### 首次登录

确保宿主机已通过 `claude login` 完成 Pro 订阅授权（token 在 `~/.claude/`）。

首次运行 `./run.sh` 时会自动将 `~/.claude/` 复制到 `claude-config/`，将 `~/.claude.json` 复制到 `claude-config.json`，容器使用这两份独立副本，与宿主机配置完全隔离。

### 启动容器

```bash
./run.sh
```

### token 过期重新登录

删除 `claude-config/` 目录和 `claude-config.json` 文件，在宿主机重新执行 `claude login`，再运行 `./run.sh` 即可自动重新复制：

```bash
rm -rf "$HOME/Desktop/claude_home/claude-config"
rm -f "$HOME/Desktop/claude_home/claude-config.json"
claude login
./run.sh
```

### 使用自定义后端（可选）

如需通过代理或自定义 API 地址：

```bash
export ANTHROPIC_BASE_URL="https://your-proxy.example.com"
./run.sh
```

### 离线导入镜像

如需在其他机器上使用：

```bash
podman load -i claude-code.tar
```

## 权限说明

- `--userns=keep-id`：容器内 uid=1000 直接映射到宿主机 uid=1000（peter），挂载目录读写正常
- `:Z`：SELinux/容器标签重标，允许容器访问挂载卷
- 容器内 `sudo` 仅在容器 user namespace 内生效，uid=0 映射到宿主机上的高位无特权 uid，不等于宿主机 root，隔离边界为挂载的 `pod/` 目录
- `claude-config/` 与宿主机 `~/.claude/` 独立，`claude-config.json` 与宿主机 `~/.claude.json` 独立，容器内配置变更不影响宿主机
