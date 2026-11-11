# Rationale
File: ocaml/typing/ctype.ml. Reverses fix.diff hunk `@@ -2200,11 +2200,11 @@ and unify3 env t1 t1' t2 t2'`
(occur check `occur !env t1' t2` / `occur !env t2' t1` instead of `occur !env t1 t2'` / `occur !env t2 t1'`).
Today both branches share `unify3_var`; it now takes the original (unrepresented, possibly unexpanded abbreviation)
type `t1` and runs `occur_for Unify uenv t1 t2'` instead of `occur_for Unify uenv t1' t2`, so the cycle
`'a` in `'a list` through `'a t = 'a` goes undetected. Both call sites pass the extra argument.
The other fix hunk (`unify_eq` vs `t1 == t2` in `unify`) is a no-op today since unify_eq is eq_type (reprs); not changed.
Tests/Changes hunks not reverted.
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> occur_check.ml failed; final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh -> occur_check.ml failed.
