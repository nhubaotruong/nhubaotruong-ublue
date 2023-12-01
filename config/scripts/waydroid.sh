#!/usr/bin/env bash
set -oue pipefail

sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' /usr/lib/waydroid/data/scripts/waydroid-net.sh

systemctl disable waydroid-container.service
sed -i 's@Exec=waydroid first-launch@Exec=/usr/bin/waydroid-launcher first-launch\nX-Steam-Library-Capsule=/usr/share/applications/Waydroid/capsule.png\nX-Steam-Library-Hero=/usr/share/applications/Waydroid/hero.png\nX-Steam-Library-Logo=/usr/share/applications/Waydroid/logo.png\nX-Steam-Library-StoreCapsule=/usr/share/applications/Waydroid/store-logo.png\nX-Steam-Controller-Template=Desktop@g' /usr/share/applications/Waydroid.desktop
# rm /usr/share/wayland-sessions/weston.desktop
wget https://raw.githubusercontent.com/Quackdoc/waydroid-scripts/main/waydroid-choose-gpu.sh -O /usr/bin/waydroid-choose-gpu
chmod +x /usr/bin/waydroid-choose-gpu

# Temp fix until fedora updates waydroid
rm -rf /usr/lib/waydroid/tools/helpers/net.py

cat <<EOF >/usr/lib/waydroid/tools/helpers/net.py
# Copyright 2023 Maximilian Wende
# SPDX-License-Identifier: GPL-3.0-or-later
from shutil import which
import tools.helpers.run
import logging
import re

def adb_connect(args):
    """
    Creates an android debugging connection from the host system to the
    Waydroid device, if ADB is found on the host system and the device
    has booted.
    """
    # Check if adb exists on the system.
    if not which("adb"):
        return

    # Start and 'warm up' the adb server
    tools.helpers.run.user(args, ["adb", "start-server"])

    ip = get_device_ip_address()
    if not ip:
        return

    tools.helpers.run.user(args, ["adb", "connect", ip])
    logging.info("Established ADB connection to Waydroid device at {}.".format(ip))

def get_device_ip_address():
    # The IP address is queried from the DHCP lease file.
    lease_file = "/var/lib/misc/dnsmasq.waydroid0.leases"

    try:
        with open(lease_file) as f:
            return re.search(r"(\d{1,3}\.){3}\d{1,3}\s", f.read()).group().strip()
    except:
        pass
EOF
