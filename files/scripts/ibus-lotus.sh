#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

dnf5 -y install make go libX11-devel libXtst-devel gtk3-devel

git clone https://github.com/LotusInputEngine/ibus-lotus.git /tmp/ibus-lotus
cd /tmp/ibus-lotus
git fetch --tags
# Get the latest tag
latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
# Checkout the latest tag
git checkout "$latest_tag"
make install PREFIX=/usr