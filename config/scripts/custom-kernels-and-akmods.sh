#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Kernel
fedora_version="$(rpm -E %fedora)"
curl -sSLf "https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$fedora_version/bieszczaders-kernel-cachyos-fedora-$fedora_version.repo" \
    -o /etc/yum.repos.d/bieszczaders-kernel-cachyos.repo

# curl -sSLf "https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos-addons/repo/fedora-$((fedora_version - 1))/bieszczaders-kernel-cachyos-addons-fedora-$((fedora_version - 1)).repo" \
#     -o /etc/yum.repos.d/bieszczaders-kernel-cachyos-addons.repo

# wget https://github.com/linux-surface/linux-surface/releases/download/silverblue-20201215-1/kernel-20201215-1.x86_64.rpm -O \
#     /tmp/surface-kernel.rpm
rpm-ostree cliwrap install-to-root /
rpm-ostree override remove kernel-modules-core kernel-core kernel-modules kernel kernel-modules-extra kernel-devel --install kernel-cachyos

# rpm-ostree install libcap-ng-devel procps-ng-devel uksmd

KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

# Nvidia
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
akmods --force --kernels "${KERNEL}" --kmod nvidia

# v4l2loopback
rpm-ostree install akmod-v4l2loopback
akmods --force --kernels "${KERNEL}" --kmod v4l2loopback

systemctl enable uksmd.service
