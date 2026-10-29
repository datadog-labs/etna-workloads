#!/bin/bash
# Make a Marauders project out of SQLite 3.54.1 and this workload's bugs.
#
#   bin/setup.sh <dest>
#
# <dest> gets the SQLite 3.54.1 source (from the official git mirror), the
# bugs as Marauders patch variants (patches/sqlite_<id>.patch) and
# marauder.toml. Then, inside <dest>:
#
#   marauders list  --path .                         # 1 variant per bug
#   marauders set   --path . --variant sqlite_<id>   # inject one bug
#   marauders unset --path . --variant sqlite_<id>   # back to clean 3.54.1
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
dest="${1:?usage: bin/setup.sh <dest>}"
if [ -e "$dest" ]; then echo "$dest already exists" >&2; exit 1; fi

git clone --quiet --depth 1 --branch version-3.54.1 https://github.com/sqlite/sqlite.git "$dest"
rm -rf "$dest/.git"            # patch state is tracked by Marauders, not git
cp -R "$here/patches" "$dest/patches"
cp "$here/marauder.toml" "$dest/marauder.toml"
echo "SQLite 3.54.1 with $(ls "$dest/patches" | wc -l | tr -d ' ') bug variants in $dest"
