#!/bin/bash
# Make a Marauders project out of Go 1.27.3 and this workload's bugs.
#   bin/setup.sh <dest>
# Then build the toolchain (cd src && GOROOT_BOOTSTRAP=<go >= 1.24> ./make.bash)
# and use marauders list|set|unset --path . [--variant go_<id>]; after each
# set/unset, rebuild the compiler with bin/go install cmd/compile.
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi
git clone --quiet --depth 1 --branch go1.27.3 https://github.com/golang/go.git "$dest"
rm -rf "$dest/.git"
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "Go 1.27.3 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
