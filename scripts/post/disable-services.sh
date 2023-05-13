#!/usr/bin/env bash

set -oeux pipefail

systemctl disable \
    systemd-resolved
