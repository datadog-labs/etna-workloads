# Rationale
Hunk: ocaml/typing/ctype.ml, `unify3`: removed the `(Tunivar _, Tunivar _) -> unify_univar_for ...; link_type t1' t2'` case from the `match (d1, d2)` (the "handle vars and univars specially" match).
It reverses fix.diff hunk `@@ -1616,6 +1616,12 @@ and unify3 env t1 t1' t2 t2'`, which added the special univar/univar case. In today's code that case is merged with the Tvar cases, so removing it means two universal variables reaching unify3 (e.g. after abbreviation expansion `'a t = 'a`) go through the generic link path without unify_univar.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-poly/poly.ml fails. Final `make clean && make -j8 && make -j8 ocamltest` + run-oracle.sh: poly.ml still fails.
