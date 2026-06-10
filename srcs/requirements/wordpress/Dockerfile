FROM debian:bookworm

# Update apt and install wordpress dependencies
# Remove unnessary APT cache after installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y php8.2-fpm php8.2-mysql php8.2-redis mariadb-client curl wget \
    && rm -rf /var/lib/apt/lists/*

# Download wordpress
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Copy configuration scripts
COPY confs/www.conf /etc/php/8.2/fpm/pool.d/www.conf
COPY tools/init.sh /usr/local/bin/init.sh
RUN chmod +x /usr/local/bin/init.sh

WORKDIR /var/www/html

EXPOSE 9000

ENTRYPOINT ["init.sh"]
