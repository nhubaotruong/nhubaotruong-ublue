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

# Setup repo
curl -sSLf "https://packages.microsoft.com/config/fedora/$(rpm -E %fedora)/prod.repo" -o /etc/yum.repos.d/microsoft.repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc

rpm-ostree install mdatp

mv /var/opt/microsoft /usr/lib/microsoft

# ln -sf /usr/lib/microsoft/mdatp/sbin/wdavdaemonclient /usr/bin/mdatp

cat <<EOF >/usr/lib/tmpfiles.d/microsoft.conf
d /var/opt/microsoft 0755 root root -
d /var/log/microsoft 0755 root root -
d /etc/opt/microsoft/mdatp 0755 root root -
EOF

cat <<EOF >/usr/lib/sysusers.d/mdatp-user.conf
u mdatp - "Mdatp user" /opt/microsoft/mdatp /usr/sbin/nologin
EOF

cat <<EOF >/usr/lib/systemd/system/opt-microsoft.mount
[Mount]
What=/usr/lib/microsoft
Where=/opt/microsoft
Type=none
Options=bind
EOF

# mkdir -p /usr/lib/systemd/system/mdatp.service.d
# cat <<EOF >/usr/lib/systemd/system/mdatp.service.d/override.conf
# [Service]
# WorkingDirectory=/usr/lib/microsoft/mdatp/sbin
# Environment=LD_LIBRARY_PATH=/usr/lib/microsoft/mdatp/lib/
# ExecStart=
# ExecStart=/usr/lib/microsoft/mdatp/sbin/wdavdaemon
# EOF

systemctl enable mdatp.service opt-microsoft.mount
