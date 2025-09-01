# Étape 1 : Build Angular
FROM node:18 AS build

WORKDIR /app
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install
COPY gestionrhfront/ ./

# Build Angular (production)
RUN npx ng build --configuration=production

# 🔍 Debug : voir où Angular a mis le build
RUN ls -R /app/dist

# Étape 2 : Nginx
FROM nginx:alpine

# Supprimer la config par défaut
RUN rm /etc/nginx/conf.d/default.conf

# Copier ta config personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier les fichiers buildés Angular (chemin correct !)
COPY --from=build /app/dist/gestionrhfront /usr/share/nginx/html

# 🔍 Debug final : vérifier ce que Nginx sert
RUN ls -R /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
