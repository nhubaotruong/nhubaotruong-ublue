#!/usr/bin/env bash
set -oue pipefail

curl -L https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm

mkdir -p /tmp/teamviewer

rpm2cpio /tmp/teamviewer.rpm | cpio -idmv -D /tmp/teamviewer

mv /tmp/teamviewer/opt/teamviewer /usr/lib

dir="/tmp/teamviewer/usr" # replace with your directory path
old_path="/opt/teamviewer"
new_path="/usr/lib/teamviewer"

find "$dir" -type l | while read -r symlink; do
    target=$(readlink "$symlink")
    if [[ $target == $old_path* ]]; then
        new_target="${target/$old_path/$new_path}"
        ln -snf "$new_target" "$symlink"
        echo "Fixed $symlink"
    fi
done

cp -r /tmp/teamviewer/usr/* /usr/
