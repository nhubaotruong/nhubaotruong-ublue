#!/usr/bin/sh
set -eu

size=12G

if [ "$(id -u)" -ne 0 ]; then
    echo "Script must be run as root" >&2
    exit 1
fi

if [ "${1:-}" = "--recreate" ]; then
    shift
    swapoff /var/swap/swapfile 2>/dev/null || true
    rm -f /var/swap/swapfile
elif [ -e /var/swap/swapfile ]; then
    echo "/var/swap/swapfile already exists, use --recreate to recreate" >&2
    exit 1
fi

[ -n "${1:-}" ] && size="$1"

# IEC suffix interpretation (G=GiB) matches fallocate semantics.
if ! size_bytes="$(numfmt --from=iec "$size" 2>/dev/null)"; then
    echo "Invalid size: $size" >&2
    exit 1
fi

[ ! -e /var/swap ] && mkdir -p /var/swap

free_bytes="$(($(stat -f --format='%a*%S' /var/swap)))"
if [ "$free_bytes" -lt "$size_bytes" ]; then
    echo "Not enough free space on /var: have ${free_bytes}B, need ${size_bytes}B" >&2
    exit 1
fi

fallocate -l "$size" /var/swap/swapfile
chmod 0600 /var/swap/swapfile

semanage fcontext -a -t var_t -f d '/var/swap' 2>/dev/null || true
semanage fcontext -a -t swapfile_t -f f '/var/swap/swapfile' 2>/dev/null || true
restorecon -v -r '/var/swap'

mkswap /var/swap/swapfile
swapon /var/swap/swapfile
grep -q '^/var/swap/swapfile ' /etc/fstab || echo '/var/swap/swapfile swap swap sw 0 0' >> /etc/fstab

# If we got this far, disable it for good measure (even though it should not run again)
systemctl disable setup-swap-ext4.service
