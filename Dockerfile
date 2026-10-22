FROM node:20-bookworm-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates git \
    && rm -rf /var/lib/apt/lists/*

RUN curl -LsSf https://astral.sh/uv/install.sh | sh

ENV PATH="/root/.local/bin:$PATH"

RUN uv python install 3.14 \
    && uv tool install --python 3.14 \
    --from git+https://github.com/cornellsh/codex-proxy codex-proxy

RUN npm install -g @openai/codex

WORKDIR /app

COPY deploy/package.json .
RUN npm install --omit=dev

COPY deploy/server.js .
COPY deploy/start.sh .
COPY deploy/codex-config /root/.codex

ENV CODEX_HOME=/root/.codex
ENV CODEX_PROXY_PORT=8765
ENV CODEX_PROXY_DEBUG=false
ENV CODEX_PROXY_LOG_LEVEL=INFO

EXPOSE 3000

CMD ["sh", "/app/start.sh"]
