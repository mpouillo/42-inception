FROM debian:bookworm

# Install Adminer
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y adminer \
    && rm -rf /var/lib/apt/lists/*

# Create WordPress directory
WORKDIR /var/www/html

# Download WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy PHP-FPM configuration
COPY confs/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy and set permissions for setup script
COPY tools/setup_wordpress.sh /usr/local/bin/setup_wordpress.sh
RUN chmod +x /usr/local/bin/setup_wordpress.sh

EXPOSE 9000

ENTRYPOINT ["setup_wordpress.sh"]
