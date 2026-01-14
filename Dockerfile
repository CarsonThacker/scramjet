FROM node:18-slim

WORKDIR /app

# Install required system dependencies
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency manifests
COPY package.json pnpm-lock.yaml* ./

# Install all dependencies
RUN pnpm install --config.strict-peer-dependencies=false

# Copy source
COPY . .

# 🔑 REQUIRED: build the WASM rewriter first
RUN pnpm run build:wasm

# Build the Scramjet frontend
RUN pnpm build

# Fly expects this port
EXPOSE 8080

CMD ["pnpm", "start"]
