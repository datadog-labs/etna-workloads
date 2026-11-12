#!/bin/bash
# Run a bug's failing oracle cases with the unittest binary of a built checkout.
# Prints BUG (exit 1) if any case fails, CLEAN (exit 0) if all pass.   usage: bin/check_tests.sh DIR BUG
set -o pipefail
HERE=$(cd "$(dirname "$0")/.." && pwd)
DIR=$(cd "$1" && pwd); B="$HERE/bugs/$2"
fail=0
while IFS= read -r unit; do
  [ -z "$unit" ] && continue
  case "$unit" in
    cpp:*) spec=$(printf '%s' "${unit#*::}" | sed -E 's/([][\\,"*~^])/\\\1/g');;
    *) spec=$unit;;
  esac
  T=$(mktemp -d)
  (cd "$DIR" && env -i PATH=/usr/bin:/bin HOME="$T" LANG=C.UTF-8 TZ=UTC ASAN_OPTIONS=detect_leaks=0:abort_on_error=1 \
     timeout 900 ./build/relassert/test/unittest --temp-dir-root "$T/tmp" "$spec" >"$T/log" 2>&1)
  rc=$?
  if [ $rc -eq 0 ] && grep -q "All tests passed" "$T/log"; then echo "pass  $unit"; else echo "FAIL  $unit (rc=$rc)"; fail=1; fi
  rm -rf "$T"
done < <(python3 -c "import json,sys;[print(u) for u in json.load(open(sys.argv[1]))['failing']]" "$B/oracle.json")
[ $fail = 1 ] && { echo BUG; exit 1; }
echo CLEAN; exit 0
