#!/usr/bin/env bash
set -oue pipefail

curl -L https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm

rpm-ostree install /tmp/teamviewer.rpm
