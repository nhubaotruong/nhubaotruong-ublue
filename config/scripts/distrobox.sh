#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

alias cd='cd_func'

cd_func() {
    if [ $# -eq 0 ]; then
        builtin cd /tmp
    else
        builtin cd "$@"
    fi
}
curl -Ls https://raw.githubusercontent.com/89luca89/distrobox/main/install | sh -s -- --prefix /usr
