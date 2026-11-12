#!/bin/bash
# Remove an injected bug (exact reversal of injection.patch).   usage: bin/revert_bug.sh DIR BUG
set -eo pipefail
HERE=$(cd "$(dirname "$0")/.." && pwd)
git -C "$1" apply -R --whitespace=nowarn "$HERE/bugs/$2/injection.patch" && echo "reverted $2"
