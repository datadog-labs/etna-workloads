# Rationale
File: ocaml/typing/ctype.ml, in `unify3`, case `(Tvariant row1, Tvariant row2)`.
Reverses hunk `@@ -2287,7 +2287,17 @@ and unify3 env t1 t1' t2 t2'` of typing/ctype.ml. The fix made pattern mode backtrack when unify_row fails, then reify both types and add an incompatibility check and equation. I restored the plain `unify_row uenv row1 row2`. Private rows are therefore assumed unequal in GADT patterns (PR#5989).
Only ctype.ml changed. The other hunks in fix.diff are tests and Changes.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`.
Result: pr5689.ml and pr5989.ml fail.
