#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

curl -sSLf https://git.io/papirus-icon-theme-install | sh
