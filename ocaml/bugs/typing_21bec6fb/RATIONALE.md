# Rationale

One hunk, `ocaml/typing/ctype.ml`, in `unify1_var`.
It now links the variable to the type first (`link_type t1 t2`). It then calls `update_level` and `update_scope`, and it does not undo the link if they raise `Escape`. The levels and scope of `t1` are captured before the link, because `get_level` and `get_scope` follow the link.

This reverses the fix hunk `@@ -2321,6 +2321,18 @@ let unify_eq env t1 t2 =`, which added `unify1_var`. That function linked and then updated the level, restoring `t1.desc <- d1` on failure. Today's code updates the level before linking, so it never needs the restore. The reintroduced bug leaves the variable linked after a failed unification. As a result, the "type would escape its scope" error messages show the expected type as the full type instead of `'a`, which is the confusing output of PR#6171.

I did not revert the test-file hunks in fix.diff (they are not implementation files).

Commands run:
- `cd ocaml && make -j8 && make -j8 ocamltest && cd .. && sh run-oracle.sh`
- A final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.

Result: test.ml, pr6123_bad.ml, poly.ml and newtype.ml fail. pr6158.ml and pr6690.ml pass.
