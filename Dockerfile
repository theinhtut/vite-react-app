# ===== 1 - Build ReactJS app =====
FROM node:18.17.1-alpine as builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package.json package-lock.json ./

# Run npm install from package-lock.json file
RUN npm ci --quiet

# Copy react source code
COPY . .

# Build react app
RUN npm run build


# ===== 2 - Nginx setup =====
FROM nginx:1.25.2-alpine

# Copy nginx config
COPY --from=builder /app/.nginx/nginx.conf /etc/nginx/conf.d/default.conf

WORKDIR /usr/share/nginx/html

# Remove default nginx files
RUN rm -rf ./*

# Copy static files from ReactJS build
COPY --from=builder /app/dist .

# Containers run nginx with global directives and daemon off
ENTRYPOINT ["nginx", "-g", "daemon off;"]