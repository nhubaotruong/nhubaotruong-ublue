#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail
export EXTRA_THEMES="Papirus-Dark"
wget -qO- https://git.io/papirus-icon-theme-install | sh
fc-cache -rs
