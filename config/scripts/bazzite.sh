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

# fedora_version=$(rpm -E %fedora)

# wget "https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-$fedora_version/kylegospo-bazzite-multilib-fedora-$fedora_version.repo?arch=x86_64" -O /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo
# wget "https://copr.fedorainfracloud.org/coprs/sentry/switcheroo-control_discrete/repo/fedora-$fedora_version/sentry-switcheroo-control_discrete-fedora-$fedora_version.repo" -O /etc/yum.repos.d/_copr_sentry-switcheroo-control_discrete.repo
# rpm-ostree override remove \
#     mesa-va-drivers-freeworld
# rpm-ostree override replace \
#     --experimental \
#     --from repo=copr:copr.fedorainfracloud.org:kylegospo:bazzite-multilib \
#     mesa-filesystem \
#     mesa-libxatracker \
#     mesa-libglapi \
#     mesa-dri-drivers \
#     mesa-libgbm \
#     mesa-libEGL \
#     mesa-vulkan-drivers \
#     mesa-libGL \
#     pipewire \
#     pipewire-alsa \
#     pipewire-gstreamer \
#     pipewire-jack-audio-connection-kit \
#     pipewire-jack-audio-connection-kit-libs \
#     pipewire-libs \
#     pipewire-pulseaudio \
#     pipewire-utils
# rpm-ostree install \
#     mesa-va-drivers-freeworld \
#     mesa-vdpau-drivers-freeworld.x86_64
# rpm-ostree override replace \
#     --experimental \
#     --from repo=copr:copr.fedorainfracloud.org:sentry:switcheroo-control_discrete \
#     switcheroo-control

# Install Explicit Sync Patches
# wget "https://copr.fedorainfracloud.org/coprs/gloriouseggroll/nvidia-explicit-sync/repo/fedora-$fedora_version/gloriouseggroll-nvidia-explicit-sync-fedora-$fedora_version.repo?arch=x86_64" -O /etc/yum.repos.d/_copr_gloriouseggroll-nvidia-explicit-sync.repo
# rpm-ostree override replace \
#     --experimental \
#     --from repo=copr:copr.fedorainfracloud.org:gloriouseggroll:nvidia-explicit-sync \
#     xorg-x11-server-Xwayland
# rpm-ostree override replace \
#     --experimental \
#     --from repo=copr:copr.fedorainfracloud.org:gloriouseggroll:nvidia-explicit-sync \
#     egl-wayland ||
#     true
