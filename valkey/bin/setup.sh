#!/bin/bash
# Make a Marauders project out of Valkey 9.0.7 and this workload's bugs.
#   bin/setup.sh <dest>
# Then, inside <dest>: marauders list|set|unset --path . [--variant valkey_<id>]
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch 9.0.7 https://github.com/valkey-io/valkey.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "Valkey 9.0.7 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
