# Rationale
Hunk: ocaml/typing/typedecl_variance.ml, `compute_variance_gadt`: replaced the commented-out line with
`let tyl = List.map (Ctype.expand_head env) tyl in`, so the GADT return-type parameters are expanded before
free variables are checked. This reverses fix.diff hunk `@@ -690,7 +691,8 @@ let compute_variance_gadt ...` in typing/typedecl.ml
(the fix replaced expand_head by repr). Other fix hunks (debug comment; `if check` in free_variables) have no equivalent
in today's code (the fvl computation is already inside the `check` branch), so nothing to revert.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> pr5985.ml fails (`type _ g = G : 'a -> 'a t g` is accepted instead of
rejected). Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: failed as expected.
