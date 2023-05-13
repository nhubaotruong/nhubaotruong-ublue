#!/usr/bin/env bash

set -oeux pipefail

systemctl enable \
    docker.socket \
    tlp \
    supergfxd \
    systemd-resolved \
    chronyd

systemctl start /dev/zram0