FROM ubuntu:latest AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG MIRROR=https://mirror.xeon.kr

ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt update && apt install -y --no-install-recommends ca-certificates apt-transport-https

RUN sed -i "s|http://archive.ubuntu.com/ubuntu/|${MIRROR}/ubuntu/|g; s|http://security.ubuntu.com/ubuntu/|${MIRROR}/ubuntu/|g" /etc/apt/sources.list.d/ubuntu.sources;

RUN apt update && apt upgrade -y

RUN apt update && apt install -y --no-install-recommends \
    curl \
    git \
    gnupg \
    lsb-release \
    software-properties-common \
    unzip \
    xz-utils \
    build-essential \
    cargo \
    golang \
    python3 \
    python3-dev \
    pkg-config

RUN apt clean && rm -rf /var/lib/apt/lists/*

ENV VOLTA_HOME=/root/.volta
ENV PATH=$VOLTA_HOME/bin:$PATH

COPY docker/init.sh /init.sh

RUN chmod +x /init.sh && /init.sh

ENV BASH_ENV=/etc/profile.d/volta.sh

COPY docker/entrypoint.sh /usr/local/bin/aio-builder-entrypoint
RUN chmod +x /usr/local/bin/aio-builder-entrypoint

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/aio-builder-entrypoint"]

CMD ["bash"]
