#!/usr/bin/env bash
set -oue pipefail

RELEASE=$(curl -L https://www.expressvpn.com/vn/latest\#linux | grep 'Fedora 64')

download_url=$(echo "$RELEASE" | grep -m 1 -oP '(?<=value=")(.+)(?=")')

gpg_url=$(echo "$RELEASE" | grep -m 1 -oP '(?<=data-signature-uri=")(.+.asc)(?=")')

curl -L "$download_url" -o /tmp/expressvpn.rpm

curl -L "$gpg_url" -o /tmp/expressvpn.rpm.asc

(gpg --quick-generate-key "User Name" rsa2048)

gpg --keyserver hkp://keyserver.ubuntu.com --recv-keys 0xAFF2A1415F6A3A38

gpg --verify /tmp/expressvpn.rpm.asc

rpm-ostree install /tmp/expressvpn.rpm
