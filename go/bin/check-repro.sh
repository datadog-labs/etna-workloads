#!/bin/bash
# Run a bug's reproducer with the toolchain in GOROOT and compare it with
# clean 1.27.3. Toolchain, work-directory and go temporary paths are replaced
# with placeholders first, as when the expected output was recorded.
# Exit 0: same as clean (bug not observed); 1: different (bug observed);
# 2: no reproducer for this bug.
#   bin/check-repro.sh <bug-id> <goroot>
set -u
here="$(cd "$(dirname "$0")/.." && pwd)"
d="$here/bugs/$1"; goroot="$(cd "$2" && pwd)"
[ -f "$d/repro.go" ] || [ -f "$d/repro.sh" ] || { echo "no standalone reproducer for $1 (see oracle.json)"; exit 2; }
tmp="$(mktemp -d)"; trap 'rm -rf "$tmp"' EXIT
cp "$d"/repro.go "$d"/repro.sh "$tmp"/ 2>/dev/null
cd "$tmp"
# One build cache per compiler binary (a release toolchain keys the cache on
# its version string, so clean and injected compilers would share entries).
cid="$(cat "$goroot"/pkg/tool/*/compile | sha256sum | cut -c1-16)"
export GO="$goroot/bin/go" PATH="$goroot/bin:$PATH" GOTOOLCHAIN=local GOFLAGS= GOCACHE="$goroot/.etna-gocache/$cid" GOPATH="$tmp/.gopath"
if [ -f repro.sh ]; then out="$(timeout --kill-after=5 120 bash repro.sh 2>&1)"; st=$?
else out="$(timeout --kill-after=5 120 "$GO" run -trimpath repro.go 2>&1)"; st=$?; fi
[ "$st" = 124 ] && st=timeout && out="$out
[timeout]"
[ "$st" != timeout ] && [ "$st" -gt 128 ] 2>/dev/null && st=$((128 - st))
out="$(printf '%s' "$out" | sed -e "s#$goroot#\$GOROOT#g" -e "s#$tmp#\$WORK#g" -E -e 's#/tmp/go-build[0-9]+#$TMP#g')"
if [ "$out" = "$(cat "$d/expected.txt")" ] && [ "$st" = "$(cat "$d/expected-status.txt")" ]; then
  echo "same as clean 1.27.3"; exit 0
fi
echo "differs from clean 1.27.3 (exit status $st):"; printf '%s\n' "$out" | tail -20; exit 1
