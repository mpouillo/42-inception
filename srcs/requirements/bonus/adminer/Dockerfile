FROM debian:bookworm

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install Adminer
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y php-cli php-mysql wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html

# Download Adminer as "index.php" so PHP loads is as default homepage
RUN wget https://www.adminer.org/latest.php -O index.php

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]