FROM rust:1.48-slim-buster

# This Dockerfile adds a non-root 'vscode' user with sudo access. However, for Linux,
# this user's GID/UID must match your local user UID/GID to avoid permission issues
# with bind mounts. Update USER_UID / USER_GID if yours is not 1000. See
# https://aka.ms/vscode-remote/containers/non-root-user for details.
ARG USERNAME=development
ARG USER_UID=1000
ARG USER_GID=$USER_UID

ARG PULUMI_VERSION=2.14.0

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Configure apt and install packages
RUN apt-get update \
    && apt-get -y install --no-install-recommends apt-utils dialog 2>&1 \
    #
    # Verify git, needed tools installed
    && apt-get -y install git build-essential iproute2 procps lsb-release unzip \
    #
    # Install other dependencies
    # pkg-config & libssl-dev is for reqwest which uses rust-native-tls
    && apt-get install -y lldb curl pkg-config libssl-dev \
    #
    # Stuff needed for cypress
    && apt-get install -y --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
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
    # Install Docker CE CLI (Docker in Docker)
    && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
    && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
    && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    #
    # Stuff required by diesel
    && apt-get install -y postgresql postgresql-client libpq-dev \
    #
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt-get
ENV DEBIAN_FRONTEND=
ENV SHELL /bin/bash

# https://starship.rs/
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --force \
  # Azure command line (needed)
  && curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  # Node used for Pulumi - https://nodejs.org/en/about/releases/
  && curl -sL https://deb.nodesource.com/setup_14.x | bash -\
  && apt-get update -y \
  && apt-get install -y nodejs \
  # Kubectl
  && curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  # Doctl
  && curl -OL https://github.com/digitalocean/doctl/releases/download/v1.37.0/doctl-1.37.0-linux-amd64.tar.gz \
  && tar xvf doctl-1.37.0-linux-amd64.tar.gz \
  && mv doctl /usr/bin \
  && rm doctl-1.37.0-linux-amd64.tar.gz \
  # Helm 3 (used by Pulumi)
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh \
  # Linkerd
  && curl -sL https://run.linkerd.io/install | sh \
  && curl -L -s https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz | tar xvz -C /tmp && mv /tmp/k9s /usr/bin \
  && git clone --depth 1 https://github.com/npryce/adr-tools && mv ard-tools/src/* /usr/bin && rm -rf adr-tools

USER $USERNAME

# Pulumi
RUN cd ~ && curl -fsSL https://get.pulumi.com | bash -s -- --version $PULUMI_VERSION \
# Stuff requirred bu diesel_cli
  && cargo install diesel_cli --no-default-features --features postgres \
  && cargo install cargo-watch \
  # cargo plugin for linting your dependencies.
  && cargo install cargo-deny audit outdated trunk

# The below doesn't work.
#RUN cargo install wasm-bindgen-cli  && rustup target add wasm32-unknown-unknown

RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
