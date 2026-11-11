# Rationale
File: ocaml/typing/ctype.ml, unify3 case `Tconstr (p1,tl1), Tconstr (p2,tl2)` in pattern mode.
Today's code unifies only injective parameters (others are reified). I replaced that
with a plain `unify_list uenv tl1 tl2`, so abstract type constructors are assumed injective.
This reverses the fix hunk `@@ -2244,7 +2244,14 @@ and unify3 env t1 t1' t2 t2'` (the fix added the
non-injective fallback; the 2013 form was a snapshot/backtrack+reify, today's form is the variance/injectivity check).
The other fix hunk (`@@ -2267,7 +2274,7 @@`, mcomp guard) has no direct analogue and was left alone.
Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> tests/typing-gadts/pr5981.ml fails.
