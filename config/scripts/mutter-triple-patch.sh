#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Mutter Triple Patch
fedora_version="$(rpm -E %fedora)"
curl -sSLf "https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/repo/fedora-$fedora_version/trixieua-mutter-patched-fedora-$fedora_version.repo" -o /etc/yum.repos.d/trixieua-mutter-patched.repo
rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched mutter mutter-common gnome-shell xorg-x11-server-Xwayland
