FROM node:20-bullseye
RUN npm install -g @openai/codex
WORKDIR /app
COPY deploy/package.json .
RUN npm install
COPY deploy/server.js .
COPY deploy/codex-config /root/.codex
ENV CODEX_HOME=/root/.codex
EXPOSE 3000
CMD ["node", "server.js"]
