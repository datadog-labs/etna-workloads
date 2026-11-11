# Rationale
Fix: #8702 "fix some polymorphic variant error messages" (#8777). It reports the reason a variant row is fixed in error messages.

Today's code keeps the `fixed_explanation`/`Fixed_row` machinery, so the fix can't be reversed wholesale. I removed its user-visible effect in `ocaml/typing/ctype.ml`, in two places:
1. `unify_row`'s `set_more`, hunk `@@ -2845,10 +2855,18 @@ and unify_row env row1 row2 =`. The fixed-row case no longer raises `Fixed_row(pos,Cannot_add_tags ...)`. It raises the old `No_tags(pos,rest)` instead.
2. `unify_row_field`'s `if_not_fixed`. It raises `Incompatible_types_for l` instead of `Fixed_row(pos,Cannot_add_tags [l],fix)`. This is the old "Types for tag ... are incompatible" message. The position is now unused, so the parameter is renamed `_pos`.

Result: errors say "does not allow tag(s)" instead of "bound to the universal type variable ..., it may not allow the tag(s)".

Commands run: `make -j8 && make -j8 ocamltest && sh run-oracle.sh`, then a final `make clean && make -j8 && make -j8 ocamltest` and `sh run-oracle.sh`. All 5 oracle tests (pr5689, pr6980, polyvars, error_messages, poly) fail.
