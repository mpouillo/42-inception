FROM debian:bookworm

# Install nginx
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*

# Ensure nginx runs as www-data with correct UID
RUN usermod -u 33 www-data && groupmod -g 33 www-data

# Copy configuration and static files
COPY confs/nginx.conf /etc/nginx/nginx.conf
COPY tools/ /var/www/static/

EXPOSE 8080

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
