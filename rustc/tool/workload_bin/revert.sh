#!/bin/bash
# Remove an injected bug.   usage: bin/revert.sh DIR BUG
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd)
git -C "${1:?DIR}" apply -R "$HERE/bugs/${2:?BUG}/injection.patch" && echo "reverted $2"
git -C "$1" diff --quiet -- compiler && echo "compiler/ matches 1.99.1"
