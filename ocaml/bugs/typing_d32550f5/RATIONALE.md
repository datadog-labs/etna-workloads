# Rationale

Fix: #8550 "Soundness issue with class generalization". The hunk in `fix.diff` is
`@@ -897,23 +904,21 @@ let rec generalize_expansive env var_level visited ty =` (typing/ctype.ml).
That hunk made `lower_contravariant` lower the variables under a `May_weak` (invariant) type
parameter, instead of calling `generalize_structure var_level` on it.

Change (only file: `ocaml/typing/ctype.ml`):
- Added `generalize_structure_lower`. It generalizes the non-variable structure of a type and
  lowers the variables it meets. This stands in for the old `generalize_structure var_level`,
  which no longer exists in the pool-based level code.
- In `lower_contravariant`, the `Tconstr` case with `Variance.mem May_weak v` now calls
  `generalize_structure_lower var_level t`. It used to call `lower_rec true t`. This reverses the
  `-  then generalize_structure var_level t` / `+  then generalize_rec true t` lines of that hunk.

The other hunks of the fix are renames, API changes and the test. They need no reversal.
The `Tpackage` and `Tarrow` hunks are left as they are, because reverting them changes nothing the test sees.

Result: `class ['a] r = let r : 'a = ref [] in object method get = r end` is accepted, with the
weak variable wrongly generalized.

Commands run:
`make clean && make -j8 && make -j8 ocamltest`, then `sh run-oracle.sh`.
The build succeeded. `tests/typing-poly/poly.ml` fails: the #8550 expect-test no longer reports the error.
