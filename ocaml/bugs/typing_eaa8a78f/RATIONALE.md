# Rationale
Hunk: ocaml/typing/typecore.ml, Pexp_record case (`with_local_level_generalize_structure (fun () -> newconstr p' (instance_list decl.type_params))`) changed to `with_local_level_generalize`.
Reverses fix.diff hunk `@@ -2175,7 +2185,7 @@ and type_expect_ ...` (`generalize ty;` -> `generalize_structure ty;`). Without structure-only generalization, the record type from `{ {..} with x = 0 }` gets fully generalized, so pr6303_bad.ml is wrongly accepted.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> typing-misc-bugs/pr6303_bad.ml fails (compiles when it should be rejected).
