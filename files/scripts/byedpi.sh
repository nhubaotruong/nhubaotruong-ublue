#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

git clone https://github.com/hufrea/byedpi.git /tmp/byedpi

cd /tmp/byedpi

make

make PREFIX=/usr install

cp -v dist/linux/byedpi.service /usr/lib/systemd/system/
cp -v dist/linux/byedpi.conf /etc/

systemctl enable byedpi.service
