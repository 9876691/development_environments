FROM rust:1.42-slim-buster

RUN apt-get update -y \  
    && apt-get install -y --no-install-recommends postgresql-client libpq-dev \
    && cargo install diesel_cli --no-default-features --features postgres