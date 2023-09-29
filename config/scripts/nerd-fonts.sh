#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

font_names=(
    "Meslo"
    "FiraCode"
)

font_version="$(curl -Ls https://github.com/ryanoasis/nerd-fonts/releases/latest | grep -m 1 -oP '(?<=<h1 data-view-component="true" class="d-inline mr-3">)(.+)(?=</h1>)')"

for font in "${font_names[@]}"; do
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/download/$font_version/$font.tar.xz" -o "/tmp/$font.tar.xz"
    tar -xvf "/tmp/$font.tar.xz" -C /usr/share/fonts/ --one-top-level
    chown -R root: "/usr/share/fonts/$font"
    chmod 644 "/usr/share/fonts/$font"/*
    restorecon -vFr "/usr/share/fonts/$font"
done

fc-cache -f
