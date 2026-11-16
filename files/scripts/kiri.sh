#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

arch="$(rpm -E %_arch)"
version="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/libracoder/kiri/releases/latest | sed 's#.*/tag/v##')"
dnf5 -y install "https://download.runkiri.com/kiri-${version}-1.${arch}.rpm"
