# Rationale
One hunk, in `ocaml/typing/ctype.ml`, function `unify3`. It reverses the fix.diff hunk
`@@ -2246,20 +2247,20 @@ and unify3 env t1 t1' t2 t2' =` (and its leading part `@@ -2165,14 +2165,15 @@`, which is only re-indentation).

The fix moved the `if create_recursion then match ... Tconstr ... link_type` block.
It had been outside the `begin match (d1,d2)` (var/univar/field/default) construct.
The fix put it inside the default arm's `try`, after the structural unification.
I moved it back out: it now runs after the outer `end`, for every case including the Tvar cases,
and outside the `try ... with Unify_trace` handler that restores `t1'.desc`.

Build/test: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest`. Result: tests/typing-misc/constraints.ml fails.
The expect process is killed (exit -9 / timeout) on the looping unification.
A first attempt that moved the block out of the `try` only passed, so I discarded it.
