# Rationale
Hunk: ocaml/asmcomp/cmm_helpers.ml, `mod_int` (the old asmcomp/cmmgen.ml code moved here).
Reverses fix.diff hunk `@@ -347,9 +347,9 @@ let mod_int c1 c2 dbg =`: the case `(c1, Cconst_int ((1 | -1), _)) -> Csequence(c1, Cconst_int 0)` is restored to the buggy `(c1, Cconst_int (1, _)) -> c1`, so `n mod 1` returns n (PR#6749) and `n mod (-1)` falls through to the generic path.
The fix's second change (`Cconst_int(0|1|-1) as c1` case) no longer exists in today's code, so nothing to revert. Test/Changes hunks not touched.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`: tests/basic/divint.ml native => failed (output differs from reference), bytecode passed.
