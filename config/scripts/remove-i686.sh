#!/usr/bin/env bash

# Tell build process to exit if there are any errors.
set -oue pipefail

i686_packages=$(rpm -qa | grep 'i686$' | tr '\n' ' ')

rpm-ostree override remove "$i686_packages"
