FROM node:18-slim

WORKDIR /app

RUN corepack enable && corepack prepare pnpm@latest --activate

COPY package.json pnpm-lock.yaml* ./
RUN pnpm install --config.strict-peer-dependencies=false

COPY . .
RUN pnpm build

EXPOSE 8080
CMD ["pnpm", "start"]
