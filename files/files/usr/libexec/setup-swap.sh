#!/usr/bin/sh
set -e

cd "$(dirname "$0")"

size=12G

if [ "$(whoami)" != "root" ]; then
    echo "Script must be run as root" >&2
    exit 1
fi

if [ "$1" == "--recreate" ]; then
    shift
    swapoff /var/swap/swapfile || true
    rm /var/swap/swapfile
elif [ -e /var/swap/swapfile ]; then
    echo "/var/swap/swapfile already exists, use --recreate to recreate" >&2
    exit 1
fi

[ -n "$1" ] && size="$1"

free_bytes="$(($(stat -f --format="%a*%S" .)))"
size_bytes="$(numfmt --from=auto "$size")"
need=$((2 * $size_bytes))

if [ "$free_bytes" -lt "$need" ]; then
    echo "Not enough free disk space to allocate swap"
    exit 1
fi

[ ! -e /var/swap ] && btrfs subvolume create /var/swap
chattr +C /var/swap
fallocate -l "$size" /var/swap/swapfile
chmod 0600 /var/swap/swapfile

semanage fcontext -a -t var_t -f d '/var/swap' || true
semanage fcontext -a -t swapfile_t -f f '/var/swap/swapfile' || true
restorecon -v -r '/var/swap'

mkswap /var/swap/swapfile
swapon /var/swap/swapfile
grep -q /var/swap/swapfile /etc/fstab || echo '/var/swap/swapfile swap swap sw 0 0' >> /etc/fstab

# Disable zram (allow this to fail for the running system)
# echo "# disable zram-generator-defaults config in favor of zswap on Apple systems with swap" >/etc/systemd/zram-generator.conf
# systemctl stop systemd-zram-setup@zram0.service || true

# If we got this far, disable it for good measure (even though it should not run again)
systemctl disable setup-swap.service