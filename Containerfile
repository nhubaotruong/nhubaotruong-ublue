# This is the Containerfile for your custom image.

# Instead of adding RUN statements here, you should consider creating a script
# in `config/scripts/`. Read more in `modules/script/README.md`

# This Containerfile takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

# !! Warning: changing these might not do anything for you. Read comment above.
ARG IMAGE_MAJOR_VERSION=39
ARG FEDORA_MAJOR_VERSION=${IMAGE_MAJOR_VERSION}
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main
ARG NVIDIA_MAJOR_VERSION=545
ARG IMAGE_NAME="silverblue"

FROM ghcr.io/ublue-os/akmods:fsync-${IMAGE_MAJOR_VERSION} AS akmods-rpms
FROM ghcr.io/ublue-os/akmods-nvidia:fsync-${IMAGE_MAJOR_VERSION}-${NVIDIA_MAJOR_VERSION} as akmods-nvidia-rpms

FROM ${BASE_IMAGE_URL}:${IMAGE_MAJOR_VERSION}

# The default recipe is set to the recipe's default filename
# so that `podman build` should just work for most people.
ARG RECIPE=recipe.yml
# The default image registry to write to policy.json and cosign.yaml
ARG IMAGE_REGISTRY=ghcr.io/ublue-os

COPY cosign.pub /usr/share/ublue-os/cosign.pub

# Copy the bling from ublue-os/bling into tmp, to be installed later by the bling module
# Feel free to remove these lines if you want to speed up image builds and don't want any bling
COPY --from=ghcr.io/ublue-os/bling:latest /rpms /tmp/bling/rpms
COPY --from=ghcr.io/ublue-os/bling:latest /files /tmp/bling/files

# Copy build scripts & configuration
COPY build.sh /tmp/build.sh
COPY config /tmp/config/

# Copy modules
# The default modules are inside ublue-os/bling
COPY --from=ghcr.io/ublue-os/bling:latest /modules /tmp/modules/
# Custom modules overwrite defaults
COPY modules /tmp/modules/

# `yq` is used for parsing the yaml configuration
# It is copied from the official container image since it's not available as an RPM.
COPY --from=docker.io/mikefarah/yq /usr/bin/yq /usr/bin/yq

RUN wget https://copr.fedorainfracloud.org/coprs/kylegospo/bazzite-multilib/repo/fedora-$(rpm -E %fedora)/kylegospo-bazzite-multilib-fedora-$(rpm -E %fedora).repo?arch=x86_64 -O /etc/yum.repos.d/_copr_kylegospo-bazzite-multilib.repo

# Install kernel-fsync
RUN wget https://copr.fedorainfracloud.org/coprs/sentry/kernel-fsync/repo/fedora-$(rpm -E %fedora)/sentry-kernel-fsync-fedora-$(rpm -E %fedora).repo -O /etc/yum.repos.d/_copr_sentry-kernel-fsync.repo && \
    rpm-ostree cliwrap install-to-root / && \
    rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:sentry:kernel-fsync \
    kernel \
    kernel-core \
    kernel-modules \
    kernel-modules-core \
    kernel-modules-extra \
    kernel-uki-virt

# Update packages that commonly cause build issues.
RUN rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    vulkan-loader \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    gnutls \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    glib2 \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    gtk3 \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    atk \
    at-spi2-atk \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libaom \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    gstreamer1 \
    gstreamer1-plugins-base \
    gstreamer1-plugins-bad-free-libs \
    gstreamer1-plugins-good-qt \
    gstreamer1-plugins-good \
    gstreamer1-plugins-bad-free \
    gstreamer1-plugin-libav \
    gstreamer1-plugins-ugly-free \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    python3 \
    python3-libs \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libdecor \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libtirpc \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libuuid \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libblkid \
    || true && \
    rpm-ostree override replace \
    --experimental \
    --from repo=updates \
    libmount \
    || true && \
    rpm-ostree override remove \
    glibc32 \
    || true

# Akmods
COPY --from=akmods-rpms /rpms /tmp/akmods-rpms
RUN sed -i 's@enabled=0@enabled=1@g' /etc/yum.repos.d/_copr_ublue-os-akmods.repo && \
    wget https://negativo17.org/repos/fedora-multimedia.repo -O /etc/yum.repos.d/negativo17-fedora-multimedia.repo && \
    rpm-ostree install \
    /tmp/akmods-rpms/kmods/kmod-v4l2loopback*.rpm \
    /tmp/akmods-rpms/kmods/kmod-xone*.rpm \
    /tmp/akmods-rpms/kmods/kmod-xpadneo*.rpm \
    /tmp/akmods-rpms/kmods/kmod-evdi*.rpm \
    /tmp/akmods-rpms/kmods/kmod-openrazer*.rpm && \
    sed -i 's@enabled=1@enabled=0@g' /etc/yum.repos.d/negativo17-fedora-multimedia.repo

# Install NVIDIA driver
COPY --from=akmods-nvidia-rpms /rpms /tmp/akmods-rpms
RUN wget https://raw.githubusercontent.com/ublue-os/nvidia/main/install.sh -O /tmp/nvidia-install.sh && \
    wget https://raw.githubusercontent.com/ublue-os/nvidia/main/post-install.sh -O /tmp/nvidia-post-install.sh && \
    chmod +x /tmp/nvidia-install.sh && IMAGE_NAME="${BASE_IMAGE_NAME}" /tmp/nvidia-install.sh && \
    chmod +x /tmp/nvidia-post-install.sh && IMAGE_NAME="${BASE_IMAGE_NAME}" /tmp/nvidia-post-install.sh

# Flatpak remote
RUN mkdir -p /usr/etc/flatpak/remotes.d && \
    wget -q https://dl.flathub.org/repo/flathub.flatpakrepo -P /usr/etc/flatpak/remotes.d

COPY config/files/etc/yum.repos.d/ /etc/yum.repos.d/

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    fc-cache -sf && \
    rm -rf /tmp/* /var/* && ostree container commit
