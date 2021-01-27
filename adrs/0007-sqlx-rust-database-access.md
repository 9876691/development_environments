# 0007 SQLx for accessing postgres

Date: 08-09-2020

## Status

Pending

## Context

When interacting with a relational database it is fairly easy to make mistakes - we might, for example,

* have a typo in the name of a column or a table mentioned in our query;
* try to perform operations that are rejected by the database engine (e.g. summing a string and a number or joining two tables on the wrong column);
* expect to have a certain field in the returned data that is actually not there.

The key question is: when do we realise we made a mistake?

In most programming languages, it will be at runtime: when we try to execute our query the database will reject it and we will get an error or an exception. This is what happens when using tokio-postgres.

diesel and sqlx try to speed up the feedback cycle by detecting at compile-time most of these mistakes.
diesel leverages its CLI to generate a representation of the database schema as Rust code, which is then used to check assumptions on all of your queries.
sqlx, instead, uses procedural macros to connect to a database at compile-time and check if the provided query is indeed sound4.

### Criteria

* Compile time safety
* Async support
* Prefereably a SQL interface

### Considered Options

1. sqlx
2. Diesel

## Decision

we will use sqlx: its asynchronous support simplifies the integration with tonic without forcing us to compromise on compile-time guarantees. It also limits the API surface that we have to cover and become proficient with thanks to its usage of raw SQL for queries.

## Consequences
