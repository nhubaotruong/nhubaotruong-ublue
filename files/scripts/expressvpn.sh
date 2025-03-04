#!/usr/bin/env bash
set -oue pipefail

# Create temporary user for installation
temp_user="expressvpn_installer"
useradd -m -r -s /bin/bash "$temp_user"

# Download and install as temporary user
download_url=$(curl -sSLf https://www.expressvpn.com/latest\#linux | grep -oP '(?<=href=")(https://www.expressvpn.works/clients/linux/expressvpn-linux-universal-.+.run)(?=")')
curl -sSLf "$download_url" -o /tmp/expressvpn.run
chmod +x /tmp/expressvpn.run

# Run installer as temporary user
runuser -l "$temp_user" -c "/tmp/expressvpn.run --quiet --accept --nox11"

# Cleanup
rm -f /tmp/expressvpn.run
userdel -r "$temp_user"
