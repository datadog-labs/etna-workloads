#!/bin/bash
# Inject a bug into a v2.0.0 checkout (then rebuild with bin/build.sh).   usage: bin/apply_bug.sh DIR BUG
set -eo pipefail
HERE=$(cd "$(dirname "$0")/.." && pwd)
git -C "$1" apply --whitespace=nowarn "$HERE/bugs/$2/injection.patch" && echo "applied $2"
