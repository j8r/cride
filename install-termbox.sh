#!/bin/sh

cd /tmp
wget -qO- https://github.com/nsf/termbox/tarball/master | tar zxf -
cd nsf-termbox-*

#python3-dev
pip3 install cython
python3 setup.py install

./waf configure
./waf install --targets=termbox_static
