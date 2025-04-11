#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail
export EXTRA_THEMES="Papirus-Dark"
wget -qO- https://git.io/papirus-icon-theme-install | sh

cat > "/tmp/update_symbolic_sections.py" <<'EOF'
import configparser
import re
from pathlib import Path

# Path to the index.theme file
INI_PATHS = (
    Path("/usr/share/icons/Papirus/index.theme"),
    Path("/usr/share/icons/Papirus-Dark/index.theme"),
)

for ini_path in INI_PATHS:
    # Load the theme config
    config = configparser.ConfigParser(strict=False)
    config.optionxform = str  # Preserve key case
    config.read(ini_path)

    compiled_regex = re.compile(r"(\d+)[xX](\d+).*/symbolic")
    # Update all [*symbolic*] sections
    for section in config.sections():
        if "symbolic" in section:
            match = compiled_regex.match(section)
            if match:
                size = match.group(1)
                print(f"🔧 Updating [{section}] with MinSize={size}")
                config[section]["Type"] = "Scalable"
                config[section]["MinSize"] = size
                config[section]["MaxSize"] = "512"

    # Save changes back to the file
    with ini_path.open("w") as f:
        config.write(f)

    print("✅ Symbolic sections updated.")
EOF

python3 /tmp/update_symbolic_sections.py

gtk-update-icon-cache -f /usr/share/icons/Papirus
gtk-update-icon-cache -f /usr/share/icons/Papirus-Dark