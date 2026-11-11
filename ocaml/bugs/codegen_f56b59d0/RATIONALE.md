# Rationale
Hunk: ocaml/lambda/translmod.ml, transl_store_structure, Tstr_open `Tstr_structure` case, `store_idents` base case.
Changed `transl_store ~scopes rootpath (add_idents true ids0 subst) cont rem` back to use plain `subst`.
Reverses fix.diff hunk `@@ -1104,7 +1104,8 @@ let transl_store_structure glob map prims aliases str =`.
Result: `open struct ... end` on clambda backend hits Misc.Fatal_error in ocamlopt.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> clambda_optim.ml failed (Fatal error: Misc.Fatal_error).
Final `make clean && make -j8 && make -j8 ocamltest`, then run-oracle.sh: test fails.
