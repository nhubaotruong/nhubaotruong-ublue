#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

font_names=(
    "Meslo"
    "FiraCode"
    "CascadiaCode"
)

RELEASE=$(curl -Ls "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest")

for font in "${font_names[@]}"; do
    url=$(echo "$RELEASE" | yq -r --unbuffered ".assets[] | select(.name == \"$font.tar.xz\") | .browser_download_url")
    curl -L "$url" -o "/tmp/$font.tar.xz"
    tar -xvf "/tmp/$font.tar.xz" -C /usr/share/fonts/ --one-top-level
    chown -R root: "/usr/share/fonts/$font"
    chmod 644 "/usr/share/fonts/$font"/*
    restorecon -vFr "/usr/share/fonts/$font"
done

fc-cache -f
