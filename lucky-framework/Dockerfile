FROM crystallang/crystal:0.27.0

# Packages
RUN apt-get update && \
  apt-get install -y libgconf-2-4 build-essential curl libreadline-dev libevent-dev libssl-dev libxml2-dev libyaml-dev libgmp-dev git  && \
  # Cleanup leftovers
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# - Install Lucky prereqs
ENV builddir=/build
RUN mkdir -p $builddir && cd $builddir \
  && apt-get update -qq \
  # curl for downloads
  && apt-get install -y curl \
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
  && git checkout v0.13.2 \
  && shards install \
  && crystal build src/lucky.cr --release --no-debug \
  && mv lucky /usr/local/bin/lucky \
  && cd / && rm -rf $builddir
  
# Install Chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb
RUN dpkg -i /chrome.deb || apt-get install -yf
RUN rm /chrome.deb

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip -o /usr/local/bin/chromedriver.zip
RUN unzip /usr/local/bin/chromedriver.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver
RUN rm /usr/local/bin/chromedriver.zip

# Code-Server - Visual studio code dev env.
RUN apt-get update && apt-get install --no-install-recommends -y \
    bsdtar \
    openssl \
    locales \
    net-tools \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG en_US.utf8

ENV CODE_VERSION="1.792-vsc1.33.1"
RUN curl -sL https://github.com/codercom/code-server/releases/download/${CODE_VERSION}/code-server${CODE_VERSION}-linux-x64.tar.gz | tar --strip-components=1 -zx -C /usr/local/bin code-server${CODE_VERSION}-linux-x64/code-server

# Postgres stuff.
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update -y && apt-get install -y --no-install-recommends postgresql postgresql-client

# Setup User
RUN groupadd -r coder \
    && useradd -m -r coder -g coder -s /bin/bash \
    && echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
USER coder

RUN mkdir -p /home/coder/project

WORKDIR /home/coder/project

CMD ["code-server"]
