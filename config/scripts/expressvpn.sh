#!/usr/bin/env bash
set -oue pipefail

# Setup repo
cat <<EOF >/etc/yum.repos.d/expressvpn.repo
[expressvpn]
name=Expressvpn
baseurl=https://repo.expressvpn.com/public/rpm/any-distro/any-version/\$basearch
gpgkey=https://www.expressvpn.com/expressvpn_release_public_key_0xAFF2A1415F6A3A38.asc
gpgcheck=1
repo_gpgcheck=1
enabled=1
type=rpm-md
EOF

rpm --import https://www.expressvpn.com/expressvpn_release_public_key_0xAFF2A1415F6A3A38.asc

rpm-ostree install expressvpn
