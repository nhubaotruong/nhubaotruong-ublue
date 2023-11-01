#!/bin/bash
container_list=$(podman ps -a --no-trunc --format "{{.Names}}|{{.Mounts}}")
IFS='
'
for container in ${container_list}; do
    if [ -z "${container##*distrobox*}" ]; then
        container_name="$(printf "%s" "${container}" | cut -d'|' -f1)"
        distrobox enter -n "$container_name" -- echo
    fi
done
