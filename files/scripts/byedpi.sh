#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

git clone https://github.com/hufrea/byedpi.git /tmp/byedpi

cd /tmp/byedpi

git checkout "$(git describe --tags "$(git rev-list --tags --max-count=1)")"

make

make PREFIX=/usr install

cp -v dist/linux/byedpi.service /usr/lib/systemd/system/
cp -v dist/linux/byedpi.conf /etc/

systemctl daemon-reload

systemctl enable byedpi
