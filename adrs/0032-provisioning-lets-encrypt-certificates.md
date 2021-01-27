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

* Cert manager requires that you can prove you own the domain. https://cert-manager.io/docs/configuration/acme/dns01/#setting-nameservers-for-dns01-self-check There's a way to do this using cludflare so we need a lowly provisioned API key to allow cert manager to a TXT files to our domain.
* The helm install repeatedly failed. Maybe due to https://github.com/jetstack/cert-manager/issues/3062
* We had to upgrade AKS. Your Kubernetes server must be at or later than version 1.16. To check the version, enter kubectl version. 

## References

* https://github.com/vitobotta/pulumi-kubernetes-deployments/blob/master/cert-manager/CertManager.ts
* https://github.com/lbrlabs/pulumi-cert-manager/blob/master/index.ts
* https://cert-manager.io/docs/
