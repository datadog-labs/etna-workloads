# Rationale
One hunk, in `ocaml/typing/ctype.ml`, function `unify2_expand` (today's `unify2`).
It restores the `expand_both` fixpoint loop. The loop re-expands both types until the representatives are stable.
It replaces the double `ignore (expand_head_unif ...)` followed by a single re-expansion.

This reverses the fix.diff hunk `@@ -2346,14 +2348,11 @@ let rec unify (env:Env.t ref) t1 t2 =`.
With the loop back, `testsuite/tests/typing-poly/poly.ml` hangs on the cyclic class types (PR#6954) until it is killed (exit code -9).

I did not reverse the first `expand_abbrev_gen` hunk (`Some ty'` / `assert (ty != ty')`). Today's code is structured differently.

Commands run:
- `make -j8 && make -j8 ocamltest && sh run-oracle.sh`: build OK, `poly.ml` failed.
- `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: build OK, `poly.ml` failed.
