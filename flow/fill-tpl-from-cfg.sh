#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(git rev-parse --show-toplevel)"

. "$ROOT_DIR/cfg.sh"

find "$ROOT_DIR" -type f -name "*.yaml.tpl" |
while read -r tpl
do
    out="${tpl%.tpl}"

    envsubst < "$tpl" > "$out"

    if grep -q '\${.*}' "$out"; then
        echo "ERROR: unresolved variable(s) in:"
        echo "file: $tpl"
        echo "  $out"
        exit 1
    fi
done