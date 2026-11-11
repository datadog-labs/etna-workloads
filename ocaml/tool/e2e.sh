#!/bin/sh
# End-to-end check of the exported workload from a fresh checkout of the release.
# usage: e2e.sh WORKDIR BUG...   (OCAML_UPSTREAM may point at a local mirror)
set -u
W=$1; shift
B=$HOME/ocaml-etna/workload/bin
T=$W/tree
rm -rf "$T"
echo "== setup $(date)"; "$B/setup.sh" "$T" || { echo SETUP-FAILED; exit 1; }
rc_name() { case $1 in 0) echo CLEAN;; 1) echo BUG;; *) echo "OTHER($1)";; esac; }
for bug in "$@"; do
  echo "===== $bug"
  hasrepro=0; [ -f "$HOME/ocaml-etna/workload/bugs/$bug/reproducer/repro.sh" ] && hasrepro=1
  "$B/check-tests.sh" "$T" "$bug" > "$W/$bug.clean-tests.log" 2>&1; a=$?
  r1=-; [ $hasrepro = 1 ] && { "$B/check-repro.sh" "$T" "$bug" > "$W/$bug.clean-repro.log" 2>&1; r1=$(rc_name $?); }
  "$B/apply.sh" "$T" "$bug" && "$B/build.sh" "$T" || echo "APPLY/BUILD FAILED"
  "$B/check-tests.sh" "$T" "$bug" > "$W/$bug.bug-tests.log" 2>&1; b=$?
  r2=-; [ $hasrepro = 1 ] && { "$B/check-repro.sh" "$T" "$bug" > "$W/$bug.bug-repro.log" 2>&1; r2=$(rc_name $?); }
  "$B/revert.sh" "$T" "$bug" && "$B/build.sh" "$T" || echo "REVERT/BUILD FAILED"
  pristine=$(cd "$T" && git status --porcelain --untracked-files=no | wc -l)
  "$B/check-tests.sh" "$T" "$bug" > "$W/$bug.revert-tests.log" 2>&1; c=$?
  r3=-; [ $hasrepro = 1 ] && { "$B/check-repro.sh" "$T" "$bug" > "$W/$bug.revert-repro.log" 2>&1; r3=$(rc_name $?); }
  echo "RESULT $bug tests: clean=$(rc_name $a) bug=$(rc_name $b) reverted=$(rc_name $c) | repro: clean=$r1 bug=$r2 reverted=$r3 | modified-after-revert=$pristine"
done
echo "== done $(date)"
