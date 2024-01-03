#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# fedora_version=$(rpm -E %fedora)
# wget -O "/etc/yum.repos.d/_copr_secureblue-hardened_malloc.repo" "https://copr.fedorainfracloud.org/coprs/secureblue/hardened_malloc/repo/fedora-$fedora_version/secureblue-hardened_malloc-fedora-$fedora_version.repo"

# rpm-ostree install hardened_malloc

gitlab_link="$(curl -L "https://gitlab.com/divested/rpm-hardened_malloc/-/jobs/artifacts/master/browse/x86_64?job=build_rpm" | grep "\.rpm" | grep -m 1 -oP '(?<=href=")(.+)(?=")' | sed 's/file/raw/g')"
rpm-ostree install "https://gitlab.com$gitlab_link?inline=false"

# Configure
echo "libhardened_malloc-memefficient.so" >>/usr/etc/ld.so.preload

cp -r /etc/profile.d /usr/etc/

mkdir -p /usr/lib/systemd/system/upower.service.d
cat <<EOF >>/usr/lib/systemd/system/upower.service.d/namespaces.conf
[Service]
# Namespaces
PrivateUsers=no
RestrictNamespaces=no
EOF

cat <<EOF >>/usr/share/ublue-os/just/60-custom.just
harden-flatpak:
    flatpak override --user --filesystem=host-os:ro --env=LD_PRELOAD=/var/run/host/usr/lib64/libhardened_malloc-memefficient.so
EOF
