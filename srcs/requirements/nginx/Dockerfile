FROM debian:bookworm

# Update apt and install wordpress dependencies
# Remove unnessary APT cache after installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y nginx openssl \
    && rm -rf /var/lib/apt/lists/*

# Create directory for TLS certificates
RUN mkdir -p /etc/nginx/ssl

# Generate an SSL/TLS certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/nginx/ssl/inception.crt \
    -keyout /etc/nginx/ssl/inception.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=mpouillo.42.fr/UID=mpouillo"

# Copy NGINX configuration
COPY confs/nginx.conf /etc/nginx/conf.d/default.conf

CMD ["nginx", "-g", "daemon off;"]
