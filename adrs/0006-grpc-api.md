# 0005. API Stack.

Date: 31-08-2020

## Status

Accepted

## Context

We need the ability to define an API via some sort of document so that we can then generate clients and servers.

### Criteria

* Can generate client libraries for multiple languages
* Can generate server side stubs for rust.
* Easy to use API definition.
* Can generate API docs from the API definition.
* Integrates with actix web.

### Considered Options

1. gRPC https://grpc.io/
1. OpenAPI formerly Swagger https://www.openapis.org/
1. GraphQL https://graphql.org/

## Decision

We chose azure gRPC. https://grpc.io/

* Contrary to REST APIs, gRPC provides a strongly-typed solution with a clear contract between back-end and front-end developers to avoid human confusion and system errors.
* We are moving to a more distributed architecture to be able to support our growth and scale seemingly. gRPC is just…designed for that.
* The gRPC compiler automatically generates client and server stubs in the various coding languages we use: Typescript, Rust, Java, Scala.

The team had previous experience with swagger and didn't like the way the API is specified with Yaml or Json. So the preference 
was to use more succinct defintion file.

gRPC uses HTTP2 and this causes an issue as we are using Cloudflare Argo Tunnels which don't supoort HTTP2. [0023 Ingress (Cloudflare)](adr/0023-cloudflare-and-argo-tunnels.md)

So we went for a hybrid solution.

Define the API in gRPC using the .proto files and use the google transcoding for gRPC https://cloud.google.com/endpoints/docs/grpc/transcoding. With this technique we actuallky generate a swagger document and a swagger based API as well as the gRPC api.

Developers can use the API either with restful clients or later as Argo tunnel develops, full on gRPC.

There are also performance benefits with gRPC which although tested by us, can show speedups of 10x for some testers.

## Consequences

Github may also be a contender now they support github actions.