#! /usr/bin/env bash
set -e # Crash if any commands fails

# Ensure PHP-FPM runtime directory exists
mkdir -p /run/php

# Loading env secrets
. /run/secrets/credentials
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

# Check if WordPress is already downloaded
if [ ! -f "wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating 'wp-config.php'..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    echo "Configuring Redis cache..."
    wp config set WP_CACHE true --type=constant --allow-root
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --raw --allow-root

    echo "Installing WordPress..."
    wp core install \
        --url="https://${DOMAIN_NAME}" \
        --title="Inception" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --skip-email \
        --allow-root

    echo "Installing and enabling Redis cache plugin..."
    wp plugin install redis-cache --activate --allow-root
    wp redis enable --allow-root

    echo "Creating regular user..."
    wp user create "${WP_USER}" "${WP_EMAIL}" \
        --user_pass="${WP_PASSWORD}" \
        --role=author \
        --allow-root
fi

# Run PHP-FPM in foreground
exec php-fpm8.2 -F
