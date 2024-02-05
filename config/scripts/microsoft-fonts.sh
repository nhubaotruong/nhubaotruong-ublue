#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Microsoft Fonts
curl -sSLf http://archlinuxgr.tiven.org/archlinux/x86_64/ttf-ms-win11-auto-10.0.22631.2428-1-any.pkg.tar.zst | tar --use-compress-program=unzstd -x -C /

chown -R root: /usr/share/fonts/TTF
chmod 644 /usr/share/fonts/TTF/*
restorecon -vFr /usr/share/fonts/TTF

fc-cache -rs
