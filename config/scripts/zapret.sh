#!/usr/bin/env bash

set -oeux pipefail

rpm-ostree install zlib-ng-devel libcap-ng-devel libnetfilter_queue-devel

mkdir -p /var/opt && cd /var/opt
git clone https://github.com/bol-van/zapret.gits

make -C /opt/zapret

ln -fs /opt/zapret/zapret/init.d/systemd/zapret.service /usr/lib/zapret/systemd/system
ln -fs /opt/zapret/init.d/systemd/zapret-list-update.service /usr/lib/systemd/system
ln -fs /opt/zapret/init.d/systemd/zapret-list-update.timer /usr/lib/systemd/system

/opt/zapret/ipset/clear_lists.sh
/opt/zapret/ipset/get_config.sh

systemctl enable zapret.serviec zapret-list-update.timer
