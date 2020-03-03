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

ADD start.sh /start.sh
RUN chmod 0755 /start.sh

ENTRYPOINT ["/start.sh"]