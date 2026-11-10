#!/bin/bash
# Create a worker slot: a real (writable) copy of the pristine release source,
# configured and built at its own fixed path.  Never copies a configured tree.
#   mkslot.sh <name> [fast]
# "fast" slots are built with --node-builtin-modules-path=<slot>, so lib/*.js is
# read from the slot's lib/ at run time (no snapshot, no code cache).
set -euo pipefail
W=${NODE_ETNA_WORK:-$HOME/node-etna-work}
name=$1; mode=${2:-real}
dir=$W/slots/$name
[ -e "$dir" ] && { echo "exists: $dir" >&2; exit 1; }
mkdir -p "$W/slots" "$W/logs"
cp -a "$W/pristine" "$dir"
chmod -R u+w "$dir"
export CCACHE_DIR=$W/ccache CCACHE_BASEDIR=$W CCACHE_NOHASHDIR=1
export CC="ccache gcc" CXX="ccache g++"
cd "$dir"
flags=(--debug-node)
[ "$mode" = fast ] && flags+=(--node-builtin-modules-path="$dir")
./configure "${flags[@]}" > "$W/logs/slot-$name-configure.log" 2>&1
start=$(date +%s)
make -j"${JOBS:-16}" > "$W/logs/slot-$name-build.log" 2>&1
make -j"${JOBS:-16}" -C out BUILDTYPE=Release cctest >> "$W/logs/slot-$name-build.log" 2>&1
make -j"${JOBS:-16}" build-ffi-tests build-addons build-js-native-api-tests build-node-api-tests \
  >> "$W/logs/slot-$name-build.log" 2>&1
echo "$name $mode built in $(( $(date +%s) - start ))s"
