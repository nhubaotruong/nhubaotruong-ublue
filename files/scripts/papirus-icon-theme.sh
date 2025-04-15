#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail
export EXTRA_THEMES="Papirus-Dark"
wget -qO- https://git.io/papirus-icon-theme-install | sh

# cat >"/usr/share/icons/Papirus/index.theme" <<'EOF'
# [Icon Theme]
# Name=Papirus-Dark
# Comment=Papirus icon theme for dark themes
# Inherits=breeze-dark,hicolor

# Example=folder

# FollowsColorScheme=true

# DesktopDefault=48
# DesktopSizes=16,22,24,32,48,64
# ToolbarDefault=22
# ToolbarSizes=16,22,24,32,48
# MainToolbarDefault=22
# MainToolbarSizes=16,22,24,32,48
# SmallDefault=16
# SmallSizes=16,22,24,32,48
# PanelDefault=48
# PanelSizes=16,22,24,32,48,64
# DialogDefault=48
# DialogSizes=16,22,24,32,48,64

# # Directory list
# Directories=8x8/emblems,16x16/actions,16x16/apps,16x16/categories,16x16/devices,16x16/emblems,16x16/emotes,16x16/mimetypes,16x16/panel,16x16/places,16x16/status,16x16@2x/actions,16x16@2x/apps,16x16@2x/categories,16x16@2x/devices,16x16@2x/emblems,16x16@2x/emotes,16x16@2x/mimetypes,16x16@2x/panel,16x16@2x/places,16x16@2x/status,18x18/actions,18x18@2x/actions,22x22/actions,22x22/animations,22x22/apps,22x22/categories,22x22/devices,22x22/emblems,22x22/emotes,22x22/mimetypes,22x22/panel,22x22/places,22x22/status,22x22@2x/actions,22x22@2x/animations,22x22@2x/apps,22x22@2x/categories,22x22@2x/devices,22x22@2x/emblems,22x22@2x/emotes,22x22@2x/mimetypes,22x22@2x/panel,22x22@2x/places,22x22@2x/status,24x24/actions,24x24/animations,24x24/apps,24x24/categories,24x24/devices,24x24/emblems,24x24/emotes,24x24/mimetypes,24x24/panel,24x24/places,24x24/status,24x24@2x/actions,24x24@2x/animations,24x24@2x/apps,24x24@2x/categories,24x24@2x/devices,24x24@2x/emblems,24x24@2x/emotes,24x24@2x/mimetypes,24x24@2x/panel,24x24@2x/places,24x24@2x/status,32x32/actions,32x32/apps,32x32/categories,32x32/devices,32x32/emblems,32x32/emotes,32x32/mimetypes,32x32/places,32x32/status,32x32/panel,32x32@2x/actions,32x32@2x/apps,32x32@2x/categories,32x32@2x/devices,32x32@2x/emblems,32x32@2x/emotes,32x32@2x/mimetypes,32x32@2x/places,32x32@2x/status,42x42/apps,48x48/actions,48x48/apps,48x48/categories,48x48/devices,48x48/emblems,48x48/emotes,48x48/mimetypes,48x48/places,48x48/status,48x48@2x/actions,48x48@2x/apps,48x48@2x/categories,48x48@2x/devices,48x48@2x/emblems,48x48@2x/emotes,48x48@2x/mimetypes,48x48@2x/places,48x48@2x/status,64x64/apps,64x64/categories,64x64/devices,64x64/mimetypes,64x64/places,64x64@2x/apps,64x64@2x/categories,64x64@2x/devices,64x64@2x/mimetypes,64x64@2x/places,84x84/apps,96x96/apps,96x96/devices,96x96/mimetypes,96x96/places,128x128/apps,128x128/devices,128x128/mimetypes,128x128/places,symbolic/actions,symbolic/apps,symbolic/categories,symbolic/devices,symbolic/emblems,symbolic/emotes,symbolic/mimetypes,symbolic/places,symbolic/status,symbolic/up-to-32

# [8x8/emblems]
# Context=Emblems
# Size=8
# Type=Fixed

# [16x16/actions]
# Context=Actions
# Size=16
# Type=Fixed

# [16x16/apps]
# Context=Applications
# Size=16
# Type=Fixed

# [16x16/categories]
# Context=Categories
# Size=16
# Type=Fixed

# [16x16/devices]
# Context=Devices
# Size=16
# Type=Fixed

# [16x16/emblems]
# Context=Emblems
# Size=16
# Type=Fixed

# [16x16/emotes]
# Context=Emotes
# Size=16
# Type=Fixed

# [16x16/mimetypes]
# Context=MimeTypes
# Size=16
# Type=Fixed

