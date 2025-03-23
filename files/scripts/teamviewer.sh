#!/usr/bin/env bash
set -oue pipefail

mkdir -p /var/opt/teamviewer

dnf5 -y install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

rm -f /etc/yum.repos.d/teamviewer.repo

mv /var/opt/teamviewer /usr/lib/opt/teamviewer
