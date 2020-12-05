FROM rust:slim AS builder
    
RUN cargo install diesel_cli --no-default-features --features postgres

FROM debian:slim

RUN apt-get update -y \  
    && apt-get install -y --no-install-recommends postgresql-client libpq-dev \
    rm -rf /var/lib/apt/lists/*
    
COPY --from=builder /usr/local/cargo/bin/diesel /bin/diesel

WORKDIR /usr/src
