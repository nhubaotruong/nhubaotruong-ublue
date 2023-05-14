#!/usr/bin/env bash

set -oeux pipefail

curl -L https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm
curl -L "$(curl -L "https://www.expressvpn.com/latest#linux" | grep "Fedora 64-bit" | grep -m 1 -oP '(?<=value=")(.+)(?=")')" -o /tmp/expressvpn.rpm
