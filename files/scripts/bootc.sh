#!/usr/bin/bash

if [ "$(rpm -E %fedora)" -eq "40" ]; then
    /usr/bin/bootupctl backend generate-update-metadata
fi
