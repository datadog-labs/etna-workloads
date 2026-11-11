# Rationale
One hunk, in `typing/data_types.ml` (the function moved there from typing/types.ml): `may_equal_constr`.
Reverses fix.diff hunk `@@ -440,9 +440,14 @@ let equal_tag t1 t2 =` (typing/types.ml). The arity check is restored to apply only to extension-constructor pairs; other constructors are compared by tag only, so incoherent rows (Node _ vs Variant (_,_)) are treated as equal, giving an assertion failure in lambda/matching.ml.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result: basic-more/pr10294.ml fails (Assertion failed at matching.ml:750).
