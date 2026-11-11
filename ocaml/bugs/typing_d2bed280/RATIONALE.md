# Rationale
Hunk: ocaml/typing/ctype.ml, `mcomp` (Tconstr vs. other case). Changed
`if is_datatype decl then raise Incompatible` to
`if in_pervasives p && decl.type_manifest = None then raise Incompatible`.
Reverses fix.diff hunk `@@ -2068,7 +2068,7 @@ let rec mcomp type_pairs env t1 t2 =`, which added
`|| is_datatype decl` to the `non_aliasable p decl` check. Today `non_aliasable` was
refactored into the in_pervasives/no-manifest test plus is_datatype, so the bug is
the check without the datatype part.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr6817.ml fails.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: pr6817.ml failed (expect output differs).
