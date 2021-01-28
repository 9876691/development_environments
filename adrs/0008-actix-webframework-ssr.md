# 0008 Actix Web for web framework

Date: 28-08-2020

## Status

Accepted

## Context

We need a rust web framework 

### Criteria

* Fully async
* Supports HTTP/1.x and HTTP/2
* Good support for forms.
* Streaming and pipelining
* Client/server WebSockets support
* Transparent content compression/decompression (br, gzip, deflate)
* Powerful request routing
* Multipart streams
* Static assets
* SSL support using OpenSSL or Rustls
* Middlewares (Logger, Session, CORS, etc)
* Runs on stable Rust 1.46+

### Considered Options

1. https://github.com/actix/actix-web
1. https://github.com/seanmonstar/warp

Rocket was not considered as it only support nightly. 

## Decision

Actix web seems to be the framework with most traction.

## Consequences
