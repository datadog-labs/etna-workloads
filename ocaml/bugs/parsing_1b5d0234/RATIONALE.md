# Rationale

Hunk: `ocaml/typing/typemod.ml`, `patch_deep_item` (in `Merge`): the match
`| Mty_alias _, false ->` became `| _, false ->`. Deep non-destructive
constraints (`with type M.t = ...`) in submodules no longer update the
submodule's signature; the original item is kept.

Reverses fix.diff hunk `@@ -1485,9 +1485,10 @@ with_constraint:` (parser.mly), whose theme (PR#5911) is
that deep `with` constraints on submodules were mishandled. The parser
hunk itself can't be reversed literally: today's grammar deliberately
accepts long identifiers there. So the bug is re-expressed in the typing of
deep constraints. This is an approximation; no .mly change was made.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh. Result:
typing-modules/pr5911.ml fails (`X.M.x` has type `X.M.t` but unit expected).
