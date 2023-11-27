#!/usr/bin/env bash
set -oue pipefail

# On libostree systems, /opt is a symlink to /var/opt,
# which actually only exists on the live system. /var is
# a separate mutable, stateful FS that's overlaid onto
# the ostree rootfs. Therefore we need to install it into
# /usr/lib/1Password instead, and dynamically create a
# symbolic link /opt/1Password => /usr/lib/1Password upon
# boot.
mkdir -p /var/opt
mkdir -p /var/lock

cat <<EOF >/etc/yum.repos.d/teamviewer.repo
[teamviewer]
name=TeamViewer - \$basearch
baseurl=https://linux.teamviewer.com/yum/stable/main/binary-\$basearch/
gpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc
gpgcheck=1
repo_gpgcheck=1
enabled=1
type=rpm-md
EOF

rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc

rpm-ostree install teamviewer

mv /var/opt/teamviewer /usr/lib/teamviewer

rm -rf /usr/lib/teamviewer/tv_bin/RTlib

install -D -m0644 /usr/lib/teamviewer/tv_bin/script/teamviewerd.service /usr/lib/systemd/system/teamviewerd.service

cat <<EOF >/usr/lib/tmpfiles.d/teamviewer.conf
L  /opt/teamviewer  -  -  -  -  /usr/lib/teamviewer
EOF
