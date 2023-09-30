#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

RELEASE=$(curl -Ls "https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest")

url=$(echo "$RELEASE" | yq '.assets[] | select(.name == "dnsproxy-linux-amd64*") | .url')
curl -L "$url" -H 'Accept: application/octet-stream' -o "/tmp/dnsproxy.tar.gz"
tar -xvf "/tmp/dnsproxy.tar.gz" -C /tmp/ --one-top-level
install -Dm755 /tmp/dnsproxy/linux-amd64/dnsproxy /usr/bin/dnsproxy
install -Dm644 /tmp/dnsproxy/linux-amd64/LICENSE /usr/share/license/dnsproxy/LICENSE
install -Dm644 /tmp/dnsproxy/linux-amd64/README.md /usr/share/doc/dnsproxy/README.md