# [16x16/panel]
# Context=Status
# Size=16
# Type=Fixed

# [16x16/places]
# Context=Places
# Size=16
# Type=Fixed

# [16x16/status]
# Context=Status
# Size=16
# Type=Fixed

# [16x16@2x/actions]
# Context=Actions
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/apps]
# Context=Applications
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/categories]
# Context=Categories
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/devices]
# Context=Devices
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/emblems]
# Context=Emblems
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/emotes]
# Context=Emotes
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/mimetypes]
# Context=MimeTypes
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/panel]
# Context=Status
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/places]
# Context=Places
# Size=16
# Scale=2
# Type=Fixed

# [16x16@2x/status]
# Context=Status
# Size=16
# Scale=2
# Type=Fixed

# [18x18/actions]
# Context=Actions
# Size=18
# Type=Fixed

# [18x18@2x/actions]
# Context=Actions
# Size=18
# Scale=2
# Type=Fixed

# [22x22/actions]
# Context=Actions
# Size=22
# Type=Fixed

# [22x22/animations]
# Context=Animations
# Size=22
# Type=Fixed

# [22x22/apps]
# Context=Applications
# Size=22
# Type=Fixed

# [22x22/categories]
# Context=Categories
# Size=22
# Type=Fixed

# [22x22/devices]
# Context=Devices
# Size=22
# Type=Fixed

# [22x22/emblems]
# Context=Emblems
# Size=22
# Type=Fixed

# [22x22/emotes]
# Context=Emotes
# Size=22
# Type=Fixed

# [22x22/mimetypes]
# Context=MimeTypes
# Size=22
# Type=Fixed

# [22x22/panel]
# Context=Status
# Size=22
# Type=Fixed

# [22x22/places]
# Context=Places
# Size=22
# Type=Fixed

# [22x22/status]
# Context=Status
# Size=22
# Type=Fixed

# [22x22@2x/actions]
# Context=Actions
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/animations]
# Context=Animations
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/apps]
# Context=Applications
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/categories]
# Context=Categories
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/devices]
# Context=Devices
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/emblems]
# Context=Emblems
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/emotes]
# Context=Emotes
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/mimetypes]
# Context=MimeTypes
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/panel]
# Context=Status
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/places]
# Context=Places
# Size=22
# Scale=2
# Type=Fixed

# [22x22@2x/status]
# Context=Status
# Size=22
# Scale=2
# Type=Fixed

# [24x24/actions]
# Context=Actions
# Size=24
# Type=Fixed

# [24x24/animations]
# Context=Animations
# Size=24
# Type=Fixed

# [24x24/apps]
# Context=Applications
# Size=24
# Type=Fixed

# [24x24/categories]
# Context=Categories
# Size=24
# Type=Fixed

# [24x24/devices]
# Context=Devices
# Size=24
# Type=Fixed

# [24x24/emblems]
# Context=Emblems
# Size=24
# Type=Fixed

# [24x24/emotes]
# Context=Emotes
# Size=24
# Type=Fixed

# [24x24/mimetypes]
# Context=MimeTypes
# Size=24
# Type=Fixed

# [24x24/panel]
# Context=Status
# Size=24
# Type=Fixed

# [24x24/places]
# Context=Places
# Size=24
# Type=Fixed

# [24x24/status]
# Context=Status
# Size=24
# Type=Fixed

# [24x24@2x/actions]
# Context=Actions
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/animations]
# Context=Animations
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/apps]
# Context=Applications
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/categories]
# Context=Categories
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/devices]
# Context=Devices
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/emblems]
# Context=Emblems
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/emotes]
# Context=Emotes
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/mimetypes]
# Context=MimeTypes
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/panel]
# Context=Status
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/places]
# Context=Places
# Size=24
# Scale=2
# Type=Fixed

# [24x24@2x/status]
# Context=Status
# Size=24
# Scale=2
# Type=Fixed

# [32x32/actions]
# Context=Actions
# Size=32
# Type=Fixed

# [32x32/apps]
# Context=Applications
# Size=32
# Type=Fixed

# [32x32/categories]
# Context=Categories
# Size=32
# Type=Fixed

# [32x32/devices]
# Context=Devices
# Size=32
# Type=Fixed

# [32x32/emblems]
# Context=Emblems
# Size=32
# Type=Fixed

# [32x32/emotes]
# Context=Emotes
# Size=32
# Type=Fixed

# [32x32/mimetypes]
# Context=MimeTypes
# Size=32
# Type=Fixed

# [32x32/places]
# Context=Places
# Size=32
# Type=Fixed

# [32x32/status]
# Context=Status
# Size=32
# Type=Fixed

# [32x32/panel]
# Context=Status
# Size=32
# Type=Fixed

