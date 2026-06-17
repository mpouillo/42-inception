#! /usr/bin/env bash

set -e

# Ensure PHP-FPM runtime directory exists
mkdir -p /run/php

WP_PATH="/var/www/html"

# Loading secrets
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_USER=$(cat /run/secrets/db_user)
WP_ADMIN_EMAIL=$(cat /run/secrets/wp_admin_email)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_ADMIN_USER=$(cat /run/secrets/wp_admin_user)
WP_EMAIL=$(cat /run/secrets/wp_email)
WP_PASSWORD=$(cat /run/secrets/wp_password)
WP_USER=$(cat /run/secrets/wp_user)

echo "Setting up WordPress..."

# Download and configure WordPress if not present
if [ ! -f "$WP_PATH/wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating 'wp-config.php'..."
    wp config create \
        --dbname="${MYSQL_DATABASE}" \
        --dbuser="${MYSQL_USER}" \
        --dbpass="${MYSQL_PASSWORD}" \
        --dbhost="mariadb" \
        --allow-root

    # Set secure permissions
    find "$WP_PATH" -type d -exec chmod 750 {} \;
    find "$WP_PATH" -type f -exec chmod 640 {} \;
    chown -R www-data:www-data "$WP_PATH"

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

    echo "WordPress setup complete."
else
    echo "WordPress already initialized, skipping setup."
fi

echo "Setting proper permissions for WordPress files..."
chown -R www-data:www-data $WP_PATH

find $WP_PATH -type d -exec chmod 755 {} +
find $WP_PATH -type f -exec chmod 644 {} +

echo "Starting PHP-FPM..."
exec php-fpm8.2 -F
