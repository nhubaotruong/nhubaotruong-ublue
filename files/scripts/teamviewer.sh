#!/usr/bin/env bash
set -oue pipefail

rpm-ostree install https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm

rm -f /etc/yum.repos.d/teamviewer.repo
