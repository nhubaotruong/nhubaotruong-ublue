#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

find /usr/share/selinux -type f -name "*.pp*" | while read -r file; do
    semodule -i "$file"
done

restorecon -vFr /

cp -R /etc/selinux /usr/etc/selinux
