#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Kernel
fedora_version="$(rpm -E %fedora)"
curl -sSLf "https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$fedora_version/bieszczaders-kernel-cachyos-fedora-$fedora_version.repo" \
    -o /etc/yum.repos.d/bieszczaders-kernel-cachyos.repo

# curl -sSLf "https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$((fedora_version - 1))/bieszczaders-kernel-cachyos-addons-fedora-$((fedora_version - 1)).repo" \
#     -o /etc/yum.repos.d/bieszczaders-kernel-cachyos-addons.repo

wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm -O \
    /tmp/surface-kernel.rpm
rpm-ostree cliwrap install-to-root /
rpm-ostree override replace /tmp/surface-kernel.rpm \
    --remove kernel-core \
    --remove kernel-modules \
    --remove kernel-modules-core \
    --remove kernel-modules-extra \
    --install kernel-cachyos \
    --install kernel-cachyos-core \
    --install kernel-cachyos-devel \
    --install kernel-cachyos-devel-matched \
    --install kernel-cachyos-headers \
    --install kernel-cachyos-modules

# rpm-ostree install libcap-ng-devel procps-ng-devel uksmd

KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

# Nvidia
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
akmods --force --kernels "${KERNEL}" --kmod nvidia

# v4l2loopback
rpm-ostree install akmod-v4l2loopback
akmods --force --kernels "${KERNEL}" --kmod v4l2loopback

systemctl enable uksmd.service
