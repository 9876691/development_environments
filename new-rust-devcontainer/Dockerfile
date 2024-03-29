ARG DOCKER_VERSION=v20.10.7

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
        unzip

RUN curl https://github.com/sagiegurari/cargo-make/releases/download/0.34.0/cargo-make-v0.34.0-x86_64-unknown-linux-musl.zip -L -o cargo-make.zip \
    && unzip cargo-make.zip \
    && mv cargo-make-v0.34.0-x86_64-unknown-linux-musl/cargo-make /home

RUN curl https://github.com/watchexec/cargo-watch/releases/download/v7.8.0/cargo-watch-v7.8.0-x86_64-unknown-linux-musl.tar.xz -L -o cargo-watch.tar.xz \
    && tar -xf cargo-watch.tar.xz \
    && mv cargo-watch-v7.8.0-x86_64-unknown-linux-musl/cargo-watch /home

FROM rust:1.55-slim-buster
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
    #
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -r /var/cache/* /var/lib/apt/lists/*

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

# Essential tools
RUN rustup component add rustfmt clippy
