#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

cat <<EOF > /etc/yum.repos.d/cursor.repo
[cursor]
name=Cursor
baseurl=https://api2.cursor.sh/updates/api/rpm/stable/x86_64/rpm
enabled=1
gpgcheck=0
EOF

dnf5 -y install cursor

rm /etc/yum.repos.d/cursor.repo