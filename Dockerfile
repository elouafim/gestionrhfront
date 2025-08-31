# Étape 1 : Build Angular
FROM node:18 AS build

WORKDIR /app
COPY gestionrhfront/package.json gestionrhfront/package-lock.json ./
RUN npm install
COPY gestionrhfront/ ./
RUN npm run build --configuration production

# Étape 2 : Nginx
FROM nginx:alpine

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d/default.conf

# ⚠️ Angular 19 → build généré dans "dist/<projet>/browser"
COPY --from=build /app/dist/gestionrhfront/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
