# Rationale
One hunk, typing/ctype.ml `add_gadt_equation`: removed the
`if has_free_univars env destination then occur_univar_or_unscoped ~inj_only:true env destination else`
guard, leaving `if local_non_recursive_abbrev uenv source destination then begin`.
Reverses fix.diff hunk `@@ -2442,7 +2453,9 @@ let find_expansion_scope ... add_gadt_equation`.
Universal variables can again leak through GADT equations.

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-gadts/pr10189.ml fails.
