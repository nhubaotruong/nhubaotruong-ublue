#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Microsoft Fonts
curl -sSLf https://archlinuxgr.tiven.org/archlinux/x86_64/ttf-ms-win11-auto-10.0.26100.1742-4-any.pkg.tar.zst | tar --use-compress-program=unzstd -x -C /

chown -R root: /usr/share/fonts/TTF
chmod 644 /usr/share/fonts/TTF/*
restorecon -vFr /usr/share/fonts/TTF

fc-cache -rs
