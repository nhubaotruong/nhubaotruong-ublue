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
    args=(rd.luks.options=discard,tpm2-device=auto nowatchdog quiet cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1 cryptomgr.notests initcall_debug intel_iommu=igfx_off kvm-intel.nested=1 no_timer_check noreplace-smp page_alloc.shuffle=1 rcupdate.rcu_expedited=1 rootfstype=ext4,btrfs,xfs,f2fs tsc=reliable init_on_alloc=1 init_on_free=1 random.trust_cpu=on randomize_kstack_offset=1)
    sudo rpm-ostree kargs $(printf -- "--append-if-missing=%s " ${args[*]})

enable-initramfs:
    #!/usr/bin/env bash
    args=(--force-add tpm2-tss --zstd --parallel)
    sudo rpm-ostree initramfs --enable $(printf -- "--arg=%s " ${args[*]})