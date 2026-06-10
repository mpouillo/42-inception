#! /usr/bin/env bash
set -e # Crash if any command fails

# Loading env secrets
. /run/secrets/credentials
MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

# Ensure socket directory exists and is owned by mysql
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld

# Check for existing internal system tables
if [ ! -d "/var/lib/mysql/${MYSQL_DATABASE}" ]; then
    # Create a temp file to hold initialization SQL commands
    echo "Creating temporary SQL bootstrap file..."
    cat << EOF > /tmp/init.sql
FLUSH PRIVILEGES;
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

    # Run commands internally without starting the network engine
    echo "Running bootstrap configuration..."
    mariadbd --user=mysql --bootstrap < /tmp/init.sql
    rm -f /tmp/init.sql
fi

# Run mariadbd in foreground
exec mariadbd --user=mysql
