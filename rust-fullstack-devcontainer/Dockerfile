ARG DOCKER_VERSION=v20.10.7
ARG NODE_VERSION=16.9.1

FROM rust:1.56-slim-buster as mold

RUN apt-get update && apt-get install -y build-essential
#RUN apt-get update && \
#  TZ=Europe/London apt-get install -y tzdata && \
#  apt-get install -y build-essential git clang lld cmake \
#    libstdc++-10-dev libxxhash-dev zlib1g-dev libssl-dev && \
#  rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/rui314/mold.git 

RUN make -C /mold -j$(nproc) EXTRA_LDFLAGS="-fuse-ld=lld -static -Wl,-u,pthread_rwlock_rdlock -Wl,-u,pthread_rwlock_rdlock -Wl,-u,pthread_rwlock_wrlock"

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


FROM rust:1.56-slim-buster
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

# Docker CLI
COPY --chown=$USERNAME --from=docker /bin /usr/local/bin/docker

ENV DOCKER_BUILDKIT=1

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

# Earthly
RUN sudo /bin/sh -c 'curl -L https://github.com/earthly/earthly/releases/download/v0.5.23/earthly-linux-amd64 --output /usr/bin/earthly && chmod +x /usr/bin/earthly'
