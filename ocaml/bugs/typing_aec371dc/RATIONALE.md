# Rationale
Hunk: ocaml/typing/ctype.ml, `local_non_recursive_abbrev`: the fallback `| _ ->` case
now does nothing, instead of recursing with `strict=true` through `iter_type_expr` when
`strict || not allow_rec`. This reverses fix.diff hunk
`@@ -1641,18 +1642,20 @@ let rec local_non_recursive_abbrev ...` (the `| _ -> if strict then (* PR#7374 *) iter_type_expr ...` part).
Contractiveness check is again unsound with constraints.
Commands: `make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`; typing-gadts/pr7374.ml fails.
Final: `make clean && make -j8 && make -j8 ocamltest`, run-oracle.sh: pr7374.ml fails.
