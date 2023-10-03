#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Microsoft Fonts
curl -L http://archlinuxgr.tiven.org/archlinux/x86_64/ttf-ms-win11-auto-10.0.22621.525-1-any.pkg.tar.zst -o /tmp/ttf-ms-win11-auto.pkg.tar.zst
tar --use-compress-program=unzstd -xvf /tmp/ttf-ms-win11-auto.pkg.tar.zst -C /

fc-cache -f
