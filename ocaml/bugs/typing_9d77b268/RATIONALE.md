# Rationale
Hunk: ocaml/typing/ctype.ml, `lower_contravariant`: `| done_contra -> contra && not done_contra` -> `| _ -> false`.
Reverses fix.diff hunk `@@ -752,37 +752,35 @@ let rec update_level ...` (generalize_expansive gained a `visited` set so a type seen first covariantly is revisited when reached contravariantly). In today's code that logic lives in lower_contravariant's visited table; the bug is a type visited once is never revisited contravariantly, so `x : ('a,'a) foo` is wrongly generalized (PR#7285).
The typecore.ml hunks of the fix (generalize order) have no current equivalent and were not touched.
Commands: final `make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`: tests/typing-poly/poly.ml fails (`val x : ('a, 'a) foo = 3` instead of `'_weak2`).
