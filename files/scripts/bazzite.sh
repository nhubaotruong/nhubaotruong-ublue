#!/usr/bin/env bash
set -oue pipefail

sed -i 's|#default.clock.allowed-rates = \[ 48000 \]|default.clock.allowed-rates = [ 44100 48000 ]|' /usr/share/pipewire/pipewire.conf
sed -i 's/balanced=balanced$/balanced=balanced-bazzite/' /etc/tuned/ppd.conf
sed -i 's/performance=throughput-performance$/performance=throughput-performance-bazzite/' /etc/tuned/ppd.conf
sed -i 's/balanced=balanced-battery$/balanced=balanced-battery-bazzite/' /etc/tuned/ppd.conf

mkdir -p /usr/share/gamescope-session-plus/
curl --retry 3 -Lo /usr/share/gamescope-session-plus/bootstrap_steam.tar.gz https://large-package-sources.nobaraproject.org/bootstrap_steam.tar.gz 
mkdir -p /usr/share/sdl/
curl "https://raw.githubusercontent.com/mdqinc/SDL_GameControllerDB/refs/heads/master/gamecontrollerdb.txt" --retry 3 -Lo /usr/share/sdl/gamecontrollerdb.txt

curl "https://raw.githubusercontent.com/bazzite-org/steam-proton-mf-wmv/master/installcab.py" --retry 3 -Lo /usr/bin/installcab 
chmod +x /usr/bin/installcab

curl "https://raw.githubusercontent.com/bazzite-org/steam-proton-mf-wmv/refs/heads/master/install-mf-wmv.sh" --retry 3 -Lo /usr/bin/install-mf-wmv 
chmod +x /usr/bin/install-mf-wmv

tar --no-same-owner --no-same-permissions --no-overwrite-dir -xvzf /tmp/ls-iommu.tar.gz -C /tmp/ls-iommu 
rm -f /tmp/ls-iommu.tar.gz 
cp -r /tmp/ls-iommu/ls-iommu /usr/bin/

mkdir -p /usr/lib/extest/
curl "$(curl https://api.github.com/repos/bazzite-org/extest/releases/latest | jq -r '.assets[] | select(.name| test(".*so$")).browser_download_url')" --retry 3 -Lo /usr/lib/extest/libextest.so

cp --no-dereference --preserve=links /usr/lib/libdrm.so.2 /usr/lib/libdrm.so 
cp --no-dereference --preserve=links /usr/lib64/libdrm.so.2 /usr/lib64/libdrm.so 
sed -i 's@/usr/bin/steam@/usr/bin/bazzite-steam@g' /usr/share/applications/steam.

curl "https://github.com/HikariKnight/ScopeBuddy/archive/refs/tags/$(curl https://api.github.com/repos/HikariKnight/scopebuddy/releases/latest | jq -r '.tag_name').tar.gz" --retry 3 -Lo /tmp/scopebuddy.tar.gz 
mkdir -p /tmp/scopebuddy 
tar --no-same-owner --no-same-permissions --no-overwrite-dir -xvzf /tmp/scopebuddy.tar.gz -C /tmp/scopebuddy 
rm -f /tmp/scopebuddy.tar.gz 
cp -r /tmp/scopebuddy/ScopeBuddy-*/bin/* /usr/bin/