#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Array font names
mapfile -t font_names < <(rpm -qa | grep -oP "(.+)(?=-vf-fonts)")
mapfile -t non_vf_fonts_names < <(printf '%s-fonts\n' "${font_names[@]}")

# Remove not existing string fonts
to_delete=(google-noto-sans-mono-cjk)
for i in "${!non_vf_fonts_names[@]}"; do
    for j in "${to_delete[@]}"; do
        if [ "${non_vf_fonts_names[i]}" = "$j" ]; then
            unset 'non_vf_fonts_names[i]'
        fi
    done
done

rpm-ostree install "${non_vf_fonts_names[@]}"

fc-cache -rs
