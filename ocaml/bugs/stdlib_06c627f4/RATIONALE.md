# Rationale
Hunk: ocaml/stdlib/set.ml, `map`: final branch `else try_join l' v' r'` changed to `else join l' v' r'`.
Reverses fix.diff hunk `@@ -383,12 +392,7 @@ ... let rec map f = function` (which replaced the
unchecked/ordering-dependent join with `try_join`). Now Set.map with order-changing f builds an ill-ordered set.
Ran: make clean && make -j8 && make -j8 ocamltest; sh run-oracle.sh -> lib-set/testset.ml fails (assert line 284).
