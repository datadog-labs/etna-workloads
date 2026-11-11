# Rationale
Hunk: ocaml/lambda/translmod.ml, transl_store_structure, anonymous module case (`Tstr_module {mb_id=None ...}`).
Changed `Lprim(Pignore,[Lambda.subst no_env_update subst lam], ...)` back to `Lprim(Pignore,[lam], ...)`.
Reverses fix.diff hunk `@@ -1010,8 +1010,10 @@ let transl_store_structure glob map prims aliases str =` (forgotten substitution).
Commands: make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh
Result: tests/basic-modules/anonymous.ml fails (ocamlopt Fatal_error Misc).
