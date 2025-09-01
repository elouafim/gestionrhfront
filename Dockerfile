# Étape 1 : Build Angular
FROM node:18 AS build

WORKDIR /app
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install
COPY gestionrhfront/ ./

# Build Angular (production)
RUN npx ng build --configuration=production

# Étape 2 : Nginx
FROM nginx:alpine

# Supprimer la config par défaut de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copier ta config personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ⚠️ Ici on copie le bon dossier (dist/gestionrhfront)
COPY --from=build /app/dist/gestionrhfront/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
