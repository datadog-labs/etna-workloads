#!/bin/bash
# Make a Marauders project out of CPython 3.15.2 and this workload's bugs.
#   bin/setup.sh <dest>
# Then, inside <dest>: marauders list|set|unset --path . [--variant cpython_<id>]
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch v3.15.2 https://github.com/python/cpython.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "CPython 3.15.2 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
