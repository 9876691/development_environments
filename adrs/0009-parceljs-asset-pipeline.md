# 0009 Asset Pipeline

Date: 15-09-2020

## Status

Accepted

## Context

We need an asset pipeline to concatenate and minify or compress TypeScript and CSS assets. Also to handle JS/Typescript dependencies via node.

### Criteria

* Support Typescript https://www.typescriptlang.org/
* Support for Sass https://sass-lang.com/
* [Optional] Compress images.
* Minimal configuration
* Detect changes and reload the browser. i.e. https://www.browsersync.io/

### Considered Options

1. Webpack - https://webpack.js.org/
2. Parcel - https://parceljs.org/


## Decision

We'll go with Parcel. I was able to get an example rust webassembly app up and running with browser reload, compiling and a proeduction build.

I've used webpack previously and never really got to grips with the configuration

## Consequences

I haven't got it working with image compression yet, and we still don't have a solution for cache busting.
