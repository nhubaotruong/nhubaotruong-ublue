#!/usr/bin/env bash
set -oue pipefail

download_url=$(curl -L https://www.expressvpn.com/vn/latest\#linux | grep 'Fedora 64' | grep -m 1 -oP '(?<=value=")(.+)(?=")')

curl -L "$download_url" -o /tmp/expressvpn.rpm

rpm-ostree install /tmp/expressvpn.rpm
