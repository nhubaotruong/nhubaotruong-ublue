#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

echo -e "[cursor]\nname=Cursor\nbaseurl=https://api2.cursor.sh/updates/api/rpm/stable/x86_64/rpm" > /etc/yum.repos.d/cursor.repo
dnf5 -y install cursor

rm /etc/yum.repos.d/cursor.repo