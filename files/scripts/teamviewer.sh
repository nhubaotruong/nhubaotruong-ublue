#!/usr/bin/env bash
set -oue pipefail

# Setup repo
cat <<EOF >/etc/yum.repos.d/teamviewer.repo
[teamviewer]
name=TeamViewer - $basearch
baseurl=https://linux.teamviewer.com/yum/stable/main/binary-$basearch/
gpgkey=https://linux.teamviewer.com/pubkey/currentkey.asc
gpgcheck=1
repo_gpgcheck=1
enabled=1
type=rpm-md
EOF

rpm --import https://linux.teamviewer.com/pubkey/currentkey.asc

rpm-ostree install teamviewer

rm -f /etc/yum.repos.d/teamviewer.repo
