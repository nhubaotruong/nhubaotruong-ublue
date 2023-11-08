#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

RELEASE=$(curl -sSLf "https://api.github.com/repos/AdguardTeam/dnsproxy/releases/latest")

url=$(echo "$RELEASE" | yq '.assets[] | select(.name == "dnsproxy-linux-amd64*") | .url')
curl -sSLf "$url" -H 'Accept: application/octet-stream' | tar -xz -C /tmp/ --one-top-level=/tmp/dnsproxy
install -Dm755 /tmp/dnsproxy/linux-amd64/dnsproxy /usr/bin/dnsproxy
install -Dm644 /tmp/dnsproxy/linux-amd64/LICENSE /usr/share/license/dnsproxy/LICENSE
install -Dm644 /tmp/dnsproxy/linux-amd64/README.md /usr/share/doc/dnsproxy/README.md

cat <<EOF >/usr/lib/systemd/system/dnsproxy.service
[Unit]
Description=Simple DNS proxy with DoH, DoT, and DNSCrypt support
Documentation=https://github.com/AdguardTeam/dnsproxy#readme
After=network.target
Before=network-online.target

[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
CapabilityBoundingSet=CAP_NET_BIND_SERVICE
DynamicUser=yes
ExecStart=/usr/bin/dnsproxy --config-path=/etc/dnsproxy/dnsproxy.yaml

[Install]
WantedBy=multi-user.target
EOF

systemctl enable dnsproxy.service
