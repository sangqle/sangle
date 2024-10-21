# Base stage for building the static files
FROM node:lts AS build-stage
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Runtime stage for serving the application
FROM nginx:mainline-alpine-slim AS production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
