# 0014. Postgres
Date: 03-09-2020

## Status

Accepted

## Context

We need a database

### Criteria

* SQL - Relational
* Managed Service
* Managed backups
* Support for database migrations
* Privelaged based users, i.e. read only.

### Considered Options

1. Postgres

As most of the team had used postgres before it was a no-bariner to carry on. We have no particular performance requirements in our criteria so we didn't look at NoSQL databases.

## Decision

We chose managed postgres on digital ocean.

## Consequences

For each application we create a number of users with restrictions on roles.

For database migrations we need a user with full access, i.e. create tables etc.

For database backups a user with read only privelages is created.

In some cases the application can use an immutable user. i.e. A user that can Select, Insert but can't Update or Delete.