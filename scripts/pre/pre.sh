#!/usr/bin/env bash

set -oeux pipefail

curl -Ls "$(curl -Ls "https://www.expressvpn.com/latest#linux" | grep "Fedora 64-bit" | grep -m 1 -oP '(?<=value=")(.+)(?=")')" -o /tmp/expressvpn.rpm
