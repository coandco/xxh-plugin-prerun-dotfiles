#!/bin/bash

if [ ! -d ~/.local/bin/xonsh-files ] && [ -x ~/.local/bin/xonsh-appimage ]; then
  cd ~/.local/bin
  # This is noisy, so we want to suppress the output
  ./xonsh-appimage --appimage-extract > /dev/null
  mv squashfs-root xonsh-files
  ln -s xonsh-files/usr/bin/xonsh xonsh
  ln -s xonsh-files/usr/bin/python xonsh-python
  ln -s xonsh-files/usr/bin/pip xonsh-pip
fi
