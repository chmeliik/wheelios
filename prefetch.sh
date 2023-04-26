#!/bin/bash
set -o errexit -o nounset -o pipefail -o xtrace

dir=${1:-'.'}
appname=$(basename "$(realpath "$dir")")
output_dir=/tmp/cachi2-$appname

cachi2 fetch-deps --source "$dir" --output "$output_dir" "$(cat "input/$appname.json")"
