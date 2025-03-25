#!/usr/bin/env bash
set -oue pipefail

depmod -a -v "$(ls /usr/lib/modules)"
