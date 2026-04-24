FROM node:22-bookworm-slim

RUN apt-get update && apt-get install -y \
    git curl ca-certificates sudo \
    && rm -rf /var/lib/apt/lists/* \
    && echo "node ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/node

RUN npm install -g @anthropic-ai/claude-code

USER node
WORKDIR /workspace

ENTRYPOINT ["claude", "--dangerously-skip-permissions"]
