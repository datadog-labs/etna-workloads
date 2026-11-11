# Rationale
Hunk: ocaml/typing/typedecl.ml, `check_well_founded`: the final call
`Ctype.wrap_trace_gadt_instances env (check TypeSet.empty []) ty0` became `check TypeSet.empty [] ty0`.
Reverses fix.diff hunk `@@ -512,7 +512,7 @@ let check_well_founded env loc path to_check ty =`
(which added the wrap_trace_gadt_instances wrapper), re-expressed in today's code.
Without it, GADT instance equations are not tracked, so the cyclic `type d = d * d` loops/overflows (test typing-misc/wellfounded.ml killed).
Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: wellfounded.ml fails (exit -9).
