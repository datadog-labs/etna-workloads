#!/bin/bash
# Run a bug's reproducer against the build in TREE (make MALLOC=libc there
# first) and compare it with clean 9.0.7. Exit 0: same as clean (bug not
# observed); 1: different (bug observed); 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <built-valkey-tree>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; tree="$(cd "$2" && pwd)"
[ -f "$d/repro.sh" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
port=$(python3 -c 'import socket; s=socket.socket(); s.bind(("127.0.0.1",0)); print(s.getsockname()[1])')
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cd "$tmp"
out="$(VALKEY_SERVER="$tree/src/valkey-server" VALKEY_CLI="$tree/src/valkey-cli" PORT=$port \
       timeout --kill-after=5 30 setsid bash "$d/repro.sh" 2>&1)"; st=$?
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
pkill -f -- "--port $port" 2>/dev/null
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 9.0.7"; exit 0
fi
echo "differs from clean 9.0.7 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1
