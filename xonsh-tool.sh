#!/usr/bin/env bash

tool_github_repo="xonsh/xonsh"
tool_arch="x86_64"
tool_version="latest"

install_tool() {
  local downloaded_file="$1"
  local output_dir="$2"
  if [ -f "$downloaded_file" ]; then
    chmod a+x "$downloaded_file"
    (cd "$output_dir"; "$downloaded_file" --appimage-extract)
    mv "$output_dir/squashfs-root" "$output_dir/squashfs-xonsh"
    ln -s squashfs-xonsh/usr/bin/xonsh "$output_dir/xonsh"
    ln -s squashfs-xonsh/usr/bin/python "$output_dir/xonsh-python"
    ln -s squashfs-xonsh/usr/bin/pip "$output_dir/xonsh-pip"
  else
    echo "Couldn't find downloaded xonsh appimage at $downloaded_file!"
    exit 1
  fi
}
