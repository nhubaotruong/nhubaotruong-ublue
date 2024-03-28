#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sed '/cd$/d' | sh -s -- --prefix /usr
