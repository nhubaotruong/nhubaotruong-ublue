#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

# Build tailmix (multi-tailnet networking daemon) from the main branch of the
# fork, then install it with the upstream install.sh layout:
#   /usr/lib/tailmix/versions/<version>/   binaries
#   /usr/lib/tailmix/current               -> versions/<version>
#   /usr/bin/tailmix, tailmixd             symlinks
#   /usr/lib/systemd/system/tailmixd.service      enabled (started on boot)

repo=https://github.com/nhubaotruong/tailmix
branch=main
install_root=/usr/lib/tailmix

# Go toolchain, only for the build. Fedora ships Go 1.26 with GOTOOLCHAIN=local,
# but tailmix's go.mod requires Go 1.27.2, so let Go fetch that toolchain.
if command -v go >/dev/null 2>&1; then
    installed_go=0
else
    installed_go=1
    dnf5 -y install go
fi
export GOTOOLCHAIN=auto
export CGO_ENABLED=0

src=/tmp/tailmix-src
build_dir=$(mktemp -d "${TMPDIR:-/tmp}/tailmix-build.XXXXXX")
trap 'rm -rf "$build_dir" "$src"' EXIT HUP INT TERM

# Full clone: cmd/mkversion derives the version from Git history.
git clone --branch "$branch" "$repo" "$src"
cd "$src"

# Same version stamping as upstream's `make install` and its release builds.
ldflags=$(go run ./cmd/mkversion)
version=$(sed -n 's/.*version\.longStamp=\([^ ]*\).*/\1/p' <<<"$ldflags")
[ -n "$version" ] || {
    echo "could not determine tailmix version" >&2
    exit 1
}

go build -ldflags "$ldflags -s -w" -o "$build_dir/tailmix" ./cmd/tailmix
go build -ldflags "$ldflags -s -w" -o "$build_dir/tailmixd" ./cmd/tailmixd

# Stage the versioned install, then atomically point "current" at it
root="$install_root"
version_root="$root/versions/$version"
install -d -m 0755 "$root/versions"
staged="$root/versions/.$version.$$"
install -d -m 0755 "$staged"
install -m 0755 "$build_dir/tailmix" "$staged/tailmix"
install -m 0755 "$build_dir/tailmixd" "$staged/tailmixd"
mv "$staged" "$version_root"

next="$root/.current.$$"
ln -s "versions/$version" "$next"
mv -Tf "$next" "$root/current"

ln -sfn "$install_root/current/tailmix" /usr/bin/tailmix
ln -sfn "$install_root/current/tailmixd" /usr/bin/tailmixd

# systemd unit: enable at build time, started on boot
install -d -m 0755 /usr/lib/systemd/system
sed "s|@BINDIR@|$install_root/current|g" "$src/systemd/tailmixd.service.in" >/usr/lib/systemd/system/tailmixd.service
chmod 0644 /usr/lib/systemd/system/tailmixd.service
systemctl enable tailmixd.service

if [ "$installed_go" = 1 ]; then
    dnf5 -y remove go
fi

echo "Installed tailmix $version (built from $branch)."
