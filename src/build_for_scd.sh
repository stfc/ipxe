#!/bin/bash

if [[ ! -z "$(git status --porcelain=1)" ]]; then
    echo ERROR: Working tree is dirty
    exit 1
fi

declare -A TARGETS
TARGETS["bios"]="bin/undionly.kpxe"
TARGETS["efi32"]="bin-i386-efi/ipxe.efi"
TARGETS["efi64"]="bin-x86_64-efi/ipxe.efi"

OUTPUT_DIR="bin/scd_builds"

version="$(git describe --tags --always --long --abbrev=1 --match "v*")"

nice make clean

for name in "${!TARGETS[@]}"; do
    target="${TARGETS[$name]}"
    rm -vf "$target"
    nice make "$target"

    dir="$OUTPUT_DIR/$name"
    mkdir -vp $dir

    cp -v "$target" "$dir/$(basename $target).$version"
done

echo "Output in $OUTPUT_DIR"
