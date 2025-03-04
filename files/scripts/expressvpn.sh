#!/usr/bin/env bash
set -oue pipefail

download_url=$(curl -sSLf https://www.expressvpn.com/latest\#linux | grep -oP '(?<=href=")(https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-.+.run)(?=")')

curl -sSLf "$download_url" -o /tmp/expressvpn.run

chmod +x /tmp/expressvpn.run

/tmp/expressvpn.run --quiet --accept --nox11
