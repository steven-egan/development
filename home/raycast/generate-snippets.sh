#!/usr/bin/env bash
set -euo pipefail

dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
env_file="$dir/../../.env"
output="$dir/snippets.generated.json"

command -v jq >/dev/null || { echo "jq is required to generate Raycast snippets." >&2; exit 1; }
[[ -f "$env_file" ]] || env_file=/dev/null

umask 077
temporary=$(mktemp "${output}.XXXXXX")
trap 'rm -f "$temporary"' EXIT
jq --rawfile env "$env_file" -f "$dir/render.jq" "$dir/template.json" > "$temporary"
mv -f "$temporary" "$output"
echo "Generated $output; import it using Raycast's Import Snippets command."
