#!/usr/bin/env bash
set -oue pipefail

curl -L https://download.teamviewer.com/download/linux/teamviewer.x86_64.rpm -o /tmp/teamviewer.rpm

extracted_dir="/tmp/teamviewer"

mkdir -p $extracted_dir

rpm2cpio /tmp/teamviewer.rpm | cpio -idmv -D $extracted_dir

old_path="/opt/teamviewer"
new_path="/usr/lib/teamviewer"

find "$extracted_dir" -type l | while read -r symlink; do
    target=$(readlink "$symlink")
    if [[ $target == $old_path* ]]; then
        new_target="${target/$old_path/$new_path}"
        ln -snf "$new_target" "$symlink"
        echo "Fixed $symlink"
    fi
done

# find .desktop and .service files and fix them
find "$extracted_dir/opt/teamviewer" -type f -name "*.desktop" -o -name "*.service" | while read -r file; do
    sed -i 's/\/opt\/teamviewer/\/usr\/lib\/teamviewer/g' "$file"
done

mv /tmp/teamviewer/opt/teamviewer /usr/lib

cp -r /tmp/teamviewer/usr/* /usr/

install -D -m0644 /usr/lib/teamviewer/tv_bin/script/teamviewerd.service /usr/lib/systemd/system/teamviewerd.service