# [32x32@2x/actions]
# Context=Actions
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/apps]
# Context=Applications
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/categories]
# Context=Categories
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/devices]
# Context=Devices
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/emblems]
# Context=Emblems
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/emotes]
# Context=Emotes
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/mimetypes]
# Context=MimeTypes
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/places]
# Context=Places
# Size=32
# Scale=2
# Type=Fixed

# [32x32@2x/status]
# Context=Status
# Size=32
# Scale=2
# Type=Fixed

# [42x42/apps]
# Context=Applications
# Size=42
# Type=Fixed

# [48x48/actions]
# Context=Actions
# Size=48
# Type=Fixed

# [48x48/apps]
# Context=Applications
# Size=48
# Type=Fixed

# [48x48/categories]
# Context=Categories
# Size=48
# Type=Fixed

# [48x48/devices]
# Context=Devices
# Size=48
# Type=Fixed

# [48x48/emblems]
# Context=Emblems
# Size=48
# Type=Fixed

# [48x48/emotes]
# Context=Emotes
# Size=48
# Type=Fixed

# [48x48/mimetypes]
# Context=MimeTypes
# Size=48
# Type=Fixed

# [48x48/places]
# Context=Places
# Size=48
# Type=Fixed

# [48x48/status]
# Context=Status
# Size=48
# MinSize=48
# MaxSize=512
# Type=Scalable

# [48x48@2x/actions]
# Context=Actions
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/apps]
# Context=Applications
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/categories]
# Context=Categories
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/devices]
# Context=Devices
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/emblems]
# Context=Emblems
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/emotes]
# Context=Emotes
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/mimetypes]
# Context=MimeTypes
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/places]
# Context=Places
# Size=48
# Scale=2
# Type=Fixed

# [48x48@2x/status]
# Context=Status
# Size=48
# MinSize=48
# MaxSize=512
# Scale=2
# Type=Scalable

# [64x64/apps]
# Context=Applications
# Size=64
# Type=Fixed

# [64x64/categories]
# Context=Categories
# Size=64
# Type=Fixed

# [64x64/devices]
# Context=Devices
# Size=64
# Type=Fixed

# [64x64/mimetypes]
# Context=MimeTypes
# Size=64
# Type=Fixed

# [64x64/places]
# Context=Places
# Size=64
# Type=Fixed

# [64x64@2x/apps]
# Context=Applications
# Size=64
# Scale=2
# Type=Fixed

# [64x64@2x/categories]
# Context=Categories
# Size=64
# Scale=2
# Type=Fixed

# [64x64@2x/devices]
# Context=Devices
# Size=64
# Scale=2
# Type=Fixed

# [64x64@2x/mimetypes]
# Context=MimeTypes
# Size=64
# Scale=2
# Type=Fixed

# [64x64@2x/places]
# Context=Places
# Size=64
# Scale=2
# Type=Fixed

# [84x84/apps]
# Context=Applications
# Size=84
# Type=Fixed

# [96x96/apps]
# Context=Applications
# Size=96
# Type=Fixed

# [96x96/devices]
# Context=Devices
# Size=96
# Type=Fixed

# [96x96/mimetypes]
# Context=MimeTypes
# Size=96
# Type=Fixed

# [96x96/places]
# Context=Places
# Size=96
# Type=Fixed

# [128x128/apps]
# Context=Applications
# Size=128
# MinSize=128
# MaxSize=512
# Type=Scalable

# [128x128/devices]
# Context=Devices
# Size=128
# MinSize=128
# MaxSize=512
# Type=Scalable

# [128x128/mimetypes]
# Context=MimeTypes
# Size=128
# MinSize=128
# MaxSize=512
# Type=Scalable

# [128x128/places]
# Context=Places
# Size=128
# MinSize=128
# MaxSize=512
# Type=Scalable

# [symbolic/actions]
# Context=Actions
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/apps]
# Context=Applications
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/categories]
# Context=Categories
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/devices]
# Context=Devices
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/emblems]
# Context=Emblems
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/emotes]
# Context=Emotes
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/mimetypes]
# Context=MimeTypes
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/places]
# Context=Places
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/status]
# Context=Status
# Size=16
# MinSize=16
# MaxSize=512
# Type=Scalable

# [symbolic/up-to-32]
# Context=Status
# Size=16
# MinSize=16
# MaxSize=32
# Type=Scalable
# EOF

# cp "/usr/share/icons/Papirus/index.theme" "/usr/share/icons/Papirus-Dark/index.theme"

gtk-update-icon-cache -f /usr/share/icons/Papirus
gtk-update-icon-cache -f /usr/share/icons/Papirus-Dark
