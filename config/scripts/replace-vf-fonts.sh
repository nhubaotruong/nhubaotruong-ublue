#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

font_names=$(rpm -qa | grep -oP "(.+)(?=-vf-fonts)")
vf_fonts_names=$(echo "$font_names" | awk '{printf "%s-vf-fonts ", $0}' | sed 's/$//')
non_vf_fonts_names=$(echo "$font_names" | awk '{printf "%s-fonts ", $0}' | sed 's/$//')

rpm-ostree override remove "$vf_fonts_names" --install "$non_vf_fonts_names"
