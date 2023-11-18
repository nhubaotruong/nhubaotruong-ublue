ARG IMAGE_MAJOR_VERSION=38
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main

FROM ghcr.io/ublue-os/akmods:main-${IMAGE_MAJOR_VERSION} as akmods-rpms

FROM ${BASE_IMAGE_URL}:${IMAGE_MAJOR_VERSION}

ARG RECIPE=recipe.yml
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

COPY --from=ghcr.io/ublue-os/bling:latest /rpms /tmp/bling/rpms
COPY --from=ghcr.io/ublue-os/bling:latest /files /tmp/bling/files
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq
COPY build.sh /tmp/build.sh
COPY config /tmp/config/
COPY cosign.pub /usr/share/ublue-os/cosign.pub
COPY config/files/ /

# Akmods
COPY --from=akmods-rpms /rpms /tmp/akmods-rpms
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    wget https://negativo17.org/repos/fedora-multimedia.repo -O /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    rpm-ostree install \
    /tmp/akmods-rpms/kmods/kmod-v4l2loopback*.rpm \
    /tmp/akmods-rpms/kmods/kmod-winesync*.rpm \
    /tmp/akmods-rpms/kmods/kmod-xone*.rpm \
    /tmp/akmods-rpms/kmods/kmod-xpad-noone*.rpm \
    /tmp/akmods-rpms/kmods/kmod-xpadneo*.rpm \
    /tmp/akmods-rpms/kmods/kmod-openrazer*.rpm && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# Repos
RUN wget https://copr.fedorainfracloud.org/coprs/atim/starship/repo/fedora-$(rpm -E %fedora)/atim-starship-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/repo/fedora-$(rpm -E %fedora)/trixieua-mutter-patched-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/distrobox-git/repo/fedora-$(rpm -E %fedora)/ublue-os-distrobox-git-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/hl2linux-selinux/repo/fedora-$(rpm -E %fedora)/kylegospo-hl2linux-selinux-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/kylegospo/system76-scheduler/repo/fedora-$(rpm -E %fedora)/kylegospo-system76-scheduler-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/staging/repo/fedora-$(rpm -E %fedora)/ublue-os-staging-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://copr.fedorainfracloud.org/coprs/ublue-os/bling/repo/fedora-$(rpm -E %fedora)/ublue-os-bling-fedora-$(rpm -E %fedora).repo -P /etc/yum.repos.d && \
    wget https://download.opensuse.org/repositories/home:lamlng/Fedora_$(rpm -E %fedora)/home:lamlng.repo -P /etc/yum.repos.d && \
    wget https://pkgs.tailscale.com/stable/fedora/tailscale.repo -P /etc/yum.repos.d && \
    mkdir -p /usr/etc/flatpak/remotes.d && \
    wget -q https://dl.flathub.org/repo/flathub.flatpakrepo -P /usr/etc/flatpak/remotes.d

# Remove packages
RUN rpm-ostree override remove \
    firefox \
    firefox-langpacks \
    power-profiles-daemon \
    yelp \
    gnome-tour \
    toolbox \
    distrobox \
    gnome-software \
    gnome-software-rpm-ostree \
    zram-generator-defaults \
    gnome-classic-session \
    gnome-terminal \
    gnome-terminal-nautilus

# Install packages
RUN rpm-ostree install \
    starship \
    tilix \
    tilix-nautilus \
    gnome-tweaks \
    file-roller \
    tlp \
    lz4 \
    xz \
    zstd \
    ibus-bamboo \
    tailscale \
    dconf-editor \
    gnome-screenshot \
    breeze-cursor-theme \
    i2c-tools \
    ddcutil \
    virt-manager \
    libvirt \
    edk2-ovmf \
    powertop \
    p7zip \
    p7zip-plugins \
    unrar \
    bsdcat \
    bsdcpio \
    bsdtar \
    bsdunzip \
    ffmpegthumbnailer \
    zram-generator \
    zsh \
    igt-gpu-tools \
    libgda \
    libgda-sqlite \
    firewall-config \
    dejavu-sans-fonts \
    dejavu-serif-fonts \
    lsd \
    minizip-compat \
    minizip-ng \
    qt5-qtquickcontrols \
    distrobox-git \
    system76-scheduler \
    hl2linux-selinux \
    python3-psutil \
    libnotify \
    binutils \
    libadwaita-devel \
    pygobject3-devel \
    liberation-fonts \
    ufraw \
    duperemove \
    rmlint \
    python3-icoextract \
    gnome-directory-thumbnailer \
    gnome-epub-thumbnailer \
    gnome-kra-ora-thumbnailer \
    gnome-shell-extension-appindicator \
    gnome-shell-extension-gsconnect \
    gnome-shell-extension-user-theme \
    gnome-shell-extension-dash-to-dock \
    gnome-shell-extension-drive-menu \
    gnome-shell-extension-just-perfection \
    gnome-shell-extension-caffeine \
    gnome-shell-extension-supergfxctl-gex \
    gnome-shell-extension-system76-scheduler

# Replace packages
RUN rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched mutter mutter-common

RUN chmod -R +x /tmp/config/scripts
# Microsoft Fonts
RUN eval /tmp/config/scripts/microsoft-fonts.sh

# Teamviewer
RUN eval /tmp/config/scripts/teamviewer.sh

# Expressvpn
RUN eval /tmp/config/scripts/expressvpn.sh

# Mdatp
RUN eval /tmp/config/scripts/mdatp.sh

# Nanorc
RUN eval /tmp/config/scripts/nanorc.sh

# Papirus icon theme
RUN eval /tmp/config/scripts/papirus-icon-theme.sh

# Nerd fonts
RUN eval /tmp/config/scripts/nerd-fonts.sh

# Bazzite
RUN wget https://raw.githubusercontent.com/scaronni/steam-proton-mf-wmv/master/installcab.py -O /usr/bin/installcab && \
    chmod +x /usr/bin/installcab && \
    wget https://github.com/scaronni/steam-proton-mf-wmv/blob/master/install-mf-wmv.sh -O /usr/bin/install-mf-wmv && \
    chmod +x /usr/bin/install-mf-wmv && \
    sed -i 's@python3 installcab.py@/usr/bin/installcab@g' /usr/bin/install-mf-wmv && \
    wget https://raw.githubusercontent.com/jlu5/icoextract/master/exe-thumbnailer.thumbnailer -O /usr/share/thumbnailers/exe-thumbnailer.thumbnailer && \
    wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/main/files/usr/lib/systemd/system/btrfs-dedup@.service -O /usr/lib/systemd/system/btrfs-dedup@.service && \
    wget https://gitlab.com/popsulfr/steamos-btrfs/-/raw/main/files/usr/lib/systemd/system/btrfs-dedup@.timer -O /usr/lib/systemd/system/btrfs-dedup@.timer

# Enable services
RUN systemctl enable tlp.service \
    supergfxd.service \
    tailscaled.service \
    fstrim.timer \
    com.system76.Scheduler.service \
    btrfs-dedup@var-home.timer

# Disable services
RUN systemctl disable raid-check.timer

RUN IMAGE_INFO="/usr/share/ublue-os/image-info.json" && \
    if [ -f "$IMAGE_INFO" ]; then rm -v "$IMAGE_INFO"; fi && \
    eval /tmp/config/scripts/signing.sh && \
    restorecon -vFr / && \
    fc-cache -sf && \
    rm -rf /tmp/* /var/* && ostree container commit