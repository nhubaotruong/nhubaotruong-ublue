#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail
export EXTRA_THEMES="Papirus-Dark"
wget -qO- https://git.io/papirus-icon-theme-install | sh
ln -sf /usr/share/icons/Papirus/16x16/symbolic /usr/share/icons/Papirus/
ln -sf /usr/share/icons/Papirus-Dark/16x16/symbolic /usr/share/icons/Papirus-Dark/