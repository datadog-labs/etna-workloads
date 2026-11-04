#!/bin/bash
# Make a Marauders project out of DataFusion 55.2.0 and this workload's bugs.
#   bin/setup.sh <dest>
# The test-data submodules are included (the .slt oracles need them). Then
# use marauders list|set|unset --path <dest> [--variant datafusion_<id>];
# the check scripts rebuild what changed.
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch 55.2.0 --recurse-submodules --shallow-submodules \
  https://github.com/apache/datafusion.git "$dest"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "DataFusion 55.2.0 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
