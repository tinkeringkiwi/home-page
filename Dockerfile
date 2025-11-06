# Multi-stage Dockerfile for building the Hugo site and serving with nginx
# Stage 1: Build site with Hugo (extended, alpine)
FROM ghcr.io/hugomods/hugo:debian-nightly AS builder
WORKDIR /src

# Copy the site sources
COPY . /src

# Build the site (minify output)
RUN hugo --minify

# Install brotli in builder and create pre-compressed .gz and .br files for common text/static content
# so nginx can serve them directly (brotli preferred, gzip as fallback).
RUN find public -type f \
     \( -iname "*.html" -o -iname "*.css" -o -iname "*.js" -o -iname "*.xml" -o -iname "*.json" -o -iname "*.svg" -o -iname "*.txt" \) \
     -print0 | xargs -0 -n1 sh -c 'gzip -9 -n -c "$0" > "${0}.gz"' 

# Stage 2: nginx to serve the generated site
FROM nginx:stable-alpine AS final

# Remove default content and set workdir
RUN rm -rf /usr/share/nginx/html/*

# Copy custom nginx config that enables gzip_static
COPY docker/nginx.conf /etc/nginx/conf.d/default.conf

# Copy built site from builder
COPY --from=builder /src/public /usr/share/nginx/html

# Ensure permissions are sane
RUN chown -R nginx:nginx /usr/share/nginx/html || true

EXPOSE 80

# Run nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
