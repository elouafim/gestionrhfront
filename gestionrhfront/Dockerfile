# Étape 1: Compilation de l'application Angular
FROM node:18 AS build

# Définir le répertoire de travail
WORKDIR /app

# Copier les fichiers de dépendances depuis le sous-dossier
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install

# Copier le reste du code Angular
COPY gestionrhfront/ ./

# Compiler l'application pour la production
RUN npm run build

# Étape 2: Création de l'image de production légère
FROM node:18-slim

WORKDIR /app

# Copier uniquement les dépendances de production depuis le sous-dossier
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install --omit=dev

# Copier le serveur Express (à la racine du projet)
COPY gestionrhfront/server.js .
# Copier l'application compilée depuis l'étape de build
COPY --from=build /app/dist/gestionrhfront/ ./dist/gestionrhfront/

# Exposer le port sur lequel le serveur tourne
EXPOSE 8080

# La commande pour démarrer le serveur
CMD ["node", "server.js"]
