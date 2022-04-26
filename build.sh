#!/usr/bin/env bash
CDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
build_dir=$CDIR/build

while getopts A:K:q option
do
  case "${option}"
  in
    q) QUIET=1;;
    A) ARCH=${OPTARG};;
    K) KERNEL=${OPTARG};;
  esac
done

cd $CDIR
rm -rf $build_dir && mkdir -p $build_dir

for f in *prerun.sh home
do
    cp -r $CDIR/$f $build_dir/
done

if [ -x "$(command -v pip)" ]; then

  PYTHONUSERBASE=$build_dir/home/.local pip install --user -I -r pip-requirements.txt
  
  # Fix python shebang
  pypath=`readlink -f $(which python)`
  if [ -d "$build_dir/home/.local/bin" ]; then
    echo 'Fix PyPi packages shebang'
    sed -i '1s|#!'$pypath'|#!/usr/bin/env python|' $build_dir/home/.local/bin/*
  fi
  
else
  echo 'Skip pip packages installation: pip not found.'
fi

for f in *-tool.sh; do
  required_vars=(tool_github_repo tool_arch tool_version install_tool)
  for required_var in "${required_vars[@]}"; do
    unset "$required_var"
  done

  tool_name="${f%-tool.sh}"
  echo "Attempting to install $tool_name..."

  # Import tool definition and verify that it defined the correct vars
  source "$f"
  for required_var in "${required_vars[@]}"; do
    if [ "$(type -t "$required_var")" == "function" ] || [ -n "${!required_var}" ]; then
      continue
    fi
    echo "Required var $required_var not found in file $f"
    exit 1
  done

  release_url="https://api.github.com/repos/${tool_github_repo}/releases/${tool_version}"
  regex_before='https.*'
  regex_after='[^"]*'
  download_url=`curl -s "$release_url" | grep "browser_download_url" | grep -wo "${regex_before}${tool_arch}${regex_after}" | head -n 1`
  output_filename=`basename "$download_url"`
  echo "Downloading $download_url to $build_dir/$output_filename..."
  curl -Ls "$download_url" -o "$build_dir/$output_filename"
  mkdir -p "$build_dir/home/.local/bin"
  echo "Installing $tool_name..."
  install_tool "$build_dir/$output_filename" "$build_dir/home/.local/bin"
  rm -f "$build_dir/$output_filename"
done
