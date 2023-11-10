#!/usr/bin/env bash
set -oue pipefail

RELEASE=$(curl -sSLf "https://api.github.com/repos/Alex313031/thorium/releases/latest")

url=$(echo "$RELEASE" | yq '.assets[] | select(.name == "*.rpm") | .url')
curl -sSLf "$url" -H 'Accept: application/octet-stream' -o /tmp/thorium.rpm
rpm-ostree install /tmp/thorium.rpm

cp -r /etc /usr/etc
mv /opt/chromium.org/thorium /usr/lib/thorium

cat <<EOF >/usr/lib/tmpfiles.d/thorium.conf
L  /opt/chromium.org/thorium  -  -  -  -  /usr/lib/thorium
EOF

# cat <<EOF >/usr/bin/thorium-browser
# #!/usr/bin/env bash

# XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-~/.config}

# # Allow users to override command-line options
# if [[ -f $XDG_CONFIG_HOME/thorium-flags.conf ]]; then
#    THORIUM_USER_FLAGS="$(cat $XDG_CONFIG_HOME/thorium-flags.conf)"
# fi

# # Launch
# exec /usr/bin/thorium $THORIUM_USER_FLAGS "$@"
# EOF
