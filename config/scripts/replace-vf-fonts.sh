#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Array font names
mapfile -t font_names < <(rpm -qa | grep -oP "(.+)(?=-vf-fonts)")
mapfile -t vf_fonts_names < <(printf '%s-vf-fonts\n' "${font_names[@]}")
mapfile -t non_vf_fonts_names < <(printf '%s-fonts\n' "${font_names[@]}")

# Remove not existing string fonts
delete=(google-noto-sans-mono-cjk)
for del in "${delete[@]}"; do
    non_vf_fonts_names=("${non_vf_fonts_names[@]/$del-fonts/}")
    vf_fonts_names=("${vf_fonts_names[@]/$del-vf-fonts/}")
done

# There's an empty element in the array, remove it
non_vf_fonts_names=("${non_vf_fonts_names[@]/''/}")
vf_fonts_names=("${vf_fonts_names[@]/''/}")

rpm-ostree override remove "${vf_fonts_names[@]}" "$(printf -- "--install=%s " "${non_vf_fonts_names[@]}")"
