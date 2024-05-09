#!/usr/bin/env bash

set -oeux pipefail

mkdir -p /var/opt && cd /var/opt
git clone --depth 1 https://github.com/bol-van/zapret

/opt/zapret/install_bin.sh

ln -fs /opt/zapret/init.d/systemd/zapret.service /usr/lib/systemd/system
ln -fs /opt/zapret/init.d/systemd/zapret-list-update.timer /usr/lib/systemd/system
ln -fs /opt/zapret/init.d/systemd/zapret-list-update.service /usr/lib/systemd/system

systemctl enable zapret.serviec zapret-list-update.timer

mv /var/opt/zapret /usr/lib/zapret

cat <<EOF >/usr/lib/tmpfiles.d/teamviewer.conf
L  /opt/zapret  -  -  -  -  /usr/lib/zapret
EOF
cat <<EOF >/usr/lib/sysusers.d/zapret.conf
u zapret - "zapret dpi bypasser"
EOF