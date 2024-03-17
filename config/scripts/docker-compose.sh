#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

RELEASE=$(curl -sSLf "https://api.github.com/repos/docker/compose/releases/latest")

url=$(echo "$RELEASE" | yq ".assets[] | select(.name == \"*linux-$(uname -m)\") | .url")

curl -sSLf "$url" -H 'Accept: application/octet-stream' -o /usr/bin/docker-compose
chmod +x /usr/bin/docker-compose

curl -sSLf "https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker" -O /usr/share/zsh/site-functions/
curl -sSLf "https://github.com/docker/cli/raw/master/contrib/completion/bash/docker" -O /usr/share/bash-completion/completions/

systemctl --global -f enable podman.socket
