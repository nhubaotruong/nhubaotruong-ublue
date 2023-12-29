#!/usr/bin/env bash
set -oue pipefail

sed -i~ -E 's/=.\$\(command -v (nft|ip6?tables-legacy).*/=/g' /usr/lib/waydroid/data/scripts/waydroid-net.sh

systemctl disable waydroid-container.service
sed -i 's@Exec=waydroid first-launch@Exec=/usr/bin/waydroid-launcher first-launch\nX-Steam-Library-Capsule=/usr/share/applications/Waydroid/capsule.png\nX-Steam-Library-Hero=/usr/share/applications/Waydroid/hero.png\nX-Steam-Library-Logo=/usr/share/applications/Waydroid/logo.png\nX-Steam-Library-StoreCapsule=/usr/share/applications/Waydroid/store-logo.png\nX-Steam-Controller-Template=Desktop@g' /usr/share/applications/Waydroid.desktop
# rm /usr/share/wayland-sessions/weston.desktop
wget https://raw.githubusercontent.com/Quackdoc/waydroid-scripts/main/waydroid-choose-gpu.sh -O /usr/bin/waydroid-choose-gpu
chmod +x /usr/bin/waydroid-choose-gpu
