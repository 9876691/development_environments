FROM rust:1.42-slim-buster

# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=rust
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG PULUMI_VERSION=2.1.0

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, needed tools installed
    && apt-get -y install git iproute2 procps lsb-release \
    #
    # Install other dependencies
    # pkg-config & libssl-dev is for reqwest which uses rust-native-tls
    && apt-get install -y lldb curl pkg-config libssl-dev \
    #
    # Install Rust components
    && rustup update \
    && rustup component add rls rust-analysis rust-src rustfmt clippy \
    #
    # Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user.
    && groupadd --gid $USER_GID $USERNAME \
    && useradd -s /bin/bash --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # [Optional] Add sudo support for the non-root user
    && apt-get install -y sudo \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME\
    && chmod 0440 /etc/sudoers.d/$USERNAME \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# https://starship.rs/
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --force

# Azure command line
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Node used for Pulumi 
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -\
  && apt-get update -y \
  && apt-get install -y nodejs 

# Pulumi
RUN curl -fsSL https://get.pulumi.com | bash -s -- --version $PULUMI_VERSION

# Helm (used by Pulumi)
RUN curl -L https://git.io/get_helm.sh | bash

# Install kubectl
RUN  curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl

# Docker in docker
RUN apt-get update \
    #
    # Install Docker CE CLI
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli

# Stuff requirred bu diesel_cli
RUN apt-get update -y \
  && apt-get install -y --no-install-recommends postgresql postgresql-client libpq-dev \
  && cargo install diesel_cli --no-default-features --features postgres \
  && cargo install cargo-watch

# Doctl
RUN curl -OL https://github.com/digitalocean/doctl/releases/download/v1.37.0/doctl-1.37.0-linux-amd64.tar.gz \
  && tar xvf doctl-1.37.0-linux-amd64.tar.gz \
  && mv doctl /usr/bin \
  && rm doctl-1.37.0-linux-amd64.tar.gz

RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc

# Collect test results into junit style.
RUN cargo install -f cargo-suity 

# Cache builds
RUN cargo install sccache

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
ENV SHELL /bin/bash
