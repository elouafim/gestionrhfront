# Étape 1 : Compilation de l'application Angular
FROM node:18 AS build

WORKDIR /app
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install
COPY gestionrhfront/ ./
RUN npm run build -- --configuration production

# Étape 2 : Nginx pour servir l'application Angular
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier le build Angular compilé
COPY --from=build /app/dist/gestionrhfront/ /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
