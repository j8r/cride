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

For now build Cride (see the **Development** section below):

`crystal build src/cride.cr`

Open a file:

`./cride README.md`

## Development

First you need to have [Termbox installed](https://github.com/nsf/termbox#installation).

`sudo sh install-termbox.sh`

Install project dependencies

`shards install`

Build Cride:

`crystal build src/cride`

## License

Copyright (c) 2018 Julien Reichardt - ISC License
