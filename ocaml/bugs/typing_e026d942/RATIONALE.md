# Rationale
All changes in ocaml/typing/ctype.ml, reversing fix.diff's ctype.ml hunks:
- `@@ -1969,13 +1971,20 @@ let rec unify_univar` : `unify_univar` again ends with `Misc.fatal_error "Ctype.unify_univar: univar not in scope"` instead of raising `Out_of_scope_universal_variable`; the exception declaration (`@@ -134,6 +134,8 @@`) is removed; `unify_univar_for` loses its Out_of_scope handler (Equality exemption).
- `@@ -2393,8 +2411,10 @@ let rec mcomp`: the Tunivar/Tunivar case no longer tolerates out-of-scope univars (back to `try ... with Cannot_unify_universal_variables _ -> raise Incompatible`).
Comment-only hunks of the fix and Changes/tests were not reverted.

Commands: `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
Result: pr13495.ml fails (typechecker fatal error); pr13514.ml passed.
