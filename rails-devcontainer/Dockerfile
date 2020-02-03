FROM debian:bullseye-slim AS base

RUN apt-get update && apt-get install -y --no-install-recommends \
    ruby-full \
    build-essential \
    patch \
    curl \
    git \
    libpq-dev \
    ruby-dev \
    zlib1g-dev \
    liblzma-dev \
    nodejs \
    postgresql-client \
    # Cleanup leftovers
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN gem install rails

# Install Chrome for Selenium
RUN curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /chrome.deb \
    && dpkg -i /chrome.deb || apt-get install -yf \
    && rm /chrome.deb

# https://starship.rs/
RUN curl -fsSL https://starship.rs/install.sh | bash -s -- --force

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/

RUN echo 'eval "$(starship init bash)"' >> ~/.bashrc
