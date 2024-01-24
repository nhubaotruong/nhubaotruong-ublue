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
d /opt/microsoft 0755 root root - -
d /var/opt/microsoft 0755 root root - -
d /var/microsoft-workdir 0755 root root - -
d /var/log/microsoft 0755 root root - -
d /etc/opt/microsoft/mdatp 0755 root root - -
EOF

cat <<EOF >/usr/lib/sysusers.d/mdatp-user.conf
u mdatp - "Mdatp user" /opt/microsoft/mdatp /usr/sbin/nologin
EOF

cat <<EOF >/usr/lib/systemd/system/mdatp-workaround.service
[Unit]
Description=Workaround mdatp not having the correct label
ConditionPathExists=/usr/lib/microsoft/mdatp
After=local-fs.target
After=opt.mount

[Service]
Type=oneshot
# Copy if it doens't exist
# ExecStartPre=/usr/bin/bash -c "[ -d /usr/local/lib/.microsoft ] || /usr/bin/cp -r /usr/lib/microsoft /usr/local/lib/.microsoft"
ExecStartPre=/usr/bin/bash -c "/usr/bin/cp -r /usr/lib/microsoft /opt/microsoft"
ExecStartPre=/usr/sbin/semodule -i "/opt/microsoft/mdatp/conf/selinux_policies/out/audisp_mdatp.pp"
# This is faster than using .mount unit. Also allows for the previous line/cleanup
# ExecStartPre=/usr/bin/mount -t overlay overlay -o lowerdir=/usr/local/lib/.microsoft,upperdir=/var/opt/microsoft,workdir=/var/microsoft-workdir /var/opt/microsoft
# Fix SELinux label
ExecStart=/usr/sbin/restorecon -rvF /opt/microsoft/mdatp
ExecStartPost=/usr/sbin/setsebool -P audisp_mdatp_from_audisp_t off
ExecStartPost=/usr/sbin/setsebool -P audisp_mdatp_from_auditd_t on
# Clean-up after ourselves
ExecStop=/usr/bin/umount /usr/lib/microsoft/mdatp
ExecStop=/usr/bin/rm -r /usr/local/lib/.microsoft
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

mkdir -p /usr/lib/systemd/system/mdatp.service.d

cat <<EOF >/usr/lib/systemd/system/mdatp.service.d/override.conf
[Unit]
After=mdatp-workaround.service
EOF

systemctl enable mdatp.service mdatp-workaround.service
