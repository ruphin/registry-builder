FROM debian:jessie

# Get curl so we can install Docker
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.5.0 \
    && chmod +x docker-1.5.0 && mv docker-1.5.0 /usr/local/bin/docker

ADD ./build-registry /usr/local/bin/build-registry

VOLUME ['/data', '/etc/nginx/certs', '/etc/nginx/htpasswd']

ENTRYPOINT ["build-registry"]