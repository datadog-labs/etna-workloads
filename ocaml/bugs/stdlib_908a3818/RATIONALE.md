# Rationale
File: ocaml/stdlib/list.ml, `compare_length_with`.
Reverses the hunk `@@ -475,9 +475,11 @@ let rec compare_lengths l1 l2 =` of fix.diff (PR#7513): restores the
pre-fix tuple-match form (`match l, n with | [], 0 | [], _ | _, 0 | _ :: l, n -> ...`).
The exact pre-fix code passed the oracle test (the test only checks negative n against the empty list),
so the `[], _` case computes the result as `0 - n` instead of by sign, which overflows for n = min_int
(same overflow class as the PR title).
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> tests/lib-list/test.ml failed
(assertion at line 109, `compare_length_with [] min_int > 0`). The exact original code first passed, hence the tweak.
