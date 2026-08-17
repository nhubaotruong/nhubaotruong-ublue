#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Install tailmix (multi-tailnet networking daemon) from the latest GitHub release.
# Follows the upstream install.sh layout:
#   /usr/lib/tailmix/versions/<version>/   binaries
#   /usr/lib/tailmix/current               -> versions/<version>
#   /usr/bin/tailmix, tailmixd             symlinks
#   /usr/lib/systemd/system/tailmixd.service      enabled (started on boot)

repo=maisem/tailmix
install_root=/usr/lib/tailmix

# Resolve the latest release version
version=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" |
    sed -n 's/.*"tag_name"[[:space:]]*:[[:space:]]*"\([^"]*\)".*/\1/p' | head -n 1)
[ -n "$version" ] || {
    echo "could not determine latest release" >&2
    exit 1
}

case $(uname -m) in
x86_64 | amd64) arch=amd64 ;;
arm64 | aarch64) arch=arm64 ;;
*)
    echo "unsupported architecture: $(uname -m)" >&2
    exit 1
    ;;
esac

tmp=$(mktemp -d "${TMPDIR:-/tmp}/tailmix-install.XXXXXX")
trap 'rm -rf "$tmp"' EXIT HUP INT TERM

asset="tailmix_linux_${arch}.tar.gz"
base="https://github.com/$repo/releases/download/$version"
curl -fsSL "$base/$asset" -o "$tmp/$asset"
curl -fsSL "$base/checksums.txt" -o "$tmp/checksums.txt"
(cd "$tmp" && grep "  $asset\$" checksums.txt | sha256sum -c -)

mkdir "$tmp/unpack"
tar -xzf "$tmp/$asset" -C "$tmp/unpack" tailmix tailmixd service/tailmixd.service.in

# Stage the versioned install, then atomically point "current" at it
root="$install_root"
version_root="$root/versions/$version"
install -d -m 0755 "$root/versions"
staged="$root/versions/.$version.$$"
install -d -m 0755 "$staged"
install -m 0755 "$tmp/unpack/tailmix" "$staged/tailmix"
install -m 0755 "$tmp/unpack/tailmixd" "$staged/tailmixd"
mv "$staged" "$version_root"

next="$root/.current.$$"
ln -s "versions/$version" "$next"
mv -Tf "$next" "$root/current"

ln -sfn "$install_root/current/tailmix" /usr/bin/tailmix
ln -sfn "$install_root/current/tailmixd" /usr/bin/tailmixd

# systemd unit: enable at build time, started on boot
install -d -m 0755 /usr/lib/systemd/system
sed "s|@BINDIR@|$install_root/current|g" "$tmp/unpack/service/tailmixd.service.in" >/usr/lib/systemd/system/tailmixd.service
chmod 0644 /usr/lib/systemd/system/tailmixd.service
systemctl enable tailmixd.service

echo "Installed tailmix $version."
