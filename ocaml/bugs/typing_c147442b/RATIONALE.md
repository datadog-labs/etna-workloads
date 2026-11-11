# Rationale
Single hunk in `ocaml/typing/ctype.ml`, `update_level`: reverses fix.diff hunk
`@@ -837,8 +837,18 @@ let rec update_level env level expand ty =`.
The `Tconstr(p, (_ :: _ as tl), _)` case (variance lookup, `needs_expand` when a
parameter has null variance and a too-deep level, `if not needs_expand then raise Cannot_expand`)
was restored to the old `Tconstr(_, _ :: _, _) when expand ->` case, so vanishing
parameters are no longer expanded.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then final
`make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh: pr5673_ok.ml, poly.ml, pr7636.ml all fail.
