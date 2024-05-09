#!/usr/bin/env bash

# set -oeux pipefail

rpm-ostree install zlib-devel libcap-ng-devel libnetfilter_queue-devel

git clone https://github.com/bol-van/zapret.git /tmp/zapret

cd /tmp/zapret

mkdir -p /usr/lib/zapret

make -C /usr/lib/zapret

ln -fs /usr/lib/zapret/zapret/init.d/systemd/zapret.service /usr/lib/zapret/systemd/system
ln -fs /usr/lib/zapret/init.d/systemd/zapret-list-update.service /usr/lib/systemd/system
ln -fs /usr/lib/zapret/init.d/systemd/zapret-list-update.timer /usr/lib/systemd/system

/usr/lib/zapret/ipset/clear_lists.sh
/usr/lib/zapret/ipset/get_config.sh

systemctl enable zapret.serviec zapret-list-update.timer
