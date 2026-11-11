# Rationale
Hunk: ocaml/typing/ctype.ml, `unify_var`: removed the case `Tvar _, Tconstr _ when deep_occur t1 t2 -> unify uenv t1 t2`, merging into `| Tvar _, _ ->`.
Reverses fix.diff hunk `@@ -2770,8 +2770,10 @@ let unify_gadt ...` (typing/ctype.ml), which added that case (today's code uses get_desc/uenv).
Effect: `let f (x : 'a t as 'a)` is no longer rejected (PR#6505).
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> constraints.ml fails, poly.ml passes.
