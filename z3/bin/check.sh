#!/bin/bash
# Check the CURRENT build for one bug. Usage: check.sh BUG [repro|tests|both]
# Prints BUG or CLEAN per method; exit 0 = all methods report CLEAN, 1 = some method reports BUG, 2 = error.
source "$(dirname "$0")/common.sh"
b=$(bugdir "$1"); mode=${2:-both}
tmp=$(mktemp -d); trap 'rm -rf "$tmp"' EXIT
norm() { sed -E 's#/[^ :"]*/src/src/#<SRC>/src/#g'; }
verdict=0
if [ "$mode" != tests ]; then
  if [ -f "$b/repro.smt2" ]; then
    cp "$b/repro.smt2" "$tmp/in.smt2"
    set +e; ( cd "$tmp" && limited 30 "$BUILD/z3" in.smt2 < /dev/null > out.txt 2>&1 ); rc=$?; set -e
    [ $rc -eq 137 ] && rc=timeout
    { norm < "$tmp/out.txt"; echo "exit=$rc"; } > "$tmp/got"
    if cmp -s "$tmp/got" "$b/repro.expected.clean"; then echo "repro: CLEAN"; else echo "repro: BUG"; verdict=1; fi
  else
    echo "repro: (none for this bug)"
  fi
fi
if [ "$mode" != repro ]; then
  for u in $(python3 -c "import json,sys; print(' '.join(json.load(open(sys.argv[1]))['failing']))" "$b/oracle.json"); do
    mkdir -p "$tmp/u"; set +e
    case $u in
      z3test:*) f="$b/z3test/${u#z3test:}"; cp "$f" "$tmp/u/in.smt2"
        ( cd "$tmp/u" && limited 120 "$BUILD/z3" model_validate=true in.smt2 < /dev/null > out.txt 2>&1 ); rc=$?
        { [ $rc -le 1 ] || [ $rc -eq 105 ]; } && cmp -s "$tmp/u/out.txt" "${f%.smt2}.expected.out"; ok=$? ;;
      *) ( cd "$tmp/u" && limited 1200 "$BUILD/test-z3" "$u" < /dev/null > out.txt 2>&1 ); rc=$?
        [ $rc -eq 0 ] && grep -qx PASS "$tmp/u/out.txt"; ok=$? ;;
    esac
    set -e; rm -rf "$tmp/u"
    if [ $ok -eq 0 ]; then echo "test $u: CLEAN"; else echo "test $u: BUG"; verdict=1; fi
  done
fi
exit $verdict
