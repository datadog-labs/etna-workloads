#!/bin/sh
# usage: bin/check-tests.sh TREE BUG
# Runs BUG's oracle tests (twice) on the built TREE.
# Prints "BUG DETECTED" and exits 1 if a test listed as failing for BUG fails in both runs;
# prints "CLEAN" and exits 0 if all oracle tests pass in both runs; exits 2 otherwise.
set -u
. "$(dirname "$0")/common.sh"
D=$(bug_dir "${2:?usage: check-tests.sh TREE BUG}")
T=$(cd "${1:?}" && pwd)
units=$(python3 -c "import json,sys;print(' '.join(json.load(open(sys.argv[1]))['oracle']))" "$D/oracle.json")
failing=$(python3 -c "import json,sys;print(' '.join(json.load(open(sys.argv[1]))['failing']))" "$D/oracle.json")
tmp=$(mktemp -d)
run() {  # run unit -> prints passed|failed|...
  d=$(mktemp -d "$tmp/ot.XXXXXX")
  out=$(cd "$T/testsuite" && SORT=sort MAKE=make TERM=dumb USE_RUNTIME=d OCAMLRUNPARAM=v=0 \
        OCAMLTESTDIR="$d" TMPDIR="$d" timeout 900 ../ocamltest/ocamltest -timeout 300 "$1" 2>&1)
  b=$(basename "$1")
  echo "$out" | sed -n "s/^ \.\.\. testing '$b' => \([a-z ]*\).*/\1/p" | tail -1 | grep . || echo no-result
}
allpass=1; detected=0
for u in $units; do
  r1=$(run "$u"); r2=$(run "$u")
  echo "$u: $r1 / $r2"
  [ "$r1" = passed ] && [ "$r2" = passed ] || allpass=0
  case " $failing " in *" $u "*)
    [ "$r1" != passed ] && [ "$r2" != passed ] && detected=1;;
  esac
done
rm -rf "$tmp"
if [ $detected = 1 ]; then echo "BUG DETECTED"; exit 1; fi
if [ $allpass = 1 ]; then echo "CLEAN"; exit 0; fi
echo "INCONCLUSIVE"; exit 2
