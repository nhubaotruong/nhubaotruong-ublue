#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

rpm-ostree override replace \
    --experimental \
    --freeze \
    --from repo=copr:copr.fedorainfracloud.org:ublue-os:staging \
    mutter \
    mutter-common
