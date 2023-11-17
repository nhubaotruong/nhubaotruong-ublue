#!/usr/bin/env bash
set -oue pipefail

RELEASE=$(curl -sSLf "https://api.github.com/repos/dmitry-s93/MControlCenter/releases/latest")

url=$(echo "$RELEASE" | yq '.assets[] | select(.name == "*.tar.gz") | .url')
curl -sSLf "$url" -H 'Accept: application/octet-stream' | tar -xz -C /tmp/ --one-top-level=/tmp/mcontrolcenter
chmod -R +x /tmp/mcontrolcenter

# Find and run install.sh dynamically in /tmp/mcontrolcenter/whatever/install.sh without violating shellcheck SC2044
# This is because the directory name changes with each release.
find /tmp/mcontrolcenter -type f -name install.sh -exec {} \;
