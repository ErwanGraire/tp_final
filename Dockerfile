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

# On copie uniquement les fichiers nécessaires
COPY --from=builder /app/package*.json ./

# ---> CORRECTION ICI : On copie le dossier src complet
COPY --from=builder /app/src ./src

# (S'il y a d'autres dossiers nécessaires comme 'routes', 'controllers', ou 'config', 
# ajoute-les ici de la même manière, par exemple : COPY --from=builder /app/config ./config)

# Installation des dépendances de prod uniquement
RUN npm ci --omit=dev

USER node
EXPOSE 3000

# ---> CORRECTION ICI : Le point d'entrée pointe vers src/server.js
CMD ["node", "src/server.js"]