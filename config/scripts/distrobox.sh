#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

mkdir -p /root
curl -Ls https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --next --prefix /usr
