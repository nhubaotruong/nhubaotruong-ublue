#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

git clone https://github.com/galenguyer/nano-syntax-highlighting.git /usr/share/nano-syntax-highlighting
