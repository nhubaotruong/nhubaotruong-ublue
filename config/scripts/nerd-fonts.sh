#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

font_names=(
    "Meslo"
    "FiraCode"
    "CascadiaCode"
)

RELEASE=$(curl -Ls "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest")

BASE_DIR="/usr/share/fonts"

mkdir -p $BASE_DIR

for font in "${font_names[@]}"; do
    url=$(echo "$RELEASE" | yq ".assets[] | select(.name == \"$font.tar.xz\") | .url")
    curl -L "$url" -H 'Accept: application/octet-stream' -o "/tmp/$font.tar.xz"
    tar -xvf "/tmp/$font.tar.xz" -C $BASE_DIR --one-top-level
    restorecon -Rv "$BASE_DIR/$font"
    chown -R root:root "$BASE_DIR/$font"
done

fc-cache -f
