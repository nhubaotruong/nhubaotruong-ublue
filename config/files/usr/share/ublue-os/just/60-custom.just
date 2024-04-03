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
    args=(rd.luks.options=discard,tpm2-device=auto nowatchdog quiet cgroup_no_v1=all systemd.unified_cgroup_hierarchy=1 cryptomgr.notests intel_iommu=igfx_off kvm-intel.nested=1 no_timer_check noreplace-smp page_alloc_shuffle=1 rcupdate.rcu_expedited=1 tsc=reliable udev.log_level=3 mem_sleep_default=deep init_on_alloc=1 init_on_free=1 slab_nomerge page_alloc.shuffle=1 randomize_kstack_offset=on vsyscall=none lockdown=confidentiality random.trust_cpu=off random.trust_bootloader=off intel_iommu=on amd_iommu=on efi=disable_early_pci_dma iommu.passthrough=0 iommu.strict=1 nvme_core.default_ps_max_latency_us=0 mitigations=auto,nosmt)
    sudo rpm-ostree kargs $(printf -- "--append-if-missing=%s " ${args[*]})

enable-initramfs:
    #!/usr/bin/env bash
    args=(--force-add tpm2-tss --zstd --parallel)
    sudo rpm-ostree initramfs --enable $(printf -- "--arg=%s " ${args[*]})