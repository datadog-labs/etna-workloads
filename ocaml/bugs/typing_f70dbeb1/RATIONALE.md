# Rationale
One hunk, in ocaml/typing/ctype.ml, `add_gadt_equation`: the local-constraint expansion scope changed from
`Int.max (Path.scope source) (get_equations_scope uenv)` to `Path.scope source`.
This reverses the fix.diff hunk in typing/env.ml `@@ add_local_constraint` ("use the newtype level for this
definition, lv is the old one"), which stored the match-level (mlv) rather than the old level on the constraint
definition. In today's code that level is the equation scope. Without it, local equations are no longer scoped
to the match, so external constraints leak (test.ml "Effect of external constraints").
Commands: `make -j8 && make -j8 ocamltest && sh run-oracle.sh` -> typing-gadts/test.ml fails, omega07.ml passes.
Final `make clean && make -j8 && make -j8 ocamltest` then run-oracle.sh: test.ml fails.
