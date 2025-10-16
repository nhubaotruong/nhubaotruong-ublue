#!/usr/bin/env bash
set -oue pipefail

# On libostree systems, /opt is a symlink to /var/opt,
# which actually only exists on the live system. /var is
# a separate mutable, stateful FS that's overlaid onto
# the ostree rootfs. Therefore we need to install it into
# /usr/lib/opt/microsoft to maintain the expected path structure.
mkdir -p /var/opt

# Setup repo
curl -sSLf "https://packages.microsoft.com/config/rhel/10/prod.repo" -o /etc/yum.repos.d/microsoft.repo

rpm --import https://packages.microsoft.com/keys/microsoft.asc

dnf5 -y --setopt=tsflags=noscripts install mdatp

# Move the initial installation to the correct base directory
mv /var/opt/microsoft /usr/lib/opt/microsoft

# Create necessary directories and tmpfiles configuration
cat <<EOF >/usr/lib/tmpfiles.d/microsoft.conf
d /var/opt/microsoft/mdatp/sbin 0755 root root - -
d /var/microsoft-workdir 0755 root root - -
d /var/microsoft-upper 0755 root root - -
d /var/log/microsoft 0755 root root - -
d /etc/opt/microsoft 0755 root root - -
EOF

cat <<EOF >/usr/lib/sysusers.d/mdatp-user.conf
u mdatp - "Mdatp user" /usr/lib/opt/microsoft/mdatp /usr/sbin/nologin
EOF

mkdir -p /usr/lib/systemd/system/mdatp.service.d

cat <<EOF >/usr/lib/systemd/system/mdatp.service.d/override.conf
[Service]
ExecStartPre=/usr/bin/mount -t overlay overlay -o lowerdir=/usr/lib/opt/microsoft,upperdir=/var/microsoft-upper,workdir=/var/microsoft-workdir /var/opt/microsoft
ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/semodule -i /var/opt/microsoft/mdatp/conf/selinux_policies/out/audisp_mdatp.pp || true"
ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/semanage fcontext -a -e /opt/microsoft/mdatp /var/opt/microsoft/mdatp || true"
ExecStartPre=/usr/bin/bash -c "env LD_LIBRARY_PATH='' /usr/sbin/restorecon -vR /var/opt/microsoft/mdatp"
ExecStop=/usr/bin/umount /var/opt/microsoft
EOF

systemctl enable mdatp
