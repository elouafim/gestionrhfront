# ---------------------------
# Étape 1 : Build Angular
# ---------------------------
FROM node:18 AS build

WORKDIR /app

# Copier package.json et package-lock.json
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./

# Installer les dépendances
RUN npm install

# Copier tout le projet Angular
COPY gestionrhfront/ ./

# 🔍 Debug : vérifier que tous les fichiers source sont présents
RUN echo "=== Contenu de /app ===" && ls -R /app
RUN echo "=== Contenu de /app/src ===" && ls -R /app/src
RUN echo "=== /app après COPY ===" && ls -R /app

# Build Angular en production
RUN npx ng build --configuration=production

# 🔍 Debug : vérifier où Angular a mis le build
RUN echo "=== Contenu de /app/dist ===" && ls -R /app/dist

# ---------------------------
# Étape 2 : Nginx
# ---------------------------
FROM nginx:alpine

# Supprimer la config par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Copier la config personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build Angular dans Nginx
COPY --from=build /app/dist/gestionrhfront /usr/share/nginx/html

# 🔍 Debug final : vérifier le contenu dans Nginx
RUN echo "=== Contenu de /usr/share/nginx/html ===" && ls -R /usr/share/nginx/html

EXPOSE 80

# Lancer Nginx
CMD ["nginx", "-g", "daemon off;"]
