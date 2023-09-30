#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched mutter mutter-common xorg-x11-server-Xwayland
