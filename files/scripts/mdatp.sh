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
curl -sSLf "https://packages.microsoft.com/config/rhel/8/insiders-slow.repo" -o /etc/yum.repos.d/microsoft.repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc

rpm-ostree install mdatp

mv /var/opt/microsoft /usr/lib/opt/microsoft

# ln -sf /usr/lib/microsoft/mdatp/sbin/wdavdaemonclient /usr/bin/mdatp
cat <<EOF >/usr/lib/tmpfiles.d/microsoft.conf
d /var/opt/microsoft/mdatp/sbin 0755 root root - -
d /var/microsoft-workdir 0755 root root - -
d /var/log/microsoft 0755 root root - -
d /etc/opt/microsoft 0755 root root - -
EOF

cat <<EOF >/usr/lib/sysusers.d/mdatp-user.conf
u mdatp - "Mdatp user" /usr/lib/opt/microsoft/mdatp /usr/sbin/nologin
EOF

mkdir -p /usr/lib/systemd/system/mdatp.service.d

cat <<EOF >/usr/lib/systemd/system/mdatp.service.d/override.conf
[Service]
ExecStartPre=/usr/bin/mount -t overlay overlay -o lowerdir=/usr/lib/opt/microsoft,upperdir=/var/opt/microsoft,workdir=/var/microsoft-workdir /var/opt/microsoft
ExecStop=/usr/bin/umount /var/opt/microsoft
EOF

# ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/semodule -i /var/opt/microsoft/mdatp/conf/selinux_policies/out/audisp_mdatp.pp || true"
# ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/semanage fcontext -a -e /opt/microsoft/mdatp /var/opt/microsoft/mdatp || true"
# ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/restorecon -vR /var/opt/microsoft/mdatp"
# ExecStop=/usr/bin/rm -rfv /var/microsoft-workdir

systemctl enable mdatp
