# Cride

[![Build Status](https://cloud.drone.io/api/badges/j8r/cride/status.svg)](https://cloud.drone.io/j8r/cride)
[![ISC](https://img.shields.io/badge/License-ISC-blue.svg?style=flat-square)](https://en.wikipedia.org/wiki/ISC_license)

A light Crystal IDE

![screenshot](https://i.imgur.com/UCSsnDz.png)

## Features

* Light, fast and easy to use
* Customizable
* Modular (different front-ends can share same resources)
* Colors
* Read from the stdin
* Advanced CTRL + Arrow keys traversing
* CTRL+D line duplication
* CTRL+K line emptying/deletion

## [CLI](https://github.com/j8r/clicr) usage

You have to build Cride (see the **Development** section below).

Open a file:

`./cride README.md`

## Development

Install project dependencies

`shards install`

Generate bindings with [crystal-autobind](https://github.com/j8r/crystal-autobind)

`./gen-bindings.sh`

Build Cride:

`shards build`

## Build with Docker

To build a statically-linked `cride` binary:

```sh
docker run -it --rm -v $PWD:/app -w /app jrei/crystal-alpine sh -c "\
apk add --update clang-dev
shards install
./gen-bindings.sh
shards build --static --release --no-debug
rm -r lib src/libc
chown 1000:1000 cride"
```

## License

Copyright (c) 2018-2019 Julien Reichardt - ISC License
