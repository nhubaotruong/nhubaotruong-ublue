#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail
wget -qO- https://git.io/papirus-icon-theme-install | sh
