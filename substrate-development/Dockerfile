FROM ianpurton/rust-devcontainer:latest AS base

RUN sudo apt-get update && sudo apt-get -y install clang libclang-dev llvm

# Add nightly to the toolchain.
RUN cargo install --git https://github.com/hicommonwealth/cargo-contract cargo-contract --force \
    && rustup toolchain install nightly \
    && rustup target add wasm32-unknown-unknown --toolchain nightly \
    && rustup toolchain install nightly --component rust-src

# The node we can run to deploy contracts.
RUN cargo install canvas-node --git https://github.com/paritytech/canvas-node.git --tag v0.1.4 --force --locked

# The subkey command for creating accounts.
RUN cargo install --force subkey --git https://github.com/paritytech/substrate --version 2.0.0 --locked
