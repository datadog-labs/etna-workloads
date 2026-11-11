# Rationale
Fix: #13501 "Resuscitate Typedecl.update_type". In 5.5.2 the outer-scope hunk
(`@@ -1103,6 +1103,8 @@ let transl_type_decl` adding `Ctype.with_local_level_generalize`) is already
structured differently, so reversing it has no effect. The bug the fix removed was the
absence of `Typedecl.update_type` (regression from #12180), so I re-introduced that.

Hunks, all in ocaml/typing/typedecl.ml (the fix's hunks only restore update_type's use/scope):
1. Removed the `begin match rec_flag ... update_type temp_env new_env id ... end;` call in
   `transl_type_decl` (undoes the resuscitation of update_type in the fix; the fix's
   hunk headers are `@@ -1103,6 +1103,8 @@` and `@@ -1231,6 +1233,7 @@ let transl_type_decl`).
2. Removed the now-unused `update_type` function and the now-unused `temp_env` component
   of the tuple returned by the first scoped block (needed to avoid unused warnings-as-errors).

Commands: `make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh`
Result: tests/typing-modules/mixmod5.ml fails (expect output differs: unbound type variable error).
