#!/bin/bash
set -o errexit -o nounset -o pipefail -o xtrace

dir=${1:-'.'}
appname=$(basename "$(realpath "$dir")")
output_dir=/tmp/cachi2-$appname

if [[ "${2:-''}" == -f ]]; then
    dockerfile=$3
else
    dockerfile=$dir/Dockerfile
fi

cleanup_on_exit () {
    if [[ -f "$dockerfile.cachi2" ]]; then
        rm "$dockerfile.cachi2"
    fi
    (cd "$dir"; git checkout .)
}
trap cleanup_on_exit EXIT

sed 's|^\s*run |RUN source /cachi2/cachi2.env \&\& \\\n    |i' "$dockerfile" |
    tee "$dockerfile.cachi2"

cachi2 generate-env "$output_dir" --for-output-dir /cachi2 -o "$output_dir/cachi2.env"
cachi2 inject-files "$output_dir" --for-output-dir /cachi2

podman build "$dir" \
    -f "$dockerfile.cachi2" \
    -t "cachi2-$appname" \
    -v "$output_dir:/cachi2:z" \
    --network none \
    --no-cache
