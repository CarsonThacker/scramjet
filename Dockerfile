FROM node:18-slim

WORKDIR /app

# Enable pnpm (required by Scramjet)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy manifests
COPY package.json pnpm-lock.yaml* ./

# Install ALL dependencies (Scramjet requires this)
RUN pnpm install --legacy-peer-deps

# Copy source
COPY . .

# Fly expects this port
EXPOSE 8080

# Start Scramjet
CMD ["pnpm", "start"]
