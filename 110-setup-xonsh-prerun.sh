#!/bin/bash

if [ ! -d ~/.local/bin/xonsh-files ] && [ -x ~/.local/bin/xonsh-appimage ]; then
  cd ~/.local/bin
  ./xonsh-appimage --appimage-extract
  mv squashfs-root xonsh-files
  ln -s xonsh-files/usr/bin/xonsh xonsh
  ln -s xonsh-files/usr/bin/python xonsh-python
  ln -s xonsh-files/usr/bin/pip xonsh-pip
fi
