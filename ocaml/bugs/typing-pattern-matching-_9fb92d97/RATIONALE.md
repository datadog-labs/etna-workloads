# Rationale
Hunk: ocaml/typing/typedtree.ml, `iter_bound_idents`, `Tpat_alias` case. Reverses the fix.diff hunk
`@@ -813,9 +814,9 @@ let rec iter_bound_idents`: the alias variable is again reported with the
alias pattern's `pat_type` instead of the type stored in the pattern (`ty`). The stored
type field is left in place (the fix's other hunks are only the constructor-arity plumbing).
This yields wrong value kinds for as-bound variables -> segfault in tests/asmcomp/regression_value_kinds.ml.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> regression_value_kinds fails (exit -11).
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: same failure.
