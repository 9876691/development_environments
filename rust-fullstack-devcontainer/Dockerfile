ARG DOCKER_VERSION=v20.10.7
ARG NODE_VERSION=16.9.1
ARG EARTHLY_VERSION=0.6.3
ARG MOLD_VERSION=1.0.1

FROM ubuntu:20.04 as mold

RUN apt-get update && \
  TZ=Europe/London apt-get install -y tzdata && \
  apt-get install -y build-essential git clang lld cmake \
    libstdc++-10-dev libxxhash-dev zlib1g-dev libssl-dev && \
  rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rui314/mold.git 
RUN git checkout v{$MOLD_VERSION}

ENV LDFLAGS='-fuse-ld=lld -static'
ENV LDFLAGS="$LDFLAGS -Wl,-u,pthread_rwlock_rdlock"
ENV LDFLAGS="$LDFLAGS -Wl,-u,pthread_rwlock_unlock"
ENV LDFLAGS="$LDFLAGS -Wl,-u,pthread_rwlock_wrlock"

RUN make -C /mold -j$(nproc) EXTRA_LDFLAGS="$LDFLAGS"

FROM qmcgaw/binpot:docker-${DOCKER_VERSION} AS docker

# Do all the cargo install stuff
FROM rust:slim as builder

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        # CA certificates - used by curl i.e. for rustup
        #ca-certificates \
        curl \
        xz-utils \
        libpq-dev \
        unzip

RUN curl https://github.com/sagiegurari/cargo-make/releases/download/0.34.0/cargo-make-v0.34.0-x86_64-unknown-linux-musl.zip -L -o cargo-make.zip \
    && unzip cargo-make.zip \
    && mv cargo-make-v0.34.0-x86_64-unknown-linux-musl/cargo-make /home

RUN curl https://github.com/watchexec/cargo-watch/releases/download/v7.8.0/cargo-watch-v7.8.0-x86_64-unknown-linux-musl.tar.xz -L -o cargo-watch.tar.xz \
    && tar -xf cargo-watch.tar.xz \
    && mv cargo-watch-v7.8.0-x86_64-unknown-linux-musl/cargo-watch /home

RUN cargo install diesel_cli --no-default-features --features postgres

RUN cargo install cargo-chef --locked


FROM rust:slim
# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        curl \
        git \
        ssh \
        sudo \
        postgresql-client \
        # required by parcel or you can't npm install 
        build-essential \
        # For musl builds
        musl-dev \
        musl-tools \
        musl \
        # Docker in Docker for Earthly
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        gnupg \
        software-properties-common \
    #
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

# Install node.
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
RUN sudo apt-get install -y nodejs

# Create a non-root user
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME 
    
USER $USERNAME

COPY --chown=$USERNAME --from=builder /home/cargo-make $CARGO_HOME/bin
COPY --chown=$USERNAME --from=builder /home/cargo-watch $CARGO_HOME/bin
COPY --chown=$USERNAME --from=builder /usr/local/cargo/bin/diesel $CARGO_HOME/bin/diesel
COPY --chown=$USERNAME --from=builder /usr/local/cargo/bin/cargo-chef $CARGO_HOME/bin

# Essential tools
RUN rustup component add rustfmt clippy

# For musl builds
RUN rustup target add x86_64-unknown-linux-musl

# mold
COPY --chown=$USERNAME --from=mold /mold/mold /usr/bin/mold
COPY --chown=$USERNAME --from=mold /mold/mold-wrapper.so /usr/bin/mold-wrapper.so


# Docker Engine for Earthly. 
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
        # Docker in Docker for Earthly
        apt-transport-https \
        ca-certificates \
        gnupg-agent \
        gnupg \
        software-properties-common \
    #
    #
    # Clean up
    && sudo apt-get autoremove -y \
    && sudo apt-get clean -y \
    && sudo rm -r /var/cache/* /var/lib/apt/lists/*
RUN  curl -fsSL "https://download.docker.com/linux/debian/gpg" | sudo apt-key add -
RUN sudo add-apt-repository \
        "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable" \
    && sudo apt-get update \
    && sudo apt-get install -y docker-ce docker-ce-cli containerd.io \
    #
    #
    # Clean up
    && sudo apt-get autoremove -y \
    && sudo apt-get clean -y \
    && sudo rm -r /var/cache/* /var/lib/apt/lists/*
# Earthly
RUN sudo /bin/sh -c 'curl -L https://github.com/earthly/earthly/releases/download/v${EARTHLY_VERSION}/earthly-linux-amd64 --output /usr/bin/earthly && chmod +x /usr/bin/earthly'
