#!/usr/bin/env bash
set -oue pipefail

curl -L https://download.teamviewer.com/download/linux/teamviewer_amd64.tar.xz -o /tmp/teamviewer.rpm

tar -xvf /tmp/teamviewer.rpm -C /tmp

/tmp/teamviewer/tv-setup install force
