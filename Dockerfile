FROM debian:jessie

# Get curl so we can install Docker
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

# Install Docker
RUN curl -sSL -O https://get.docker.com/builds/Linux/x86_64/docker-1.6.0 \
    && chmod +x docker-1.6.0 && mv docker-1.6.0 /usr/local/bin/docker

ADD ./build-registry /usr/local/bin/build-registry

ADD ./config.yml /store/config.yml
ADD ./nginx.conf /store/nginx.conf

VOLUME ['/data']

ENTRYPOINT ["build-registry"]