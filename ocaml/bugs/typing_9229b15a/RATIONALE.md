# Rationale
One hunk, in typing/ctype.ml, function `eqtype_list_same_length` (the wrapper before `eqtype`).
Removed the `Btype.snapshot ()` / `backtrack snap` (try_finally) around the equality check, so
unifications done during eqtype are no longer undone.
Reverses fix.diff hunk `@@ -3291,19 +3276,23 @@ and eqtype_row ...`, which added the snapshot/backtrack wrapper in
`eqtype_list` (and made `eqtype` go through it). This is the PR#6980 fix.
(The other hunks, generalize cleanup, are refactors, not behavior.)

Commands: `make clean && make -j8 && make -j8 ocamltest && sh run-oracle.sh`
Result: typing-gadts/pr6980.ml fails (Assertion failed at ctype.ml, in expect output).
