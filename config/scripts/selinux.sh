#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

restorecon -vFr /

cp -R /etc/selinux /usr/etc/selinux
