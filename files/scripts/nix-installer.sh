#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

RELEASE=$(curl -sSLf "https://api.github.com/repos/DeterminateSystems/nix-installer/releases/latest")

url=$(echo "$RELEASE" | yq '.assets[] | select(.name == "nix-installer-x86_64-linux*") | .url')
curl -sSLf "$url" -H 'Accept: application/octet-stream' -o /usr/bin/nix-installer
chmod +x /usr/bin/nix-installer
