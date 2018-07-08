# Cride

A light Crystal IDE

![screenshot](https://i.imgur.com/UCSsnDz.png)

## Features

* Light, fast and easy to use
* Customizable
* Modular (different front-ends can share same resources)
* Colors
* Read from the stdin

## [CLI](https://github.com/j8r/clicr) usage

You have to build Cride (see the **Development** section below).

Open a file:

`./cride README.md`

## Development

Install project dependencies

`shards install`

Generate bindings:

`./gen-bindings.sh`

Build Cride:

`crystal build src/cride`

## License

Copyright (c) 2018 Julien Reichardt - ISC License
