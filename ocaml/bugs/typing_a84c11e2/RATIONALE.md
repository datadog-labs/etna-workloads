# Rationale
Hunk: ocaml/typing/ctype.ml, `local_non_recursive_abbrev`: the expansion call
`try_expand_head try_expand_safe_opt env ty` is now `try_expand_head try_expand_safe env ty`.
Reverses fix.diff hunk `@@ -1685,7 +1685,7 @@ let rec local_non_recursive_abbrev strict visited env p ty =`
(which changed try_expand_once to try_expand_once_opt; in today's code the equivalent is the safe/_opt variant).
Other fix hunks (Changes, test, a comment) are not code.

Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and run-oracle.sh.
Result: typing-gadts/pr7747.ml fails (the invalid cast M.t :> N.t is accepted instead of error).
