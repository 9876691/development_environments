# See here for image contents: https://github.com/microsoft/vscode-dev-containers/tree/v0.148.1/containers/rust/.devcontainer/base.Dockerfile
# figlet with comments | sed -e 's/^/#  /'
FROM mcr.microsoft.com/vscode/devcontainers/rust:0-1

ARG PULUMI_VERSION=2.14.0

USER vscode

RUN cd ~ \
  #    _                           ____ _     ___ 
  #   / \    _____   _ _ __ ___   / ___| |   |_ _|
  #  / _ \  |_  / | | | '__/ _ \ | |   | |    | | 
  # / ___ \  / /| |_| | | |  __/ | |___| |___ | | 
  #/_/   \_\/___|\__,_|_|  \___|  \____|_____|___|
  && curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash \

  # _   _           _          _ ____  
  #| \ | | ___   __| | ___    | / ___| 
  #|  \| |/ _ \ / _` |/ _ \_  | \___ \ 
  #| |\  | (_) | (_| |  __/ |_| |___) |
  #|_| \_|\___/ \__,_|\___|\___/|____/ 
  && curl -sL https://deb.nodesource.com/setup_14.x | sudo bash -\
  && sudo apt-get update -y \
  && sudo apt-get install -y nodejs \

  # _          _               _   _ 
  #| | ___   _| |__   ___  ___| |_| |
  #| |/ / | | | '_ \ / _ \/ __| __| |
  #|   <| |_| | |_) |  __/ (__| |_| |
  #|_|\_\\__,_|_.__/ \___|\___|\__|_|
  && sudo curl -sSL -o /usr/local/bin/kubectl https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl \
  && sudo chmod +x /usr/local/bin/kubectl \

  # Install Docker CE CLI (Docker in Docker)
  && sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common lsb-release \
  && sudo curl -fsSL https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]')/gpg | sudo apt-key add - 2>/dev/null \
  && sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/$(lsb_release -is | tr '[:upper:]' '[:lower:]') $(lsb_release -cs) stable" \
  && sudo apt-get update \
  && sudo apt-get install -y docker-ce-cli \

  #     _            _   _ 
  #  __| | ___   ___| |_| |
  # / _` |/ _ \ / __| __| |
  #| (_| | (_) | (__| |_| |
  # \__,_|\___/ \___|\__|_|
  && curl -OL https://github.com/digitalocean/doctl/releases/download/v1.37.0/doctl-1.37.0-linux-amd64.tar.gz \
  && tar xvf doctl-1.37.0-linux-amd64.tar.gz \
  && sudo mv doctl /usr/bin \
  && rm doctl-1.37.0-linux-amd64.tar.gz \

  # _   _      _             _____ 
  #| | | | ___| |_ __ ___   |___ / 
  #| |_| |/ _ \ | '_ ` _ \    |_ \ 
  #|  _  |  __/ | | | | | |  ___) |
  #|_| |_|\___|_|_| |_| |_| |____/ 
  && curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 && sudo chmod 700 get_helm.sh && sudo ./get_helm.sh \

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
  && sudo apt-get install -y postgresql postgresql-client libpq-dev figlet \

  # _     ___      
  #| | __/ _ \ ___ 
  #| |/ / (_) / __|
  #|   < \__, \__ \
  #|_|\_\  /_/|___/
  && curl -L -s https://github.com/derailed/k9s/releases/download/v0.24.1/k9s_Linux_x86_64.tar.gz | tar xvz -C /tmp && sudo mv /tmp/k9s /usr/bin \
  # adr-tools
  && git clone --depth 1 https://github.com/npryce/adr-tools && sudo mv adr-tools/src/* /usr/bin && rm -rf adr-tools \
  # Stuff needed for cypress
  && sudo apt-get install -y --no-install-recommends libgtk2.0-0 libgtk-3-0 libgbm-dev libnotify-dev libgconf-2-4 libnss3 libxss1 libasound2 libxtst6 xauth xvfb \
  
  # ____        _                 _ 
  #|  _ \ _   _| |_   _ _ __ ___ (_)
  #| |_) | | | | | | | | '_ ` _ \| |
  #|  __/| |_| | | |_| | | | | | | |
  #|_|    \__,_|_|\__,_|_| |_| |_|_|
  && cd ~ && curl -fsSL https://get.pulumi.com | bash -s -- --version $PULUMI_VERSION \
  # Clean up
  && sudo apt-get autoremove -y \
  && sudo apt-get clean -y \
  && sudo rm -rf /var/lib/apt/lists/*

RUN echo "alias gst='git status'"  >> ~/.bashrc \ 
    && echo "alias gcm='git checkout master'"  >> ~/.bashrc \  
    && echo "alias gp='git push'"  >> ~/.bashrc \  
    && echo "alias gcam='git commit -a -m'"  >> ~/.bashrc \  
    && echo "alias gpsup='git push --set-upstream origin $(git_current_branch)'"  >> ~/.bashrc \  
    && echo "alias gcb='git checkout -b'" >> ~/.bashrc \
    && echo "alias gitsetup='git config --global user.name \$NAME && git config --global user.email \$EMAIL && mkdir -p ~/.ssh && cp -u /home/host-ssh/id_rsa ~/.ssh && chmod 600 ~/.ssh/id_rsa && ssh-keygen -y -f ~/.ssh/id_rsa > ~/.ssh/id_rsa.pub'" >> ~/.bashrc
    
