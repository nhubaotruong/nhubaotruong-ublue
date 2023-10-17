#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

RELEASE=$(curl -Ls "https://api.github.com/repos/Alex313031/thorium/releases/latest")
url=$(echo "$RELEASE" | yq eval '.assets[] | select(.name | test("rpm$")) | .browser_download_url')

curl -L "$url" -o "/tmp/thorium.rpm"

rpm-ostree install /tmp/thorium.rpm
