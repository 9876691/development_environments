# https://github.com/improbable-eng/grpc-web
# docker build -t ianpurton/grpc-web .
FROM debian:stretch-slim as base

RUN apt update \
    && apt install -y wget zip \
    && wget https://github.com/improbable-eng/grpc-web/releases/download/v0.14.0/grpcwebproxy-v0.14.0-linux-x86_64.zip  \
    && unzip grpc* \
    && mv dist/grpcwebproxy-v0.14.0-linux-x86_64 /usr/bin/grpcwebproxy \
    && rm *.zip 

FROM debian:stretch-slim 

ENV GRPC_SERVER_HOST=localhost
ENV GRPC_SERVER_PORT=50051

COPY --from=base /usr/bin/grpcwebproxy /usr/bin/grpcwebproxy

CMD grpcwebproxy --backend_addr=$GRPC_SERVER_HOST:$GRPC_SERVER_PORT --run_tls_server=false --allow_all_origins --use_websockets