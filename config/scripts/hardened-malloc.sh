#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

fedora_version=$(rpm -E %fedora)
wget -O "/etc/yum.repos.d/_copr_secureblue-hardened_malloc.repo" "https://copr.fedorainfracloud.org/coprs/secureblue/hardened_malloc/repo/fedora-$fedora_version/secureblue-hardened_malloc-fedora-$fedora_version.repo"

rpm-ostree install hardened_malloc

# Configure
echo "libhardened_malloc.so" >>/usr/etc/ld.so.preload

mkdir -p /usr/lib/systemd/user/wireplumber.service.d
cat <<EOF >>/usr/lib/systemd/user/wireplumber.service.d/preload.conf
[Service]
Environment=LD_PRELOAD=/usr/lib64/libhardened_malloc-light.so
EOF

mkdir -p /usr/lib/systemd/system/upower.service.d
cat <<EOF >>/usr/lib/systemd/system/upower.service.d/namespaces.conf
[Service]
# Namespaces
PrivateUsers=no
RestrictNamespaces=no
EOF

cat <<EOF >>/usr/share/ublue-os/just/60-custom.just
harden-flatpak:
    flatpak override --user --filesystem=host-os:ro --env=LD_PRELOAD=/var/run/host/usr/lib64/libhardened_malloc.so
EOF

