# Rationale
Hunk: ocaml/typing/typedecl.ml, in `transl_type_decl`, the `abs_env` construction. It now calls `enter_type rec_flag` with no `~abstract_abbrevs`. So the temporary env keeps expandable manifests instead of abstract ones. This reverses the hunk `@@ -1127,7 +1127,7 @@ let transl_type_decl env rec_flag sdecl_list =` (`~abstract_abbrevs:false` -> `true`). In today's code the argument is `Some Rec_check_regularity` instead of a bool.
Result: the bad error message for mutually recursive abbreviations (#12334) returns.

Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`. Result: tests/typing-misc/constraints.ml fails (diff in the expected error message).
