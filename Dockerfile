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

# Install deps (includes dev deps; needed for build)
RUN pnpm install --config.strict-peer-dependencies=false

# Copy source
COPY . .

# Build:
# IMPORTANT: build:wasm must run BEFORE build/build:all so wasm outputs exist.
RUN set -eux; \
    if pnpm -s run | grep -qE 'build:wasm'; then \
      pnpm run build:wasm; \
    fi; \
    if pnpm -s run | grep -qE 'build:all'; then \
      pnpm run build:all; \
    else \
      pnpm run build; \
    fi

# Fly listens on 8080
ENV PORT=8080
EXPOSE 8080

CMD ["pnpm", "start"]
