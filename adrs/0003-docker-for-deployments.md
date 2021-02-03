# 0003. Docker Containers for Deployment Artifacts

Date: 31-08-2020

## Status

Accepted

## Context

Containers should be the outpout of our CI-CD pipeline.

Containers isolate a single application and its dependencies and all of the external software libraries the app requires to run both from the underlying operating system and from other containers. All of the containerized apps share a single, common operating system (either Linux or Windows), but they are compartmentalized from one another and from the system at large. 

We get more options at deployment time. Whether that be Kuberenetes, a PaaS service such as Azure Web Apps (or even Heroku) or our local development environments.

### Criteria

* Isolate parts of our solution from each other.
* Enable numerous deployment scenarios.

### Considered Options

## Decision

Docker desktop for development machines.
The a choice of deployment options.

## Consequences

