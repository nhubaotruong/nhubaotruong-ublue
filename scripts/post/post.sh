#!/usr/bin/env bash

set -oeux pipefail

rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:calcastor:gnome-patched mutter

systemctl disable \
    systemd-timesyncd

systemctl enable \
    docker.socket \
    tlp \
    supergfxd \
    chronyd \
    tailscaled \
    dconf-update

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

nerd_fonts=(
    "Meslo"
    "FiraCode"
)
nerd_fonts_version="$(curl -L https://github.com/ryanoasis/nerd-fonts/releases/latest | grep '<h1' | grep -m 1 -oP '(?<=>)(.+)(?=</h1>)')"

for font in "${nerd_fonts[@]}"; do
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/$nerd_fonts_version/$font.tar.xz" -o "/tmp/$font.tar.xz"
    tar -xvf "/tmp/$font.tar.xz" -C /usr/share/fonts/ --one-top-level
    chown -R root: "/usr/share/fonts/$font"
    chmod 644 "/usr/share/fonts/$font"/*
    restorecon -vFr "/usr/share/fonts/$font"
done

fc-cache -f

# awscli
curl -L "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/tmp/awscliv2.zip"
unzip /tmp/awscliv2.zip
/tmp/aws/install -i /usr/share/aws-cli -b /usr/bin

# kubectl
curl -L "https://dl.k8s.io/release/$(curl -L https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" -o /usr/bin/kubectl
chmod +x /usr/bin/kubectl
