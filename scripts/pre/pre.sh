#!/usr/bin/env bash

set -oeux pipefail

curl -Ls https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm
# cat <<EOF >/etc/yum.repos.d/teamviewer.repo
# [teamviewer]
# name=TeamViewer - x86_64
# baseurl=https://linux.teamviewer.com/yum/stable/main/binary-x86_64/
# gpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc
# gpgcheck=1
# repo_gpgcheck=1
# enabled=1
# type=rpm-md
# EOF

curl -Ls "$(curl -Ls "https://www.expressvpn.com/latest#linux" | grep "Fedora 64-bit" | grep -m 1 -oP '(?<=value=")(.+)(?=")')" -o /tmp/expressvpn.rpm
