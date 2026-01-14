# 1. Start with Node installed
FROM node:18-slim

# 2. Set working directory
WORKDIR /app

# 3. Copy package files and install deps
COPY package*.json ./
RUN npm install --omit=dev --legacy-peer-deps

# 4. Copy the rest of the source code
COPY . .

# 5. Tell Fly which port the app will use
EXPOSE 8080

# 6. Start the server
CMD ["npm", "start"]
