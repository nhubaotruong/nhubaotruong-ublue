#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

font_names=(
    "Meslo"
    "FiraCode"
)

RELEASE=$(curl -Ls "https://api.github.com/repos/ryanoasis/nerd-fonts/releases/latest")

BASE_DIR="/usr/share/fonts"

mkdir -p $BASE_DIR

for font in "${font_names[@]}"; do
    url=$(echo "$RELEASE" | yq ".assets[] | select(.name == \"$font.tar.xz\") | .url")
    curl -L "$url" -H 'Accept: application/octet-stream' | tar -xvf -C $BASE_DIR --one-top-level
    restorecon -vFr "$BASE_DIR/$font"
    chmod 644 "$BASE_DIR/$font"/*
    chown -R root: "$BASE_DIR/$font"
done

fc-cache -rs
