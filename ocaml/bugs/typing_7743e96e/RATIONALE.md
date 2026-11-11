# Rationale
Hunk: ocaml/typing/typetexp.ml, in transl_fields (`< t >` inheritance case): the match guard
`Tfield _ | Tnil -> true` became `Tfield _ -> true`, so an empty object type (`< >`) included in an
object type is no longer accepted. Reverses fix.diff hunk `@@ -674,7 +674,8 @@ and transl_fields env policy seen o =`
(which added `Tnil` to the pattern), re-expressed for today's code.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> poly.ml fails.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: poly.ml fails.
