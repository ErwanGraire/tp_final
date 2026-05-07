# --- ÉTAPE 1 : Build ---
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .

# --- ÉTAPE 2 : Image Finale ---
FROM node:18-alpine
WORKDIR /app
ENV NODE_ENV=production


COPY --from=builder /app/package*.json ./


COPY --from=builder /app/src ./src


RUN npm ci --omit=dev

USER node
EXPOSE 3000


CMD ["node", "src/server.js"]
