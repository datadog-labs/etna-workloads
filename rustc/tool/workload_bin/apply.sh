#!/bin/bash
# Inject a bug.   usage: bin/apply.sh DIR BUG      (BUG = directory name under bugs/)
set -eu
HERE=$(cd "$(dirname "$0")/.." && pwd)
git -C "${1:?DIR}" apply "$HERE/bugs/${2:?BUG}/injection.patch" && echo "applied $2"
