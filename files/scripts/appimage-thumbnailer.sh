#!/usr/bin/env bash
set -oue pipefail

curl -L -o /usr/share/thumbnailers/AppImage-thumbnailer.thumbnailer https://raw.githubusercontent.com/realmazharhussain/AppImage-thumbnailer/refs/heads/main/AppImage-thumbnailer.thumbnailer
curl -L -o /usr/bin/AppImage-thumbnailer https://raw.githubusercontent.com/realmazharhussain/AppImage-thumbnailer/refs/heads/main/AppImage-thumbnailer
chmod +x /usr/bin/AppImage-thumbnailer