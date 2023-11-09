#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Kernel
fedora_version="$(rpm -E %fedora)"
curl -sSLf "https://copr.fedorainfracloud.org/coprs/bieszczaders/kernel-cachyos/repo/fedora-$fedora_version/bieszczaders-kernel-cachyos-fedora-$fedora_version.repo" \
    -o /etc/yum.repos.d/bieszczaders-kernel-cachyos.repo

rpm-ostree override remove kernel kernel-core kernel-modules kernel-modules-core kernel-modules-extra --install kernel-cachyos

KERNEL="$(rpm -q kernel --queryformat '%{VERSION}-%{RELEASE}.%{ARCH}')"

# Nvidia
rpm-ostree install akmod-nvidia xorg-x11-drv-nvidia xorg-x11-drv-nvidia-cuda
akmods --force --kernels "${KERNEL}" --kmod nvidia

# v4l2loopback
rpm-ostree install akmod-v4l2loopback
akmods --force --kernels "${KERNEL}" --kmod v4l2loopback
