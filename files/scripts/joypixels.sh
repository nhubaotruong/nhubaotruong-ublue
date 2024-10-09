#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

curl -sSLf https://archive.archlinux.org/packages/t/ttf-joypixels/ttf-joypixels-8.0.0-2-any.pkg.tar.zst | tar --use-compress-program=unzstd -x -C /

chown -R root: /usr/share/fonts/joypixels
chmod 644 /usr/share/fonts/joypixels/*
restorecon -vFr /usr/share/fonts/joypixels

fc-cache -rs