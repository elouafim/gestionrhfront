# Étape 1 : Build Angular
FROM node:18 AS build

WORKDIR /app
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install
COPY gestionrhfront/ ./

# ⚠️ utiliser "npx ng build --configuration=production" sinon Angular croit que "production" est un projet
RUN npx ng build --configuration=production

# Étape 2 : Nginx
FROM nginx:alpine

# Supprimer la config par défaut de Nginx
RUN rm /etc/nginx/conf.d/default.conf

# Copier ta config personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ⚠️ Angular 17+ → le build est dans "dist/<nom-du-projet>/browser"
COPY --from=build /app/dist/gestionrhfront/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
