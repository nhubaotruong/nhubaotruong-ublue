#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

git clone https://github.com/hufrea/byedpi.git /tmp/byedpi

cd /tmp/byedpi

cp -v dist/linux/byedpi.service /usr/lib/systemd/system/
cp -v dist/linux/byedpi.conf /etc/

# Fetch the latest tags
git fetch --tags

# Get the latest tag
latest_tag=$(git describe --tags "$(git rev-list --tags --max-count=1)")

# Checkout the latest tag
git checkout "$latest_tag"

make

make PREFIX=/usr install

systemctl enable byedpi.service
