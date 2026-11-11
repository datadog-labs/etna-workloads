# Rationale

Hunk: ocaml/typing/typecore.ml, `extract_concrete_record`.
It now returns `Record_type (p0, p, [])` for any concrete non-record typedecl, instead of `Not_a_record_type`.
Reverses the fix.diff hunk `@@ -242,14 +242,21 @@ let extract_option_type env ty =`.
That hunk added `extract_concrete_record`, which raised Not_found for non-record types.
Before the fix, the code used `extract_concrete_typedecl` for every type, so a non-record type was still treated as a record path.
Effect: `r.y <- 3` with `r : int` no longer reports "not a record type". It reports a different, worse error ("There is no field y within type int"), and the record-pattern errors change too.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`.
Result: tests/typing-misc/records.ml fails.
The final `make clean` rebuild was not run. Only the incremental build was tested.
