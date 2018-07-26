#!/bin/sh

mkdir -p src/libc
# GNU/Linux
if [ -d /usr/include/asm-generic ] ;then
  lib/autobind/bin/autobind -I/usr/include/asm-generic termios.h > src/libc/termios.cr
  lib/autobind/bin/autobind -I/usr/include/asm-generic ioctls.h > src/libc/ioctls.cr
else
# Alpine
  lib/autobind/bin/autobind -I/usr/include/bits ioctl.h > src/libc/ioctl.cr
fi
