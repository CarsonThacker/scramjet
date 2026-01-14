FROM node:22-slim

WORKDIR /app

# System deps commonly needed for builds + git
RUN apt-get update && apt-get install -y \
    git \
    ca-certificates \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency manifests first for caching
COPY package.json pnpm-lock.yaml* ./

# Install deps (includes dev deps; your runtime needs some of them)
RUN pnpm install --config.strict-peer-dependencies=false

# Copy source
COPY . .

# Build (Scramjet projects often use build:all; fall back safely)
RUN if pnpm -s run | grep -qE 'build:all'; then \
      pnpm run build:all; \
    elif pnpm -s run | grep -qE 'build:wasm'; then \
      pnpm run build:wasm && pnpm run build; \
    else \
      pnpm run build; \
    fi

# Fly listens on 8080
ENV PORT=8080
EXPOSE 8080

CMD ["pnpm", "start"]
