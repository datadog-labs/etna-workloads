# Rationale
Hunk: ocaml/typing/ctype.ml, `allow_recursive_equations`: now only `!Clflags.recursive_types` (dropped `|| in_counterexample uenv`).
Reverses fix.diff hunk `@@ -1652,9 +1652,12 @@ ... let allow_recursive env ty` (which added `|| !umode = Pattern` to the occur check; today's equivalent is in_counterexample).
Commands: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> pr6993_bad.ml fails.
