FROM node:18-slim

WORKDIR /app

# Enable pnpm
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency manifests
COPY package.json pnpm-lock.yaml* ./

# Install all dependencies
RUN pnpm install --config.strict-peer-dependencies=false

# Copy source
COPY . .

# 🔑 BUILD frontend assets for production
RUN pnpm build

# Fly expects this port
EXPOSE 8080

# Start Scramjet
CMD ["pnpm", "start"]
