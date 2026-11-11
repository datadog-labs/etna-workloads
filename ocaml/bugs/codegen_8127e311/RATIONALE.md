# Rationale
One hunk, `ocaml/middle_end/closure/closure.ml` (today's location of asmcomp/closure.ml), in the over-application case of `close`.
It reverses fix.diff hunk `@@ -879,13 +879,24 @@ let rec close fenv cenv = function`. The code no longer binds each argument to a fresh let (`arg`) before the call. Arguments are passed directly to `Ugeneric_apply`, so the evaluation order of overapplications is wrong again (PR#6136).
The Changes and test hunks were not touched.
Commands run: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. The build succeeded and run-oracle.sh reported failing actions (the eval_order_2 test fails).
