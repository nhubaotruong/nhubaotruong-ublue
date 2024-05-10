#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

fedora_version=$(rpm -E %fedora)

wget "https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$fedora_version/ublue-os-staging-fedora-$fedora_version.repo" -O "/etc/yum.repos.d/ublue-os-staging-fedora-$fedora_version.repo"
rpm-ostree override replace \
    --experimental \
    --freeze \
    --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    mutter \
    mutter-common
