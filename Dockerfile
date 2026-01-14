FROM node:18-slim

WORKDIR /app

# Enable pnpm via Corepack (required by Scramjet)
RUN corepack enable && corepack prepare pnpm@latest --activate

# Copy dependency manifests
COPY package.json pnpm-lock.yaml* ./

# Install ALL dependencies (Scramjet requires full install)
# Disable strict peer dependency enforcement (pnpm equivalent of npm --legacy-peer-deps)
RUN pnpm install --config.strict-peer-dependencies=false

# Copy the rest of the source code
COPY . .

# Fly routes traffic here
EXPOSE 8080

# Start Scramjet
CMD ["pnpm", "start"]
