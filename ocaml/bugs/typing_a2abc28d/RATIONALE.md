# Rationale
Hunk: ocaml/typing/ctype.ml, `mcomp`, case `(Tconstr (p,_,_), _) | (_, Tconstr (p,_,_))`.
Changed `if is_datatype decl then raise Incompatible` to
`if in_current_module p && is_datatype decl then raise Incompatible`.
Reverses fix.diff hunk `@@ -2059,7 +2059,7 @@ let rec mcomp type_pairs env t1 t2 =`, which added
`|| is_datatype decl` to the check, so datatypes reached through a module path
(e.g. `A.nil`) are also treated as incompatible. Without it, only local (Pident) types are,
so the GADT case in pr6817 is wrongly seen as non-exhaustive.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: typing-gadts/pr6817.ml fails (3 "failed" lines in the output).
