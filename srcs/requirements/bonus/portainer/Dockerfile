FROM debian:bookworm

# Install tar
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y curl tar \
    && rm -rf /var/lib/apt/lists/*

# Download Portainer
RUN curl -L https://github.com/portainer/portainer/releases/download/2.39.3/portainer-2.39.3-linux-amd64.tar.gz -o portainer.tar.gz \
    && tar -xzf portainer.tar.gz \
    && rm portainer.tar.gz

WORKDIR /portainer

EXPOSE 9443

ENTRYPOINT ["./portainer", "--admin-password-file=/run/secrets/portainer_password"]
