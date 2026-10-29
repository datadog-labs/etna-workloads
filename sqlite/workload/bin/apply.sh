#!/bin/bash
# Apply a bug's injection to an unmodified SQLite 3.54.1 source tree.
#   bin/apply.sh <bug-id> <sqlite-3.54.1-tree> [-R]   (-R removes it again)
set -eu
here="$(cd "$(dirname "$0")/.." && pwd)"
patch -p1 --batch ${3:-} -d "$2" < "$here/bugs/$1/injection.patch"
