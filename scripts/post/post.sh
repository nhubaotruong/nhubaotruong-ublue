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
tar --use-compress-program=unzstd -xvf /tmp/ttf-ms-win11-auto.pkg.tar.zst -C /
chown -R root: /usr/share/fonts/TTF
chmod 644 /usr/share/fonts/TTF/*
restorecon -vFr /usr/share/fonts/TTF

# JoyPixels
curl -L https://archive.archlinux.org/packages/t/ttf-joypixels/ttf-joypixels-7.0.0-1-any.pkg.tar.zst -o /tmp/ttf-joypixels.pkg.tar.zst
tar --use-compress-program=unzstd -xvf /tmp/ttf-joypixels.pkg.tar.zst -C /
chown -R root: /usr/share/fonts/joypixels
chmod 644 /usr/share/fonts/joypixels/*
restorecon -vFr /usr/share/fonts/joypixels

# Nerd Fonts
curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/Meslo.zip -o /tmp/Meslo.zip
unzip /tmp/Meslo.zip -d /tmp/Meslo
mkdir -p /usr/share/fonts/Meslo
cp /tmp/Meslo/*.ttf /usr/share/fonts/Meslo/
chown -R root: /usr/share/fonts/Meslo
chmod 644 /usr/share/fonts/Meslo/*
restorecon -vFr /usr/share/fonts/Meslo

curl -L https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.0/FiraCode.zip -o /tmp/FiraCode.zip
unzip /tmp/FiraCode.zip -d /tmp/FiraCode
mkdir -p /usr/share/fonts/FiraCode
cp /tmp/FiraCode/*.ttf /usr/share/fonts/FiraCode/
chown -R root: /usr/share/fonts/FiraCode
chmod 644 /usr/share/fonts/FiraCode/*
restorecon -vFr /usr/share/fonts/FiraCode

fc-cache -f