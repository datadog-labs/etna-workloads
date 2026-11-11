# Rationale
File: ocaml/typing/typedecl.ml (in check_recursion), two edits undoing fix.diff's typing/typedecl.ml hunks:
1. `@@ -444,7 +444,7 @@ check_recursion`: Tpoly case now calls `Ctype.instance_poly tl ty` without `~keep_names:true`.
2. `@@ -463,7 +463,8 @@ check_recursion`: `instance_parameterized_type decl.type_params body` without `~keep_names:true`.
Effect: type variable names are lost in the regularity check, so the error message for non-regular types is confusing (PR#5224).
Other fix hunks (btype/ctype optional arg plumbing) left in place; they already exist today.
Commands: `make clean; make -j8 && make -j8 ocamltest; sh run-oracle.sh` -> tests/typing-poly/poly.ml fails (both runs).
