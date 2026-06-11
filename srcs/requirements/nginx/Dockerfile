FROM debian:bookworm

# Install nginx and openssl
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# Ensure nginx runs as www-data with correct UID
RUN usermod -u 33 www-data && groupmod -g 33 www-data

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate an SSL/TLS certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/nginx.crt \
    -keyout /etc/nginx/ssl/nginx.key \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATION_UNIT}/CN=${COMMON_NAME}/UID=${USER_ID}"

RUN chmod 600 /etc/nginx/ssl/nginx.key
RUN chmod 644 /etc/nginx/ssl/nginx.crt

# Copy NGINX configuration
COPY confs/nginx.conf /etc/nginx/nginx.conf

EXPOSE 443

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
