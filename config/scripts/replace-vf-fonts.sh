#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

ln -s "/usr/share/fonts/google-noto-sans-cjk-fonts" "/usr/share/fonts/noto-cjk"

# Array font names
# mapfile -t font_names < <(rpm -qa | grep -oP "(.+)(?=-vf-fonts)")
# mapfile -t non_vf_fonts_names < <(printf '%s-fonts\n' "${font_names[@]}")

# # Remove not existing string fonts
# to_delete=(google-noto-sans-mono-cjk-fonts)
# for i in "${!non_vf_fonts_names[@]}"; do
#     for j in "${to_delete[@]}"; do
#         if [ "${non_vf_fonts_names[i]}" = "$j" ]; then
#             unset 'non_vf_fonts_names[i]'
#         fi
#     done
# done

# rpm-ostree install "${non_vf_fonts_names[@]}"

# mkdir -p /usr/share/fonts/noto
# for f in /usr/share/fonts/google-noto/*; do
#     ln -sf "$f" /usr/share/fonts/noto
# done
# for f in /usr/share/fonts/google-noto-color-emoji-fonts/*; do
#     ln -sf "$f" /usr/share/fonts/noto
# done

# mkdir -p /usr/share/fonts/noto-cjk
# for f in /usr/share/fonts/google-noto-sans-cjk-fonts/*; do
#     ln -sf "$f" /usr/share/fonts/noto-cjk
# done

# for f in /usr/share/fonts/google-noto-serif-cjk-fonts/*; do
#     ln -sf "$f" /usr/share/fonts/noto-cjk
# done

# fc-cache -rf
