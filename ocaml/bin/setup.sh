#!/bin/sh
# usage: bin/setup.sh TREE
# Clone OCaml at the release tag into TREE, configure (prefix TREE/_inst) and build it,
# as upstream CI configures it for its test runs.
set -eu
. "$(dirname "$0")/common.sh"
T=${1:?usage: setup.sh TREE}
[ -e "$T" ] && { echo "$T exists" >&2; exit 2; }
git clone -q --branch "$RELEASE" --depth 1 "$UPSTREAM" "$T"
T=$(cd "$T" && pwd)
cd "$T"
./configure $CONFIGURE_FLAGS --prefix="$T/_inst" > _configure.log 2>&1
"$(dirname "$0")/build.sh" "$T"
