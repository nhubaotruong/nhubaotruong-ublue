#!/usr/bin/env bash

for module_dir in /usr/lib/modules/*; do
    if [ -d "$module_dir" ]; then
        echo "Running depmod on $module_dir"
        depmod -a -v "$(basename "$module_dir")" 2>/dev/null || echo "Ignored error for $module_dir"
    fi
done
