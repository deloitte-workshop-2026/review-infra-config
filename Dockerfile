# Stage 1: build
FROM node:20-alpine@sha256:a374d2f4a2c4f82e0a6e0a1f1a7e1b9c0d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6 AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY . .

# Stage 2: runtime
FROM node:20-alpine@sha256:a374d2f4a2c4f82e0a6e0a1f1a7e1b9c0d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6
RUN addgroup -S app && adduser -S app -G app
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/src ./src
USER app
EXPOSE 3000
CMD ["node", "src/index.js"]
