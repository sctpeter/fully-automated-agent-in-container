#!/bin/bash
CONFIG_DIR="$HOME/Desktop/claude_home/claude-config"
CONFIG_JSON="$HOME/Desktop/claude_home/claude-config.json"

if [ ! -d "$CONFIG_DIR" ]; then
    echo "首次运行：从 ~/.claude 复制登录配置..."
    cp -r "$HOME/.claude" "$CONFIG_DIR"
fi

if [ ! -f "$CONFIG_JSON" ]; then
    echo "首次运行：从 ~/.claude.json 复制登录配置文件..."
    cp "$HOME/.claude.json" "$CONFIG_JSON"
fi

podman run -it --rm \
    --userns=keep-id \
    -v "$HOME/Desktop/claude_home/pod:/workspace:Z" \
    -v "$CONFIG_DIR:/home/node/.claude:Z" \
    -v "$CONFIG_JSON:/home/node/.claude.json:Z" \
    -e ANTHROPIC_BASE_URL="${ANTHROPIC_BASE_URL}" \
    -e ANTHROPIC_AUTH_TOKEN="${ANTHROPIC_AUTH_TOKEN}" \
    -e API_TIMEOUT_MS="${API_TIMEOUT_MS}" \
    -e DISABLE_TELEMETRY="${DISABLE_TELEMETRY}" \
    -e DISABLE_ERROR_REPORTING="${DISABLE_ERROR_REPORTING}" \
    -e DISABLE_FEEDBACK_COMMAND="${DISABLE_FEEDBACK_COMMAND}" \
    -e CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY="${CLAUDE_CODE_DISABLE_FEEDBACK_SURVEY}" \
    -e CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC="${CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC}" \
    -e ANTHROPIC_MODEL="${ANTHROPIC_MODEL}" \
    -e ANTHROPIC_DEFAULT_HAIKU_MODEL="${ANTHROPIC_DEFAULT_HAIKU_MODEL}" \
    -e ANTHROPIC_DEFAULT_SONNET_MODEL="${ANTHROPIC_DEFAULT_SONNET_MODEL}" \
    -e ANTHROPIC_DEFAULT_OPUS_MODEL="${ANTHROPIC_DEFAULT_OPUS_MODEL}" \
    claude-code "$@"
