# Include some of your custom scripts here!

# Remove all waydroid-related files in your user folders
reset-waydroid:
    bash -c 'sudo rm -rf /var/lib/waydroid /home/.waydroid ~/waydroid ~/.share/waydroid ~/.local/share/applications/*aydroid* ~/.local/share/waydroid'

# Quickly initialize a waydroid image
init-waydroid:
    #!/usr/bin/env bash
    sudo waydroid init -c 'https://ota.waydro.id/system' -v 'https://ota.waydro.id/vendor'

# Launch Waydroid configuration helper
configure-waydroid:
    #!/usr/bin/env bash
    git clone https://github.com/casualsnek/waydroid_script.git --depth 1 /tmp/waydroid_script
    python -m venv /tmp/waydroid_script/venv
    source /tmp/waydroid_script/venv/bin/activate
    sudo pip install -r /tmp/waydroid_script/requirements.txt
    sudo /tmp/waydroid_script/main.py
    deactivate
    sudo rm -rf /tmp/waydroid_script

set-kernel-arguments:
    #!/usr/bin/env bash
    # mirrors the active kargs in recipes/recipe.yml - updated 2026-09: dropped init_on_free,
    # rcupdate.rcu_expedited, noreplace_smp, cgroup_no_v1, kvm-intel.nested, kvm.ignore_msrs,
    # pcie_aspm=force and zswap.zpool (see the recipe comments for why)
    args=(rd.luks.options=discard,tpm2-device=auto,no-read-workqueue,no-write-workqueue nowatchdog quiet cryptomgr.notests intel_iommu=igfx_off no_timer_check page_alloc.shuffle=1 rootfstype=ext4,btrfs,xfs,f2fs clocksource=tsc tsc=reliable init_on_alloc=1 randomize_kstack_offset=1 preempt=full rd.shell=0 rd.emergency=halt zswap.enabled=1 zswap.shrinker_enabled=1 zswap.max_pool_percent=15 zswap.compressor=lz4 rcutree.enable_rcu_lazy=1 workqueue.power_efficient=1 nosoftlockup transparent_hugepage=madvise rcu_nocbs=all)
    sudo rpm-ostree kargs $(printf -- "--append-if-missing=%s " ${args[*]})

# harden-flatpak:
#     flatpak override --user --filesystem=host-os:ro --env=LD_PRELOAD=/var/run/host/usr/lib64/libhardened_malloc-light.so