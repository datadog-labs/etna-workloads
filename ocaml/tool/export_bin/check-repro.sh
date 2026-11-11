#!/bin/sh
# usage: bin/check-repro.sh TREE BUG
# Installs the built TREE into its configured prefix (TREE/_inst), runs BUG's reproducer
# and compares with the recorded clean/buggy outputs.
# Prints "BUG DETECTED" (exit 1) if the buggy behaviour is observed, "CLEAN" (exit 0) if
# the clean behaviour is observed, "UNEXPECTED" (exit 2) otherwise.
set -u
. "$(dirname "$0")/common.sh"
D=$(bug_dir "${2:?usage: check-repro.sh TREE BUG}")
[ -f "$D/reproducer/repro.sh" ] || { echo "no verified reproducer for $2" >&2; exit 3; }
T=$(cd "${1:?}" && pwd)
P="$T/_inst"
(cd "$T" && rm -rf "$P" && make install > _install.log 2>&1) || { echo "install failed" >&2; exit 3; }
w=$(mktemp -d); cp -r "$D/reproducer/." "$w/r"; mkdir "$w/tmp"
out=$(cd "$w" && env -i PATH=/usr/bin:/bin HOME="$w" TMPDIR="$w/tmp" LANG=C sh "$w/r/repro.sh" "$P" 2>&1); rc=$?
out=$(printf '%s' "$out" | sed "s#$P#<P>#g; s#$w#<P>#g")
rm -rf "$w"
got=$(printf '%s\nexit=%s\n' "$out" "$rc")
clean=$(cat "$D/reproducer/expected-clean.txt")
clean_rc=$(printf '%s\n' "$clean" | sed -n 's/^exit=//p' | tail -1)
# Same criterion as the harness that verified the reproducer: the clean build gives the recorded
# (deterministic) clean output; the bug shows as different output AND a different exit status.
# (Buggy output itself need not match byte for byte: e.g. crash messages from the shell and from
# `timeout` can interleave in either order.)
if [ "$got" = "$clean" ]; then echo "CLEAN"; exit 0; fi
if [ "$rc" != "$clean_rc" ]; then echo "BUG DETECTED"; exit 1; fi
printf 'UNEXPECTED output:\n%s\n' "$got"; exit 2
