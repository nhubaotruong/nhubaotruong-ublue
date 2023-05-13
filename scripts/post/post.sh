#!/usr/bin/env bash

set -oeux pipefail

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

systemctl disable \
    systemd-timesyncd

systemctl enable \
    docker.socket \
    tlp \
    supergfxd \
    chronyd

systemctl mask nvidia-powerd

# Font config
ln -sf /etc/fonts/conf.avail/75-joypixels.conf /etc/fonts/conf.d/
ln -sf /etc/fonts/conf.avail/99-ms-fonts.conf /etc/fonts/conf.d/

# Microsoft Fonts
curl -L http://archlinuxgr.tiven.org/archlinux/x86_64/ttf-ms-win11-auto-10.0.22621.525-1-any.pkg.tar.zst -o /tmp/ttf-ms-win11-auto.pkg.tar.zst
tar --use-compress-program=unzstd -xzvf /tmp/ttf-ms-win11-auto.pkg.tar.zst -C /

# JoyPixels
curl -L https://archive.archlinux.org/packages/t/ttf-joypixels/ttf-joypixels-7.0.0-1-any.pkg.tar.zst -o /tmp/ttf-joypixels.pkg.tar.zst
tar --use-compress-program=unzstd -xzvf /tmp/ttf-joypixels.pkg.tar.zst -C /

# Nerd Fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Meslo.zip -o /tmp/Meslo.zip
unzip /tmp/Meslo.zip -d /tmp/Meslo
mkdir -p /usr/share/fonts/Meslo
cp /tmp/Meslo/*.ttf /usr/share/fonts/Meslo/

curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip -o /tmp/FiraCode.zip
unzip /tmp/FiraCode.zip -d /tmp/FiraCode
mkdir -p /usr/share/fonts/FiraCode
cp /tmp/FiraCode/*.ttf /usr/share/fonts/FiraCode/

