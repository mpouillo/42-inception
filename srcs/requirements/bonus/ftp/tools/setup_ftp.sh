#! /usr/bin/env bash
set -e # Crash if any command fails

WP_PATH="/var/www/html"

# Loading env secrets
FTP_PASSWORD=$(cat /run/secrets/ftp_password)
FTP_USER=$(cat /run/secrets/ftp_user)

# Create log files with perms
touch /var/log/vsftpd.log
chmod 666 /var/log/vsftpd.log

# Set domain name in config file
if [ -n "$DOMAIN_NAME" ]; then
    sed -i "s/TEMP_DOMAIN_PLACEHOLDER/${DOMAIN_NAME}/g" /etc/vsftpd/vsftpd.conf
else
    echo "Warning: DOMAIN_NAME not set, falling back to localhost"
    sed -i "s/TEMP_DOMAIN_PLACEHOLDER/127.0.0.1/g" /etc/vsftpd/vsftpd.conf
fi

# Create the user if it doesn't exist
if ! id "${FTP_USER}" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" --home "${WP_PATH}" "${FTP_USER}"
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    chown -R "${FTP_USER}:${FTP_USER}" "${WP_PATH}"
fi

# Add user to vsftpd user list
echo "$FTP_USER" | tee -a /etc/vsftpd.userlist &> /dev/null

# Execute vsftpd as PID 1
exec vsftpd /etc/vsftpd/vsftpd.conf
