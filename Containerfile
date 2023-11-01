# This is the Containerfile for your custom image.

# Instead of adding RUN statements here, you should consider creating a script
# in `config/scripts/`. Read more in `modules/script/README.md`

# This Containerfile takes in the recipe, version, and base image as arguments,
# all of which are provided by build.yml when doing builds
# in the cloud. The ARGs have default values, but changing those
# does nothing if the image is built in the cloud.

# !! Warning: changing these might not do anything for you. Read comment above.
ARG IMAGE_MAJOR_VERSION=38
ARG BASE_IMAGE_URL=ghcr.io/ublue-os/silverblue-main

FROM ghcr.io/ublue-os/akmods:main-${IMAGE_MAJOR_VERSION} as akmods-rpms

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

# Gnome mutter triple buffer patch
RUN curl -L https://copr.fedorainfracloud.org/coprs/trixieua/mutter-patched/repo/fedora-${IMAGE_MAJOR_VERSION}/trixieua-mutter-patched-fedora-${IMAGE_MAJOR_VERSION}.repo -o /etc/yum.repos.d/trixieua-mutter-patched-fedora-${IMAGE_MAJOR_VERSION}.repo && \
    rpm-ostree override replace --experimental --from repo=copr:copr.fedorainfracloud.org:trixieua:mutter-patched mutter mutter-common

# Expressvpn
RUN RELEASE=$(curl -L https://www.expressvpn.com/vn/latest\#linux | grep 'Fedora 64') && \
    download_url=$(echo "$RELEASE" | grep -m 1 -oP '(?<=value=")(.+)(?=")') && \
    curl -L "$download_url" -o /tmp/expressvpn.rpm && \
    rpm-ostree install /tmp/expressvpn.rpm && \
    rm /tmp/expressvpn.rpm /etc/yum.repos.d/expressvpn.repo

# Run the build script, then clean up temp files and finalize container build.
RUN chmod +x /tmp/build.sh && /tmp/build.sh && \
    rm -rf /usr/lib/fontconfig/cache && fc-cache -r && \
    rm -rf /tmp/* /var/* && ostree container commit
