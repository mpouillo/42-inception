FROM debian:bookworm

# Update apt and install wordpress dependencies
# Remove unnessary APT cache after installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y vsftpd \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

# Generate an SSL/TLS certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out /etc/ssl/certs/servercertificate.pem \
    -keyout /etc/ssl/private/serverkey.pem \
    -subj "/C=${COUNTRY}/ST=${STATE}/L=${LOCALITY}/O=${ORGANIZATION}/OU=${ORGANIZATION_UNIT}/CN=${COMMON_NAME}/UID=${USER_ID}"

RUN chmod 600 /etc/ssl/certs/servercertificate.pem
RUN chmod 644 /etc/ssl/private/serverkey.pem

# Copy vsftp configuration files and scripts
COPY confs/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup_ftp.sh /usr/local/bin/setup_ftp.sh
RUN chmod +x /usr/local/bin/setup_ftp.sh

EXPOSE 21 40000-40005

ENTRYPOINT ["setup_ftp.sh"]
