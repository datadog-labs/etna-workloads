# Rationale
Hunk: ocaml/typing/ctype.ml, `occur_rec`, Tconstr case. Changed
`if allow_recursive && is_contractive env p then () else` to `if allow_recursive then () else`
(and renamed `p` to `_p` to avoid unused-variable warning-as-error).
This reverses the fix.diff hunk `@@ -1651,10 +1651,11 @@ exception Occur` (and its siblings), which
added the `is_contractive` check to the -rectypes occur check; today's code expresses it in the Tconstr branch.
Without it, -rectypes accepts non-contractive types (PR#6870).
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final `make clean && make -j8 && make -j8 ocamltest` and oracle: pr6870_bad.ml => failed.
