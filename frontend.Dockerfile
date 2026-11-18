# Этап 1: сборка фронтенда (инструменты сборки не попадают в итоговый образ)
FROM node:22-alpine AS build
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm ci
COPY . .
RUN npm run build

# Этап 2: итоговый образ — nginx отдаёт собранную статику
FROM nginxinc/nginx-unprivileged:1.27-alpine
COPY deploy/frontend.nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/dist /usr/share/nginx/html
EXPOSE 8080
