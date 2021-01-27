# 0031 How can we defend against supply chain attacks.

Date: 01-09-2020

## Status

Pending

## Context

From source code to control to final delivery we are vulnerable to multiple supply side attacks.

1. Third party code via node.
1. Third party code via cargo.
1. The docker images we use.
1. Our source code repo.
1. The CI/CD pipeline.
1. Cloudflare could inject javascript.
1. Build scripts that we run, i.e. webpack

### Possible attacks

1.  Code injection into javascript libraries
1.  Code injection into rust libraries

### Criteria


## Mitigations

1. Run npm audit in CI/CD and fail if issues found.
1. webpack tree shaking, reduce amount of code.
1. Scan cargo deps.
1. Block access to network for any node stuff in the CI/CD piepline.
1. Block docker container from accessing anything over than what they need on the network.
1. Verify doker images
1. Scan dependenices for malware.
1. Scan docker images for malware.
1. Can we stop JS manipulating pages where we don't want it to? i.e. changing bitcoin addresses in the send page.


## Mitigations Complete

### Content Security Policy

We can lock down what JS is able to do on the front end. 

https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy

We adeded the foloowing restriction 

* `default-src 'self'` All JS/images/stylesheets to come from our domain.
* `connect-src 'none'` JS can't make any network outgoing connections https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/connect-src
* We have used style attributes enabled such as style-src-attr `'unsafe-hashes' 'sha256-uYE7yiXLITb9KhADRbppG9b65SnBsn/gGJJVlrYIpJ0='`