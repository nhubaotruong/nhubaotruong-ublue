#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

systemctl enable tlp.service supergfxd.service tailscaled.service dnsproxy.service
