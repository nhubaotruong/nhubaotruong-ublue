#!/usr/bin/env python3

import os

# Get all installed fonts
fonts = os.popen("rpm -qa | grep -oP '(.+)(?=-vf-fonts)'").read().splitlines()
vf_fonts_names = [f"{font}-vf-fonts" for font in fonts]
non_vf_fonts_names = [f"{font}-fonts" for font in fonts]

delete_fonts = ("google-noto-sans-mono-cjk",)

for font in delete_fonts:
    if f"{font}-fonts" in non_vf_fonts_names:
        non_vf_fonts_names.remove(f"{font}-fonts")
    if f"{font}-vf-fonts" in vf_fonts_names:
        vf_fonts_names.remove(f"{font}-vf-fonts")

status_code = os.system(
    f"rpm-ostree override remove {' '.join(vf_fonts_names)} --install {' '.join(non_vf_fonts_names)}"
)

exit(status_code)

# # Tell build process to exit if there are any errors.
# set -oue pipefail

# # Array font names
# mapfile -t font_names < <(rpm -qa | grep -oP "(.+)(?=-vf-fonts)")
# mapfile -t vf_fonts_names < <(printf '%s-vf-fonts\n' "${font_names[@]}")
# mapfile -t non_vf_fonts_names < <(printf '%s-fonts\n' "${font_names[@]}")

# # Remove not existing string fonts
# delete=(google-noto-sans-mono-cjk)
# for del in "${delete[@]}"; do
#     non_vf_fonts_names=("${non_vf_fonts_names[@]/$del-fonts/}")
#     vf_fonts_names=("${vf_fonts_names[@]/$del-vf-fonts/}")
# done

# # There's an empty element in the array, remove it
# non_vf_fonts_names=("${non_vf_fonts_names[@]/''/}")
# vf_fonts_names=("${vf_fonts_names[@]/''/}")

# rpm-ostree override remove "${vf_fonts_names[@]}" "$(printf -- "--install=%s " "${non_vf_fonts_names[@]}")"
