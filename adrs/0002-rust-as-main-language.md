# 2. Use rust as the main programming language

Date: 28-08-2020

## Status

Accepted

## Context

We need a programming language which is performant and type safe.

### Criteria

* High performance.
* Safe, minimise possibility of overflow errors etc.
* Additive types i.e. enums.
* Multi threaded. Ideally async/await to maximise CPU core usage.
* Generic Data Types
* List comprehensions. i.e. filter, map, flat_map
* Support for closures.
* No null. Instead Option or Result (Scala, Rust, Haskell)
* Higher order functions.
* Type inference
* Immutable by default.
* Support for pattern matching inclusing exhaustive matching.
* Possibility to use on embedded devices.
* Great build system

## Decision

We chose rust. https://www.rust-lang.org/

Rust is blazing fast and reliable with its rich type system and ownership model. It has a tough learning curve but is well worth the effort. Rust has been voted the most loved programming language in Stack Overflow's Developer Survey five years in a row. https://insights.stackoverflow.com/survey/2019/#technology-_-most-loved-dreaded-and-wanted-languages

* Go was discounted as it has no support for most of the required features especially around the type system. 
* Java was discounted due to it's inferior type system and support for null.
* Scala. Not great support for async/await. Language seems in flux. Build suystem is not great. Appears to be no-one to version lock dependencies.

## Consequences

There's an up front cognitive load on the developer to get familair with rust concepts. It should be possible to use rust in the front-end via webassembly. However we will move forward with typerscript for this purpose.