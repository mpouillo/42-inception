#! /usr/bin/env bash
set -e # Crash if any command fails

# Loading env secrets
. /run/secrets/credentials

# Check if env variables are set
if [ -z "$FTP_USER" ] || [ -z "$FTP_PASS" ]; then
    echo "FTP_USER or FTP_PASS is not set. Exiting."
    exit 1
fi

# Create the user if it doesn't exist
if ! id "$FTP_USER" >/dev/null 2>&1; then
    adduser --disabled-password --gecos "" --home /var/www/wordpress "$FTP_USER"
    echo "$FTP_USER:$FTP_PASS" | chpasswd
    chown -R "$FTP_USER:$FTP_USER" /var/www/wordpress
fi

# Execute vsftpd as PID 1
exec vsftpd /etc/vsftpd/vsftpd.conf
