# Rationale
Hunk: ocaml/typing/typemod.ml, `Pstr_module` case of `type_structure`. Removed the call `Mtype.lower_nongen outer_scope md.md_type;` (and the now-unused `let outer_scope = ...` binding, which otherwise fails the build with warning 26).
Reverses fix.diff hunk `@@ -1291,9 +1291,8 @@ and type_structure ...` in typing/typemod.ml, which added the `Mtype.lower_nongen` call. Without it, non-generalized type variables in a module's type aren't lowered, so PR#7414 is unsound again. pr7414_bad.ml is now accepted, but the test expects a failure.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh`. Result: pr7414_bad.ml fails.
