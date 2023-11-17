#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

MODULE_NAME=acpi_ec

SIGN_DIR=/usr/share/dkms-keys

rpm-ostree install kernel-devel kernel-devel-matched kernel-headers dkms make

git clone https://github.com/musikid/acpi_ec.git /tmp/acpi_ec

cd /tmp/acpi_ec

VERSION=$(git describe --tags --abbrev=0)
MOD_SRC_DIR="/usr/src/$MODULE_NAME-$VERSION"

mkdir -p "$MOD_SRC_DIR"
cp -R "$PWD/src/" "$MOD_SRC_DIR/src"

cp dkms.conf "$MOD_SRC_DIR/dkms.conf"
sed -i "s/PACKAGE_VERSION=.*/PACKAGE_VERSION=\"$VERSION\"/" "$MOD_SRC_DIR/dkms.conf"
dkms add -m "$MODULE_NAME" -v "$VERSION"
dkms build -m "$MODULE_NAME" -v "$VERSION"
dkms install -m "$MODULE_NAME" -v "$VERSION"

/usr/src/kernels/"$(uname -r)"/scripts/sign-file sha256 $SIGN_DIR/dkms.priv $SIGN_DIR/dkms.der "$(modinfo -n $MODULE_NAME)"

echo "acpi_ec" >/usr/etc/modules-load.d/acpi_ec.conf

rm -rf "$MOD_SRC_DIR"

rpm-ostree uninstall dkms make
