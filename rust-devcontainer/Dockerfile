# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.148.1/containers/rust/.devcontainer/base.Dockerfile

FROM mcr.microsoft.com/vscode/devcontainers/rust:0-1

ARG PULUMI_VERSION=2.14.0

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash \
  #    _                           ____ _     ___ 
  #   / \    _____   _ _ __ ___   / ___| |   |_ _|
  #  / _ \  |_  / | | | '__/ _ \ | |   | |    | | 
  # / ___ \  / /| |_| | | |  __/ | |___| |___ | | 
  #/_/   \_\/___|\__,_|_|  \___|  \____|_____|___|
  # Node used for Pulumi - https://nodejs.org/en/about/releases/
  && curl -sL https://deb.nodesource.com/setup_14.x | bash -\
  && apt-get update -y \
  # _   _           _          _ ____  
  #| \ | | ___   __| | ___    | / ___| 
  #|  \| |/ _ \ / _` |/ _ \_  | \___ \ 
  #| |\  | (_) | (_| |  __/ |_| |___) |
  #|_| \_|\___/ \__,_|\___|\___/|____/ 
  && apt-get install -y nodejs \
  # _          _               _   _ 
  #| | ___   _| |__   ___  ___| |_| |
  #| |/ / | | | '_ \ / _ \/ __| __| |
  #|   <| |_| | |_) |  __/ (__| |_| |
  #|_|\_\\__,_|_.__/ \___|\___|\__|_|
  && curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  # Install Docker CE CLI (Docker in Docker)
  && apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
  && curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | apt-key add - 2>/dev/null \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
  && apt-get update \
  && apt-get install -y docker-ce-cli \
  #     _            _   _ 
  #  __| | ___   ___| |_| |
  # / _` |/ _ \ / __| __| |
  #| (_| | (_) | (__| |_| |
  # \__,_|\___/ \___|\__|_|
  && curl -OL https://github.com/digitalocean/doctl/releases/download/v1.37.0/doctl-1.37.0-linux-amd64.tar.gz \
  && tar xvf doctl-1.37.0-linux-amd64.tar.gz \
  && mv doctl /usr/bin \
  && rm doctl-1.37.0-linux-amd64.tar.gz \
  # _   _      _             _____ 
  #| | | | ___| |_ __ ___   |___ / 
  #| |_| |/ _ \ | '_ ` _ \    |_ \ 
  #|  _  |  __/ | | | | | |  ___) |
  #|_| |_|\___|_|_| |_| |_| |____/ 
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && chmod 700 get_helm.sh && ./get_helm.sh \
  # ____  _                _    ____ _     ___ 
  #|  _ \(_) ___  ___  ___| |  / ___| |   |_ _|
  #| | | | |/ _ \/ __|/ _ \ | | |   | |    | | 
  #| |_| | |  __/\__ \  __/ | | |___| |___ | | 
  #|____/|_|\___||___/\___|_|  \____|_____|___|
  && cargo install diesel_cli --no-default-features --features postgres \
  # cargo plugin for linting your dependencies.
  && cargo install cargo-watch cargo-deny audit outdated trunk \
  # ____  ____   ___  _     
  #|  _ \/ ___| / _ \| |    
  #| |_) \___ \| | | | |    
  #|  __/ ___) | |_| | |___ 
  #|_|   |____/ \__\_\_____|
  && apt-get install -y postgresql postgresql-client libpq-dev figlet \
  # _     ___      
  #| | __/ _ \ ___ 
  #| |/ / (_) / __|
  #|   < \__, \__ \
  #|_|\_\  /_/|___/
  && curl -L -s https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz | tar xvz -C /tmp && mv /tmp/k9s /usr/bin \
  # adr-tools
  && git clone --depth 1 https://github.com/npryce/adr-tools && mv adr-tools/src/* /usr/bin && rm -rf adr-tools \
  # Stuff needed for cypress
  && apt-get install -y --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

USER vscode

# ____        _                 _ 
#|  _ \ _   _| |_   _ _ __ ___ (_)
#| |_) | | | | | | | | '_ ` _ \| |
#|  __/| |_| | | |_| | | | | | | |
#|_|    \__,_|_|\__,_|_| |_| |_|_|
RUN cd ~ && curl -fsSL https://get.pulumi.com | bash -s -- --version $PULUMI_VERSION
