# 0003. Kubernetes and Docker

Date: 31-08-2020

## Status

Accepted

## Context

Docker containers allows us to package our app and dependencies. So it was decided early on this would be the best way to deploy the various apps in the project.

So we looked for tools to manage container orchestration. 

### Criteria

* Keep costs to a minimum.
* Deployable with [Pulumi 0004](0004-pulumi-infratructure-as-code.md).
* Crash resistant. i.e. if an App falls over it should get re-started.
* Ability to see logs.
* Keep vendor lock in to a minimum.
* Must be able to manage the API with envoy.
* Ability to create and run scheduled tasks.

### Considered Options

1. Five+ heroku applications and 5 databases.
1. Five+ Azure web apps.
1. Kubernetes on (Google, Azure, Amazon or Digital Ocean)

## Decision

We chose kubernetes on digital ocean.

DO is the cheapest option as we can deploy all apps together on their smallest plan. We have extensive kubernetes knowledge on the team.

Kubernetes give us very little vendor lock in.

## Consequences

There's an up front cognitive load on the developer to get familair with kubernetes concepts.

### Creating a docker credentials secret

1. Login to docker
1. cat /root/.docker/config.json | base64 -w 0
1. pulumi config set dockerHubCredentials VALUE_FROM_ABOVE --secret