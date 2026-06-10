FROM debian:bookworm

# Update apt and install redis
# Remove unnessary APT cache after installation
RUN apt-get update \
    && apt-get upgrade -y \
    && apt-get install -y redis-server \
    && rm -rf /var/lib/apt/lists/*

# Copy configuration file
COPY confs/redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]
