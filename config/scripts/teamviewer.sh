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

install -D -m0644 /usr/lib/teamviewer/tv_bin/script/teamviewerd.service /usr/lib/systemd/system/teamviewerd.service

cat <<EOF >/usr/lib/tmpfiles.d/teamviewer.conf
L  /opt/teamviewer  -  -  -  -  /usr/lib/teamviewer
EOF

# curl -L https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm

# extracted_dir="/tmp/teamviewer"

# mkdir -p $extracted_dir

# rpm2cpio /tmp/teamviewer.rpm | cpio -idmv -D $extracted_dir

# old_path="/opt/teamviewer"
# new_path="/usr/lib/teamviewer"

# find "$extracted_dir" -type l | while read -r symlink; do
#     target=$(readlink "$symlink")
#     if [[ $target == $old_path* ]]; then
#         new_target="${target/$old_path/$new_path}"
#         ln -snf "$new_target" "$symlink"
#         echo "Fixed $symlink"
#     fi
# done

# # find .desktop and .service files and fix them
# find "$extracted_dir/opt/teamviewer" -type f -name "*.desktop" -o -name "*.service" | while read -r file; do
#     sed -i 's/\/opt\/teamviewer/\/usr\/lib\/teamviewer/g' "$file"
# done

# mv /tmp/teamviewer/opt/teamviewer /usr/lib

# cp -r /tmp/teamviewer/usr/* /usr/
