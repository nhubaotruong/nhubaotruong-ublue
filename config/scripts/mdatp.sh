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
d /var/microsoft-workdir 0755 root root -
d /var/log/microsoft 0755 root root -
d /etc/opt/microsoft/mdatp 0755 root root -
EOF

cat <<EOF >/usr/lib/sysusers.d/mdatp-user.conf
u mdatp - "Mdatp user" /usr/lib/microsoft/mdatp /usr/sbin/nologin
EOF

mkdir -p /usr/lib/systemd/system/mdatp.service.d

cat <<EOF >/usr/lib/systemd/system/mdatp.service.d/override.conf
[Unit]
After=var-opt-microsoft.mount
EOF

cat <<EOF >/usr/lib/systemd/system/var-opt-microsoft.mount
[Unit]
Description=Overlay Mount combining /usr/lib/microsoft and /var/opt/microsoft

[Mount]
What=overlay
Where=/var/opt/microsoft
Type=overlay
Options=lowerdir=/usr/lib/microsoft,upperdir=/var/opt/microsoft,workdir=/var/microsoft-workdir

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF >/usr/lib/systemd/system/mdatp-workaround.service
[Unit]
Description=Workaround mdatp not having the correct label
ConditionPathExists=/usr/lib/microsoft/mdatp
Before=var-opt-microsoft.mount
After=local-fs.target

[Service]
Type=oneshot
# Copy if it doens't exist
ExecStartPre=/usr/bin/bash -c "[ -d /usr/local/lib/.mdatp ] || /usr/bin/cp -r /usr/lib/microsoft/mdatp /usr/local/lib/.mdatp"
# This is faster than using .mount unit. Also allows for the previous line/cleanup
ExecStartPre=/usr/bin/mount --bind /usr/local/lib/.mdatp /usr/lib/microsoft/mdatp
# Fix SELinux label
ExecStart=/usr/sbin/restorecon -rF /usr/lib/microsoft/mdatp
# Clean-up after ourselves
ExecStop=/usr/bin/umount /usr/lib/microsoft/mdatp
ExecStop=/usr/bin/rm -r /usr/local/lib/.mdatp
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable mdatp.service var-opt-microsoft.mount mdatp-workaround.service
