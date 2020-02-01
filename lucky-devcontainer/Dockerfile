FROM crystallang/crystal:0.32.1 AS base

# Packages
RUN apt-get update && apt-get install -y --no-install-recommends \
  libevent-2.0-5 \
  libc6-dev \
  llibpcre2-dev \
  libpng-dev \
  libssl1.0-dev \
  libyaml-dev \
  zlib1g-dev \
  libgconf-2-4 \
  build-essential \
  libreadline-dev \
  libevent-dev \
  libssl-dev \
  libevent-2.0-5 \
  libxml2-dev \
  libyaml-dev \
  libgmp-dev \
  # Cleanup leftovers
  && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y  --no-install-recommends \
  git \
  curl \
  postgresql-client

# - Install Lucky prereqs
ENV builddir=/build
RUN mkdir -p $builddir && cd $builddir \
  # Heroku
  && curl https://cli-assets.heroku.com/install.sh | sh 

# Node and Yarn
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -\
  && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list\
  && apt-get update -y \
  && apt-get install -y nodejs yarn wget zip


RUN git clone https://github.com/luckyframework/lucky_cli $builddir/lucky_cli \
  && cd $builddir/lucky_cli \
  && git checkout v0.18.3 \
  && shards install \
  && crystal build src/lucky.cr --release --no-debug \
  && mv lucky /usr/local/bin/lucky \
  && cd / && rm -rf $builddir

# Install Chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb
# Also need chromedirver.
RUN apt-get install -y chromium-chromedriver

# Pulumi
RUN curl -fsSL https://get.pulumi.com | bash

# https://starship.rs/
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --force

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

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/

RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
