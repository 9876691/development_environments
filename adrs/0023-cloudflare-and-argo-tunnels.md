# Cloudflare - DNS, firewall, DDoS and other protections.

Date: 28-08-2020

## Status

Accepted

## Context

Cloudflare provides DDoS protection as well as a firewall. 

### Criteria

* DNS administration
* Firewall - We would like to block 
* Hide our IP address
* Rate limiting
* TLS termination

### Considered Options

1. Cloudflare https://www.cloudflare.com/en-gb/
1. WAF -https://modsecurity.org/

## Decision

Cloudflare gives us everything we need and more.

## Consequences

TLS termination and ingress

Argo tunnels allow us to create a TLS terminated ingress. 

https://www.cloudflare.com/en-gb/products/argo-tunnel/

Blocking most script kiddies by only allowing through paths we know about.

```
(not http.request.uri.path contains "/contact" and http.request.uri.path ne "/" 
  and not http.request.uri.path contains "/auth" 
  and not http.request.uri.path contains "/inbox" 
  and not http.request.uri.path contains "/screening" 
  and not http.request.uri.path contains "/static/" 
  and not http.request.uri.path contains "/blog" 
  and not http.request.uri.path contains "/images")
```
