# Rationale
Hunk: ocaml/middle_end/closure/closure.ml, `close_functions`.
Reverses fix.diff hunk `@@ -1247,15 +1247,27 @@ and close_named env id = function`: removed the
`match fun_defs with [Always_inline] -> fun_defs` special case (and its comment), so functions with
optional args/default values are always split into wrapper+inner, even with `[@inline always]`.
Only the closure.ml hunk is reverted; the Changes and test hunks are not implementation.

Commands: `make clean && make -j8 && make -j8 ocamltest` (ok), then `sh run-oracle.sh`:
tests/asmcomp/optargs fails (run action: exit code 2, the new allocation assert).
