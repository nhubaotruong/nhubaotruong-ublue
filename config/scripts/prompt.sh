#!/usr/bin/env bash

# Tell build process to exit if there are any errors.

fedora_version="$(rpm -E %fedora)"
wget "https://copr.fedorainfracloud.org/coprs/kylegospo/prompt/repo/fedora-$fedora_version/kylegospo-prompt-fedora-$fedora_version.repo?arch=x86_64" -O /etc/yum.repos.d/_copr_kylegospo-prompt.repo
rpm-ostree override replace \
    --experimental \
    --from repo=copr:copr.fedorainfracloud.org:kylegospo:prompt \
    vte291 \
    vte-profile \
    libadwaita
rpm-ostree install ptyxis
