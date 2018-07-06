#!/bin/sh

mkdir -p src/libc
lib/autobind/bin/autobind -I/usr/include/asm-generic termios.h > src/libc/termios.cr
lib/autobind/bin/autobind -I/usr/include/asm-generic ioctls.h > src/libc/ioctls.cr
