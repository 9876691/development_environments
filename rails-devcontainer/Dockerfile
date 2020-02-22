FROM debian:bullseye-slim AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    ruby-full \
    build-essential \
    patch \
    curl \
    git \
    libpq-dev \
    wget \
    # python Needed by node-gyp whatever that is.
    python \ 
    ssh \
    zip \
    unzip \
    ruby-dev \
    libssl-dev \
    gnupg2 \
    zlib1g-dev \
    liblzma-dev \
    nodejs \
    postgresql-client \
    # Cleanup leftovers
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install rails

# Yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list\
  && apt-get update -y \
  && apt-get install -y yarn

# Install Chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb \
    && dpkg -i /chrome.deb || apt-get install -yf \
    && rm /chrome.deb

# Install chromedriver for Selenium
RUN curl https://chromedriver.storage.googleapis.com/74.0.3729.6/chromedriver_linux64.zip -o /usr/local/bin/chromedriver.zip \
    && unzip /usr/local/bin/chromedriver.zip -d /usr/local/bin/ \
    && chmod +x /usr/local/bin/chromedriver \
    && rm /usr/local/bin/chromedriver.zip

# https://starship.rs/
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --force

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/

RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
