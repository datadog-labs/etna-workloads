# Rationale

Only `ocaml/typing/typecore.ml` was changed, in `collect_apply_args`. The change reverses the typecore.ml hunks of fix.diff:
- `@@ -2942,7 +2942,7 @@ let collect_unknown_apply_args ...`: `loop` no longer takes `visited`.
- `@@ -2970,23 +2970,27 @@ ...`: removed the `visited`/`terminate` tracking, so the loop no longer stops when it sees the same `ty_fun` again.
- `@@ -3001,10 +3005,17 @@ ...`: same removal in the commuting-labels branch, and the `if terminate then ...` shortcut.
- `@@ -3028,10 +3039,10 @@ ...`: `loop visited ...` goes back to `loop ...`. This covers both recursive calls and the initial call.

I did not revert the out_type.ml hunks. They are the printing side of the fix.

Effect: with `#rectypes`, applying an argument to a type like `?opt:int -> 'a as 'a` makes `collect_apply_args` recurse forever (unbounded optional arguments).

Commands run:
- `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`. The build succeeded. The oracle test `typing-labels/pr13658.ml` hangs. I killed it after 20s with `timeout`, rc=124. The run's own ocamltest `-timeout 300` would mark it failed.
- `make clean && make -j8 && make -j8 ocamltest`: succeeded. I did not re-run the oracle after this clean build.
