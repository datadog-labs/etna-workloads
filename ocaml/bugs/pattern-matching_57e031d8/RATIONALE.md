# Rationale
Hunk: ocaml/typing/parmatch.ml, `matrix_stable_vars`, empty-rows case: `reduce (List.map2 Ident.Set.inter) rows_varsets` changed to `List.map2 Ident.Set.union`.
Reverses fix.diff hunk `@@ -2216,10 +2216,10 @@ let rec do_stable rs = match rs with` (union <-> intersection mix-up in the stable-variable computation; code was since rewritten, so this is the equivalent spot). The `all_rhs_idents` whitespace hunk and test hunks are not reproduced.
Effect: variables bound at different positions in different or-alternatives are deemed stable, so the Warning 57 in ambiguous_guarded_disjunction.ml is missed.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> ambiguous_guarded_disjunction.ml failed. (An attempt using a different union->inter edit broke the stdlib build and was dropped.) Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: test fails.
