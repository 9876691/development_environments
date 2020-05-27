FROM debian:buster-slim

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y -q && \
  apt-get install -y \
  curl \
  wget \
  postgresql-client \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install age for encryption.
RUN wget https://github.com/FiloSottile/age/releases/download/v1.0.0-beta2/age-v1.0.0-beta2-linux-amd64.tar.gz && \
  tar -xvzf age-v1.0.0-beta2-linux-amd64.tar.gz \
  && mv age/age /usr/bin \
  && chmod +x /urs/bin/age

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

ENTRYPOINT ["/start.sh"]
