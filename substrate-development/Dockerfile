FROM ianpurton/rust-devcontainer:latest AS base

RUN sudo apt-get update && sudo apt-get -y install clang libclang-dev llvm \
    # https://contracts.edgewa.re/#/0/setup
    && rustup toolchain install nightly-2020-06-01 \
    && rustup target add wasm32-unknown-unknown --toolchain nightly-2020-06-01 \
    && rustup component add rust-src --toolchain nightly \
    && cargo install --git https://github.com/hicommonwealth/cargo-contract cargo-contract --force \
    # Canvas node to run things
    && cargo install canvas-node --git https://github.com/paritytech/canvas-node.git --tag v0.1.4 --force --locked \
    # Subkey, to generate keys.
    && cargo install --force subkey --git https://github.com/paritytech/substrate --version 2.0.0 --locked
