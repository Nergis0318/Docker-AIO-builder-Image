FROM ubuntu:latest AS builder

ARG DEBIAN_FRONTEND=noninteractive
ARG MIRROR=https://mirror.xeon.kr

ENV DEBIAN_FRONTEND=${DEBIAN_FRONTEND}
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV ANDROID_HOME=/opt/android-sdk
ENV FLUTTER_HOME=/opt/flutter

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
    pkg-config \
    openjdk-17-jdk

RUN apt clean && rm -rf /var/lib/apt/lists/*

ENV VOLTA_HOME=/root/.volta
ENV PATH=/root/.local/bin:/root/.cargo/bin:/root/.bun/bin:$VOLTA_HOME/bin:$ANDROID_SDK_ROOT/cmdline-tools/latest/bin:$ANDROID_SDK_ROOT/platform-tools:$FLUTTER_HOME/bin:$FLUTTER_HOME/bin/cache/dart-sdk/bin:$PATH

COPY docker/init.sh /init.sh

RUN chmod +x /init.sh && /init.sh

ENV BASH_ENV=/etc/profile.d/volta.sh

COPY docker/entrypoint.sh /usr/local/bin/aio-builder-entrypoint
RUN chmod +x /usr/local/bin/aio-builder-entrypoint

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/aio-builder-entrypoint"]

CMD ["bash"]
