#!/bin/bash
# Run a bug's reproducer against a built checkout and compare with the recorded clean output.
# Prints CLEAN (exit 0) when output and exit status match the clean build, BUG (exit 1) otherwise.
# usage: bin/check_repro.sh DIR BUG
set -o pipefail
HERE=$(cd "$(dirname "$0")/.." && pwd)
DIR=$(cd "$1" && pwd); B="$HERE/bugs/$2"
[ -f "$B/repro.sql" ] || { echo "no reproducer for $2"; exit 3; }
expected_status=$(cat "$B/repro.clean.status")
# run from a private writable root whose entries link to the checkout (data/, test/, ...), as the
# dataset harness did: files DuckDB creates in the working directory (e.g. .tmp) stay out of the checkout
T=$(mktemp -d); mkdir -p "$T/home" "$T/root"
shopt -s dotglob
for e in "$DIR"/*; do n=$(basename "$e"); case "$n" in build|.tmp|duckdb_unittest_tempdir) ;; *) ln -s "$e" "$T/root/$n";; esac; done
out=$(cd "$T/root" && env -i PATH=/usr/bin:/bin HOME="$T/home" LANG=C.UTF-8 LC_ALL=C.UTF-8 TZ=UTC \
      ASAN_OPTIONS=detect_leaks=0:abort_on_error=1:disable_coredump=1 UBSAN_OPTIONS=halt_on_error=1 \
      timeout 120 "$DIR/build/relassert/duckdb" -batch -init /dev/null -f "$B/repro.sql" :memory: 2>&1)
status=$?
norm=$(printf '%s' "$out" | sed -e "s#$T/root#<ROOT>#g" -e "s#$DIR#<ROOT>#g" -e "s#$T#<TMP>#g" -E -e 's/0x[0-9a-f]{6,}/0xADDR/g' -e 's/==[0-9]+==/==PID==/g')
rm -rf "$T"
if [ "$status" = "$expected_status" ] && [ "$norm" = "$(cat "$B/repro.clean.out")" ]; then
  echo CLEAN; exit 0
fi
echo "BUG (exit $status, expected $expected_status)"; exit 1
