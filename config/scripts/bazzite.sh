#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

wget https://raw.githubusercontent.com/scaronni/steam-proton-mf-wmv/master/installcab.py -O /usr/bin/installcab
chmod +x /usr/bin/installcab
wget https://github.com/scaronni/steam-proton-mf-wmv/blob/master/install-mf-wmv.sh -O /usr/bin/install-mf-wmv
chmod +x /usr/bin/install-mf-wmv
sed -i 's@python3 installcab.py@/usr/bin/installcab@g' /usr/bin/install-mf-wmv
wget https://raw.githubusercontent.com/jlu5/icoextract/master/exe-thumbnailer.thumbnailer -O /usr/share/thumbnailers/exe-thumbnailer.thumbnailer
wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/11114e4ff791eb2c385814c2fcbac6a83f144f35/files/usr/lib/systemd/system/btrfs-dedup@.service -O /usr/lib/systemd/system/btrfs-dedup@.service
wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/11114e4ff791eb2c385814c2fcbac6a83f144f35/files/usr/lib/systemd/system/btrfs-dedup@.timer -O /usr/lib/systemd/system/btrfs-dedup@.timer

rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
    mesa-filesystem \
    mesa-dri-drivers \
    mesa-libEGL \
    mesa-libEGL-devel \
    mesa-libgbm \
    mesa-libGL \
    mesa-libglapi \
    mesa-vulkan-drivers \
    mesa-libOSMesa \
    bluez \
    bluez-cups \
    bluez-libs \
    bluez-obexd
