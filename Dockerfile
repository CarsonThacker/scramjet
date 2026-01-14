FROM node:18-slim

WORKDIR /app

# Enable pnpm via Corepack (official Node tool)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency manifests
COPY package.json pnpm-lock.yaml* ./

# Install only production dependencies
RUN pnpm install --prod

# Copy the rest of the source
COPY . .

# Fly routes traffic to this port
EXPOSE 8080

# Start Scramjet
CMD ["pnpm", "start"]
