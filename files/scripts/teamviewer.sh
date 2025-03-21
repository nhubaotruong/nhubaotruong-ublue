#!/usr/bin/env bash
set -oue pipefail

dnf5 -y install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

rm -f /etc/yum.repos.d/teamviewer.repo
