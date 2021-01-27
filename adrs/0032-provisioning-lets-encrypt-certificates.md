# 0032 Provisioning lets encrypt

Date: 31-08-2020

## Status

Accepted

## Context

Sometimes we need certificates especially for TLS.

### Criteria

* Can sign certificates as a root authority for our domain
* Certificates automatically updated.

### Considered Options

1. Kubernetes cert manager https://cert-manager.io/ using lets encrpt as an authority
2. Do it by hand

## Decision

We decided to use pulumi to install cert manager connected to lets encrypt on our cluster.

Example pulumi code

```typescript
export function installCertManager(namespace: k8s.core.v1.Namespace) {
    
    const certManager = new k8s.helm.v3.Chart(
        "cert-manager",
        {
            chart: "cert-manager",
            version: "v1.1.0",
            fetchOpts: {
                repo: 'https://charts.jetstack.io',
            },
            namespace: namespace.metadata.name,
            values: {
                extraArgs: [
                    "--dns01-recursive-nameservers-only",
                    "--dns01-recursive-nameservers=1.1.1.1:53,1.0.0.1:53"
                ],
                installCRDs: "true"
            }
        }
    )
}
```

## Consequences

* The helm install repeatedly failed. Maybe due to https://github.com/jetstack/cert-manager/issues/3062
* We had to upgrade AKS. Your Kubernetes server must be at or later than version 1.16. To check the version, enter kubectl version. 
