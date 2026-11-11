# Rationale
- ocaml/typing/typemod.ml, `type_decl_is_alias`: removed the guard `when List.length stl = List.length sdecl.ptype_params` on the `Ptyp_constr (lid, stl)` case. This reverses the fix hunk `@@ merge_constraint ...` in typing/typemod.ml (which added that guard). Without it, `with type 'a t := unit` (arity mismatch) is no longer rejected properly (List.iter2 raises Invalid_argument / wrong behaviour).
- Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` (after make clean); tests/typing-sigsubst/sigsubst.ml fails.
