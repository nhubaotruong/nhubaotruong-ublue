#!/usr/bin/env bash

set -oeux pipefail

rpm-ostree kargs \
        --append=rd.driver.blacklist=nouveau \
        --append=modprobe.blacklist=nouveau \
        --append=nvidia-drm.modeset=1 \
        --append=random.trust_cpu=on \
        --append=cryptomgr.notests \
        --append=intel_iommu=igfx_off \
        --append=kvm-intel.nested=1 \
        --append=no_timer_check \
        --append=noreplace-smp \
        --append=page_alloc.shuffle=1 \
        --append=rcupdate.rcu_expedited=1 \
        --append=rootfstype=ext4,btrfs,xfs,f2fs \
        --append=tsc=reliable \
        --append=zswap.compressor=lz4 \
        --append=zswap.zpool=z3fold \
        --append=quiet \
        --append=loglevel=3