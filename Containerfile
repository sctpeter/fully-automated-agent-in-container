FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y \
    git curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

USER node
WORKDIR /workspace

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
