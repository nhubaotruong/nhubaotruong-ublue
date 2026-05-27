#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

build_extension() {
    local repo="$1"
    local uuid="$2"
    local ext_dir="/usr/share/gnome-shell/extensions/${uuid}"
    local build_dir
    build_dir="$(mktemp -d)"

    git clone --depth=1 "${repo}" "${build_dir}"
    (cd "${build_dir}" && bash build.sh)

    mkdir -p "${ext_dir}"
    unzip -o "${build_dir}/${uuid}.shell-extension.zip" -d "${ext_dir}"

    if [ -d "${ext_dir}/schemas" ]; then
        glib-compile-schemas --strict "${ext_dir}/schemas"
    fi

    rm -rf "${build_dir}"
}

build_extension "https://github.com/AlexanderVanhee/gradia-capture.git" "gradia-integration@alexandervanhee.github.io"
build_extension "https://github.com/bazaar-org/bazaar-companion.git" "bazaar-integration@kolunmi.github.io"
