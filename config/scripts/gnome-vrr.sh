#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

fedora_version=$(rpm -E %fedora)
wget -O "/etc/yum.repos.d/_copr_kylegospo-gnome-vrr.repo" "https://copr.fedorainfracloud.org/coprs/kylegospo/gnome-vrr/repo/fedora-$fedora_version/kylegospo-gnome-vrr-fedora-$fedora_version.repo"

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:kylegospo:gnome-vrr mutter mutter-common gnome-control-center gnome-control-center-filesystem xorg-x11-server-Xwayland wayland-protocols
