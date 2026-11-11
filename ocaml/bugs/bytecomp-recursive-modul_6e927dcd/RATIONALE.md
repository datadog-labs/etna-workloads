# Rationale
Hunk: ocaml/lambda/translmod.ml, `extract_unsafe_cycle`: the `Inprogress Some i` case no longer accumulates the intermediate node (`collect stop l i` instead of `collect stop (info i::l) i`). The error then prints only the start of the cycle rather than the whole cycle.
Reverses fix.diff hunk `@@ -258,23 +271,26 @@ let reorder_rec_bindings bindings` / the added `extract_unsafe_cycle` (MPR#7663 "print the whole cycle"). The code has since evolved, so this is the equivalent in today's code.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: basic-modules/recursive_module_evaluation_errors.ml fails (3 "failed" lines).
